import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/common/result.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/domain/entities/entities.dart';
import 'package:shiftmate_pay/domain/repositories/repositories.dart';
import 'package:shiftmate_pay/domain/usecases/build_shift_import_preview_usecase_impl.dart';
import 'package:shiftmate_pay/domain/usecases/usecases.dart';

void main() {
  test(
    'builds dry-run preview with accepted, duplicate, conflict, and skipped rows',
    () async {
      const csv = '''
date,start_time,end_time,shift_name,break,holiday,notes
2026-04-04,08:00,16:00,Duplicate day,30,false,Existing
2026-04-05,08:00,18:00,Conflict day,30,false,Changed end
2026-04-06,20:00,08:00,Night import,45,true,Night cover
,09:00,17:00,Skipped row,30,false,Missing date
''';

      final range = AppDateRange(
        start: DateTime(2026, 4, 4),
        end: DateTime(2026, 4, 6),
      );
      final duplicateShift = _buildShift(
        id: 'existing-duplicate',
        date: DateTime(2026, 4, 4),
        startHour: 8,
        startMinute: 0,
        endHour: 16,
        endMinute: 0,
        unpaidBreakMinutes: 30,
        note: 'Existing',
      );
      final generatedConflictShift = _buildShift(
        id: 'generated-conflict',
        date: DateTime(2026, 4, 5),
        startHour: 8,
        startMinute: 0,
        endHour: 16,
        endMinute: 0,
        unpaidBreakMinutes: 30,
        source: ShiftSource.pattern,
      );

      final useCase = BuildShiftImportPreviewUseCaseImpl(
        shiftInstanceRepository: _FakeShiftInstanceRepository({
          _rangeKey(range): [duplicateShift],
        }),
        generateShiftScheduleUseCase: _FakeGenerateShiftScheduleUseCase({
          _rangeKey(range): [generatedConflictShift],
        }),
      );

      final result = await useCase(jobId: 'job-1', csvContent: csv);

      expect(result.isSuccess, isTrue);
      final preview = result.when(
        success: (value) => value,
        failure: (error) => throw error,
      );

      expect(preview.totalRows, 4);
      expect(preview.acceptedRowCount, 1);
      expect(preview.duplicateRowCount, 1);
      expect(preview.conflictRowCount, 1);
      expect(preview.skippedRowCount, 1);

      expect(preview.rows[0].status, ImportPreviewRowStatus.duplicate);
      expect(preview.rows[0].duplicateOfShiftId, 'existing-duplicate');

      expect(preview.rows[1].status, ImportPreviewRowStatus.conflict);
      expect(
        preview.rows[1].conflictedShiftIds,
        contains('generated-conflict'),
      );
      expect(
        preview.rows[1].proposedShift?.overrideType,
        ShiftOverrideType.editGeneratedShift,
      );

      expect(preview.rows[2].status, ImportPreviewRowStatus.accepted);
      expect(preview.rows[2].proposedShift?.source, ShiftSource.imported);
      expect(preview.rows[2].proposedShift?.isHoliday, isTrue);
      expect(
        preview.rows[2].proposedShift?.endDateTime,
        DateTime(2026, 4, 7, 8),
      );

      expect(preview.rows[3].status, ImportPreviewRowStatus.skipped);
      expect(preview.rows[3].message, contains('Date is required'));
    },
  );
}

class _FakeGenerateShiftScheduleUseCase
    implements GenerateShiftScheduleUseCase {
  _FakeGenerateShiftScheduleUseCase(this.shiftsByRange);

  final Map<String, List<ShiftInstance>> shiftsByRange;

  @override
  Future<Result<List<ShiftInstance>>> call({
    required String jobId,
    required AppDateRange range,
  }) async => Success(shiftsByRange[_rangeKey(range)] ?? const []);
}

class _FakeShiftInstanceRepository implements ShiftInstanceRepository {
  _FakeShiftInstanceRepository(this.instancesByRange);

  final Map<String, List<ShiftInstance>> instancesByRange;

  @override
  Future<Result<void>> deleteInstance(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<ShiftInstance?>> getInstanceById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<ShiftInstance>>> listInstancesForRange({
    required String jobId,
    required AppDateRange range,
  }) async => Success(instancesByRange[_rangeKey(range)] ?? const []);

  @override
  Future<Result<ShiftInstance>> saveInstance(ShiftInstance instance) {
    throw UnimplementedError();
  }
}

ShiftInstance _buildShift({
  required String id,
  required DateTime date,
  required int startHour,
  required int startMinute,
  required int endHour,
  required int endMinute,
  required int unpaidBreakMinutes,
  String? note,
  ShiftSource source = ShiftSource.manual,
}) {
  return ShiftInstance(
    id: id,
    jobId: 'job-1',
    date: date,
    templateSnapshot: ShiftTemplateSnapshot(
      templateId: null,
      name: 'Existing shift',
      category: ShiftCategory.custom,
      startMinutesLocal: (startHour * 60) + startMinute,
      endMinutesLocal: (endHour * 60) + endMinute,
      unpaidBreakMinutes: unpaidBreakMinutes,
      defaultNote: note,
    ),
    startDateTime: DateTime(
      date.year,
      date.month,
      date.day,
      startHour,
      startMinute,
    ),
    endDateTime: DateTime(date.year, date.month, date.day, endHour, endMinute),
    unpaidBreakMinutes: unpaidBreakMinutes,
    source: source,
    note: note,
    isHoliday: false,
    overrideType: source == ShiftSource.pattern
        ? null
        : ShiftOverrideType.replaceWithManualShift,
  );
}

String _rangeKey(AppDateRange range) =>
    '${range.start.toIso8601String()}::${range.end.toIso8601String()}';
