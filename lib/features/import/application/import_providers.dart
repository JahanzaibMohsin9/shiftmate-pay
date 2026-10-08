import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/identifiers.dart';
import '../../../core/common/result.dart';
import '../../../data/local/database/database_providers.dart';
import '../../../domain/entities/import_preview.dart';
import '../../../domain/entities/shift_instance.dart';
import '../../calendar/application/calendar_providers.dart';
import '../../pay/application/forecast_providers.dart';
import '../../pay/application/pay_providers.dart';

class PickedCsvImportFile {
  const PickedCsvImportFile({required this.name, required this.content});

  final String name;
  final String content;
}

abstract interface class CsvImportFileService {
  Future<PickedCsvImportFile?> pickCsv();
}

class FilePickerCsvImportFileService implements CsvImportFileService {
  const FilePickerCsvImportFileService();

  @override
  Future<PickedCsvImportFile?> pickCsv() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['csv'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = result.files.single;
    final bytes =
        file.bytes ??
        (file.path == null ? null : await File(file.path!).readAsBytes());
    if (bytes == null) {
      return null;
    }

    return PickedCsvImportFile(
      name: file.name,
      content: utf8.decode(bytes, allowMalformed: true),
    );
  }
}

final csvImportFileServiceProvider = Provider<CsvImportFileService>(
  (ref) => const FilePickerCsvImportFileService(),
);

class CsvImportState {
  const CsvImportState({
    this.fileName,
    this.preview,
    this.isPickingFile = false,
    this.isLoadingPreview = false,
    this.isSaving = false,
    this.errorMessage,
    this.importedRowCount,
    this.completedAt,
  });

  final String? fileName;
  final ShiftImportPreviewResult? preview;
  final bool isPickingFile;
  final bool isLoadingPreview;
  final bool isSaving;
  final String? errorMessage;
  final int? importedRowCount;
  final DateTime? completedAt;

  CsvImportState copyWith({
    Object? fileName = _sentinel,
    Object? preview = _sentinel,
    bool? isPickingFile,
    bool? isLoadingPreview,
    bool? isSaving,
    Object? errorMessage = _sentinel,
    Object? importedRowCount = _sentinel,
    Object? completedAt = _sentinel,
  }) {
    return CsvImportState(
      fileName: identical(fileName, _sentinel)
          ? this.fileName
          : fileName as String?,
      preview: identical(preview, _sentinel)
          ? this.preview
          : preview as ShiftImportPreviewResult?,
      isPickingFile: isPickingFile ?? this.isPickingFile,
      isLoadingPreview: isLoadingPreview ?? this.isLoadingPreview,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      importedRowCount: identical(importedRowCount, _sentinel)
          ? this.importedRowCount
          : importedRowCount as int?,
      completedAt: identical(completedAt, _sentinel)
          ? this.completedAt
          : completedAt as DateTime?,
    );
  }
}

const _sentinel = Object();

final csvImportControllerProvider = StateNotifierProvider.autoDispose
    .family<CsvImportController, CsvImportState, String>(
      (ref, jobId) => CsvImportController(ref: ref, jobId: jobId),
    );

class CsvImportController extends StateNotifier<CsvImportState> {
  CsvImportController({required Ref ref, required String jobId})
    : _ref = ref,
      _jobId = jobId,
      super(const CsvImportState());

  final Ref _ref;
  final EntityId _jobId;

  Future<void> pickAndPreviewFile() async {
    state = state.copyWith(
      isPickingFile: true,
      errorMessage: null,
      importedRowCount: null,
      completedAt: null,
    );

    try {
      final picked = await _ref.read(csvImportFileServiceProvider).pickCsv();
      if (picked == null) {
        state = state.copyWith(isPickingFile: false);
        return;
      }

      await previewCsvContent(
        fileName: picked.name,
        csvContent: picked.content,
      );
    } catch (error) {
      state = state.copyWith(
        isPickingFile: false,
        isLoadingPreview: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> previewCsvContent({
    required String fileName,
    required String csvContent,
  }) async {
    state = state.copyWith(
      fileName: fileName,
      isPickingFile: false,
      isLoadingPreview: true,
      errorMessage: null,
      importedRowCount: null,
      completedAt: null,
    );

    final result = await _ref
        .read(buildShiftImportPreviewUseCaseProvider)
        .call(jobId: _jobId, csvContent: csvContent);

    state = result.when(
      success: (preview) =>
          state.copyWith(preview: preview, isLoadingPreview: false),
      failure: (error) => state.copyWith(
        preview: null,
        isLoadingPreview: false,
        errorMessage: error.message,
      ),
    );
  }

  Future<Result<int>> importAcceptedRows() async {
    final preview = state.preview;
    if (preview == null) {
      return Failure(
        const AppError(
          code: 'import_preview_missing',
          message: 'Load a CSV preview before importing.',
        ),
      );
    }

    final acceptedRows = preview.rows
        .where((row) => row.status == ImportPreviewRowStatus.accepted)
        .map((row) => row.proposedShift)
        .whereType<ShiftInstance>()
        .toList(growable: false);
    if (acceptedRows.isEmpty) {
      return Failure(
        const AppError(
          code: 'import_no_accepted_rows',
          message: 'There are no accepted rows ready to import.',
        ),
      );
    }

    state = state.copyWith(isSaving: true, errorMessage: null);
    final repository = _ref.read(shiftInstanceRepositoryProvider);
    try {
      for (final instance in acceptedRows) {
        final saveResult = await repository.saveInstance(instance);
        if (saveResult.isFailure) {
          return saveResult.when(
            success: (_) => throw StateError('Unreachable state'),
            failure: (error) => Failure(error),
          );
        }
      }

      await _ref
          .read(reminderNotificationServiceProvider)
          .syncAllReminderSchedules();
      _ref.invalidate(calendarScheduleProvider);
      _ref.invalidate(paySummaryProvider);
      _ref.invalidate(forecastViewProvider);

      state = state.copyWith(
        isSaving: false,
        importedRowCount: acceptedRows.length,
        completedAt: DateTime.now(),
      );
      return Success(acceptedRows.length);
    } catch (error) {
      state = state.copyWith(isSaving: false, errorMessage: error.toString());
      return Failure(
        AppError(
          code: 'import_save_failed',
          message: error.toString(),
          cause: error,
        ),
      );
    }
  }
}
