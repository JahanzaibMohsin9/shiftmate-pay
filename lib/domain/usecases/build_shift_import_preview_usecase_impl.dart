import '../../core/common/result.dart';
import '../../core/time/app_date_range.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';
import '../services/csv_shift_import_parser.dart';
import '../services/shift_import_preview_builder.dart';
import 'usecases.dart';

class BuildShiftImportPreviewUseCaseImpl
    implements BuildShiftImportPreviewUseCase {
  BuildShiftImportPreviewUseCaseImpl({
    required ShiftInstanceRepository shiftInstanceRepository,
    required GenerateShiftScheduleUseCase generateShiftScheduleUseCase,
    this.parser = const CsvShiftImportParser(),
    this.previewBuilder = const ShiftImportPreviewBuilder(),
  }) : _shiftInstanceRepository = shiftInstanceRepository,
       _generateShiftScheduleUseCase = generateShiftScheduleUseCase;

  final ShiftInstanceRepository _shiftInstanceRepository;
  final GenerateShiftScheduleUseCase _generateShiftScheduleUseCase;
  final CsvShiftImportParser parser;
  final ShiftImportPreviewBuilder previewBuilder;

  @override
  Future<Result<ShiftImportPreviewResult>> call({
    required String jobId,
    required String csvContent,
  }) async {
    final parseResult = parser.parse(csvContent);
    final validRows = parseResult.rows
        .where((row) => row.date != null)
        .toList(growable: false);
    if (validRows.isEmpty) {
      return Success(
        previewBuilder.build(
          jobId: jobId,
          parsedRows: parseResult.rows,
          existingShifts: const [],
        ),
      );
    }

    final range = _rangeFor(validRows);
    final savedResult = await _shiftInstanceRepository.listInstancesForRange(
      jobId: jobId,
      range: range,
    );
    if (savedResult.isFailure) {
      return savedResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }
    final generatedResult = await _generateShiftScheduleUseCase.call(
      jobId: jobId,
      range: range,
    );
    if (generatedResult.isFailure) {
      return generatedResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }

    final savedShifts = savedResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );
    final generatedShifts = generatedResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );
    final existingById = <String, ShiftInstance>{
      for (final shift in generatedShifts) shift.id: shift,
      for (final shift in savedShifts) shift.id: shift,
    };

    return Success(
      previewBuilder.build(
        jobId: jobId,
        parsedRows: parseResult.rows,
        existingShifts: existingById.values.toList(growable: false),
      ),
    );
  }

  AppDateRange _rangeFor(List<ParsedShiftImportRow> rows) {
    final dates = rows.map((row) => row.date!).toList(growable: false)
      ..sort((left, right) => left.compareTo(right));
    return AppDateRange(start: dates.first, end: dates.last);
  }
}
