import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/common/result.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/domain/entities/entities.dart';
import 'package:shiftmate_pay/domain/repositories/repositories.dart';
import 'package:shiftmate_pay/domain/services/pattern_expansion_service.dart';
import 'package:shiftmate_pay/domain/usecases/generate_shift_schedule_usecase_impl.dart';

void main() {
  group('GenerateShiftScheduleUseCaseImpl', () {
    final pattern = ShiftPattern(
      id: 'pattern-1',
      jobId: 'job-1',
      name: 'Rotation',
      cycleLengthDays: 2,
      startDate: DateTime(2026, 1, 1),
      timezone: 'local',
      isActive: true,
    );
    final entries = [
      const ShiftPatternEntry(
        id: 'entry-1',
        patternId: 'pattern-1',
        dayOffset: 0,
        shiftTemplateId: 'template-1',
        isOffDay: false,
      ),
      const ShiftPatternEntry(
        id: 'entry-2',
        patternId: 'pattern-1',
        dayOffset: 1,
        shiftTemplateId: null,
        isOffDay: true,
      ),
    ];
    final templates = [
      ShiftTemplate(
        id: 'template-1',
        jobId: 'job-1',
        name: 'Day',
        startMinutesLocal: 8 * 60,
        endMinutesLocal: 16 * 60,
        unpaidBreakMinutes: 30,
        category: ShiftCategory.day,
        defaultNote: 'Template note',
      ),
    ];
    final manualOverride = ShiftInstance(
      id: 'override-1',
      jobId: 'job-1',
      date: DateTime(2026, 1, 1),
      templateSnapshot: const ShiftTemplateSnapshot(
        templateId: null,
        name: 'Manual replacement',
        category: ShiftCategory.custom,
        startMinutesLocal: 9 * 60,
        endMinutesLocal: 12 * 60,
        unpaidBreakMinutes: 0,
        defaultNote: 'Manual note',
      ),
      startDateTime: DateTime(2026, 1, 1, 9),
      endDateTime: DateTime(2026, 1, 1, 12),
      unpaidBreakMinutes: 0,
      source: ShiftSource.manual,
      note: 'Manual note',
      isHoliday: false,
      overrideType: ShiftOverrideType.replaceWithManualShift,
    );

    test('returns an empty list when no active pattern exists', () async {
      final useCase = GenerateShiftScheduleUseCaseImpl(
        shiftPatternRepository: _FakeShiftPatternRepository(activePattern: const Success(null)),
        shiftPatternEntryRepository: _FakeShiftPatternEntryRepository(entriesResult: const Success([])),
        shiftTemplateRepository: _FakeShiftTemplateRepository(templatesResult: const Success([])),
        shiftInstanceRepository: _FakeShiftInstanceRepository(instancesResult: const Success([])),
        patternExpansionService: const PatternExpansionService(),
      );

      final result = await useCase(
        jobId: 'job-1',
        range: AppDateRange(start: DateTime(2026, 1, 1), end: DateTime(2026, 1, 7)),
      );

      expect(result.isSuccess, isTrue);
      expect(result.when(success: (value) => value, failure: (_) => throw StateError('unexpected')), isEmpty);
    });

    test('expands schedule from pattern, templates, and manual overrides', () async {
      final useCase = GenerateShiftScheduleUseCaseImpl(
        shiftPatternRepository: _FakeShiftPatternRepository(activePattern: Success(pattern)),
        shiftPatternEntryRepository: _FakeShiftPatternEntryRepository(entriesResult: Success(entries)),
        shiftTemplateRepository: _FakeShiftTemplateRepository(templatesResult: Success(templates)),
        shiftInstanceRepository: _FakeShiftInstanceRepository(instancesResult: Success([manualOverride])),
        patternExpansionService: const PatternExpansionService(),
      );

      final result = await useCase(
        jobId: 'job-1',
        range: AppDateRange(start: DateTime(2026, 1, 1), end: DateTime(2026, 1, 3)),
      );

      final instances = result.when(
        success: (value) => value,
        failure: (error) => throw error,
      );

      expect(instances, hasLength(2));
      expect(instances.first.id, 'override-1');
      expect(instances.first.source, ShiftSource.manual);
      expect(instances.last.id, 'generated:pattern-1:2026-01-03');
      expect(instances.last.templateSnapshot?.templateId, 'template-1');
    });

    test('preserves edited generated shift overrides in the expanded schedule', () async {
      final editedGeneratedShift = ShiftInstance(
        id: 'override-2',
        jobId: 'job-1',
        date: DateTime(2026, 1, 3),
        templateSnapshot: const ShiftTemplateSnapshot(
          templateId: 'template-1',
          name: 'Day',
          category: ShiftCategory.day,
          startMinutesLocal: 10 * 60,
          endMinutesLocal: 18 * 60,
          unpaidBreakMinutes: 45,
          defaultNote: 'Late start',
        ),
        startDateTime: DateTime(2026, 1, 3, 10),
        endDateTime: DateTime(2026, 1, 3, 18),
        unpaidBreakMinutes: 45,
        source: ShiftSource.manual,
        note: 'Late start',
        isHoliday: false,
        overrideType: ShiftOverrideType.editGeneratedShift,
      );

      final useCase = GenerateShiftScheduleUseCaseImpl(
        shiftPatternRepository: _FakeShiftPatternRepository(activePattern: Success(pattern)),
        shiftPatternEntryRepository: _FakeShiftPatternEntryRepository(entriesResult: Success(entries)),
        shiftTemplateRepository: _FakeShiftTemplateRepository(templatesResult: Success(templates)),
        shiftInstanceRepository: _FakeShiftInstanceRepository(
          instancesResult: Success([manualOverride, editedGeneratedShift]),
        ),
        patternExpansionService: const PatternExpansionService(),
      );

      final result = await useCase(
        jobId: 'job-1',
        range: AppDateRange(start: DateTime(2026, 1, 1), end: DateTime(2026, 1, 3)),
      );

      final instances = result.when(
        success: (value) => value,
        failure: (error) => throw error,
      );

      expect(instances, hasLength(2));
      expect(instances.last.id, 'override-2');
      expect(instances.last.overrideType, ShiftOverrideType.editGeneratedShift);
      expect(instances.last.startDateTime, DateTime(2026, 1, 3, 10));
      expect(instances.last.endDateTime, DateTime(2026, 1, 3, 18));
    });

    test('preserves holiday and note metadata on manual overrides', () async {
      final holidayOverride = ShiftInstance(
        id: 'override-holiday',
        jobId: 'job-1',
        date: DateTime(2026, 1, 3),
        templateSnapshot: const ShiftTemplateSnapshot(
          templateId: 'template-1',
          name: 'Day',
          category: ShiftCategory.day,
          startMinutesLocal: 8 * 60,
          endMinutesLocal: 16 * 60,
          unpaidBreakMinutes: 30,
          defaultNote: 'Holiday coverage',
        ),
        startDateTime: DateTime(2026, 1, 3, 8),
        endDateTime: DateTime(2026, 1, 3, 16),
        unpaidBreakMinutes: 30,
        source: ShiftSource.manual,
        note: 'Holiday coverage',
        isHoliday: true,
        overrideType: ShiftOverrideType.editGeneratedShift,
      );

      final useCase = GenerateShiftScheduleUseCaseImpl(
        shiftPatternRepository: _FakeShiftPatternRepository(activePattern: Success(pattern)),
        shiftPatternEntryRepository: _FakeShiftPatternEntryRepository(entriesResult: Success(entries)),
        shiftTemplateRepository: _FakeShiftTemplateRepository(templatesResult: Success(templates)),
        shiftInstanceRepository: _FakeShiftInstanceRepository(instancesResult: Success([holidayOverride])),
        patternExpansionService: const PatternExpansionService(),
      );

      final result = await useCase(
        jobId: 'job-1',
        range: AppDateRange(start: DateTime(2026, 1, 3), end: DateTime(2026, 1, 3)),
      );

      final instances = result.when(
        success: (value) => value,
        failure: (error) => throw error,
      );

      expect(instances, hasLength(1));
      expect(instances.single.id, 'override-holiday');
      expect(instances.single.note, 'Holiday coverage');
      expect(instances.single.isHoliday, isTrue);
      expect(instances.single.source, ShiftSource.manual);
    });

    test('propagates repository failures before expansion', () async {
      final useCase = GenerateShiftScheduleUseCaseImpl(
        shiftPatternRepository: _FakeShiftPatternRepository(activePattern: Success(pattern)),
        shiftPatternEntryRepository: _FakeShiftPatternEntryRepository(
          entriesResult: const Failure(AppError(code: 'entries_failed', message: 'Could not load entries')),
        ),
        shiftTemplateRepository: _FakeShiftTemplateRepository(templatesResult: Success(templates)),
        shiftInstanceRepository: _FakeShiftInstanceRepository(instancesResult: const Success([])),
        patternExpansionService: const PatternExpansionService(),
      );

      final result = await useCase(
        jobId: 'job-1',
        range: AppDateRange(start: DateTime(2026, 1, 1), end: DateTime(2026, 1, 3)),
      );

      expect(result.isFailure, isTrue);
      expect(
        result.when(success: (_) => 'success', failure: (error) => error.code),
        'entries_failed',
      );
    });
  });
}

class _FakeShiftPatternRepository implements ShiftPatternRepository {
  _FakeShiftPatternRepository({required this.activePattern});

  final Result<ShiftPattern?> activePattern;

  @override
  Future<Result<ShiftPattern?>> getActivePatternForJob(String jobId) async => activePattern;

  @override
  Future<Result<List<ShiftPattern>>> listPatternsForJob(String jobId) {
    throw UnimplementedError();
  }

  @override
  Future<Result<ShiftPattern>> savePattern(ShiftPattern pattern) {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> setPatternActive({required String patternId, required bool isActive}) {
    throw UnimplementedError();
  }
}

class _FakeShiftPatternEntryRepository implements ShiftPatternEntryRepository {
  _FakeShiftPatternEntryRepository({required this.entriesResult});

  final Result<List<ShiftPatternEntry>> entriesResult;

  @override
  Future<Result<List<ShiftPatternEntry>>> listEntriesForPattern(String patternId) async => entriesResult;

  @override
  Future<Result<List<ShiftPatternEntry>>> replaceEntries({
    required String patternId,
    required List<ShiftPatternEntry> entries,
  }) {
    throw UnimplementedError();
  }
}

class _FakeShiftTemplateRepository implements ShiftTemplateRepository {
  _FakeShiftTemplateRepository({required this.templatesResult});

  final Result<List<ShiftTemplate>> templatesResult;

  @override
  Future<Result<ShiftTemplate?>> getTemplateById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<ShiftTemplate>>> listTemplatesForJob(String jobId) async => templatesResult;

  @override
  Future<Result<ShiftTemplate>> saveTemplate(ShiftTemplate template) {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> deleteTemplate(String id) {
    throw UnimplementedError();
  }
}

class _FakeShiftInstanceRepository implements ShiftInstanceRepository {
  _FakeShiftInstanceRepository({required this.instancesResult});

  final Result<List<ShiftInstance>> instancesResult;

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
  }) async => instancesResult;

  @override
  Future<Result<ShiftInstance>> saveInstance(ShiftInstance instance) {
    throw UnimplementedError();
  }
}
