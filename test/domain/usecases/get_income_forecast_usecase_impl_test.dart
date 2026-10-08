import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/common/result.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/core/money/currency_amount.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/domain/entities/entities.dart';
import 'package:shiftmate_pay/domain/repositories/repositories.dart';
import 'package:shiftmate_pay/domain/services/forecast_confidence_evaluator.dart';
import 'package:shiftmate_pay/domain/services/forecast_target_tracker.dart';
import 'package:shiftmate_pay/domain/services/gross_pay_calculator.dart';
import 'package:shiftmate_pay/domain/usecases/get_income_forecast_usecase_impl.dart';
import 'package:shiftmate_pay/domain/usecases/usecases.dart';

void main() {
  final payRuleSet = PayRuleSet(
    id: 'pay-rules-1',
    jobId: 'job-1',
    overtimeThresholdDailyMinutes: 8 * 60,
    overtimeThresholdWeeklyMinutes: 40 * 60,
    overtimeMultiplierBps: 15000,
    doubleTimeThresholdMinutes: null,
    doubleTimeMultiplierBps: null,
    roundRule: RoundRule.nearestMinute,
  );
  final holidayRuleSet = HolidayRuleSet(
    id: 'holiday-rules-1',
    jobId: 'job-1',
    holidayMultiplierBps: 20000,
    holidaySource: HolidaySource.manual,
  );

  test(
    'returns low-confidence empty forecast when no future schedule exists',
    () async {
      final range = AppDateRange(
        start: DateTime.utc(2026, 4, 1),
        end: DateTime.utc(2026, 4, 30),
      );
      final useCase = _buildUseCase(
        scheduleUseCase: _FakeGenerateShiftScheduleUseCase({}),
        shiftPatternRepository: _FakeShiftPatternRepository(pattern: null),
        shiftPatternEntryRepository: _FakeShiftPatternEntryRepository(const []),
        shiftInstanceRepository: _FakeShiftInstanceRepository({}),
        payRuleSet: payRuleSet,
        holidayRuleSet: holidayRuleSet,
        advancedPayRuleSet: null,
      );

      final result = await useCase(
        jobId: 'job-1',
        range: range,
        windowPreset: ForecastWindowPreset.days30,
      );

      expect(result.isSuccess, isTrue);
      final summary = result.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
      expect(summary.projectedGrossPayMinor, 0);
      expect(summary.coverage.daysCovered, 0);
      expect(summary.coverage.uncoveredDayCount, 30);
      expect(summary.confidence, ForecastConfidenceLevel.low);
      expect(summary.confidenceWarnings, isNotEmpty);
    },
  );

  test(
    'builds partial forecast metadata when only some future days are covered',
    () async {
      final range = AppDateRange(
        start: DateTime.utc(2026, 4, 1),
        end: DateTime.utc(2026, 4, 30),
      );
      final partialShifts = _buildDailyShifts(
        start: range.start,
        everyDays: 1,
        count: 9,
      );
      final overrides = {_rangeKey(range): partialShifts};

      final useCase = _buildUseCase(
        scheduleUseCase: _FakeGenerateShiftScheduleUseCase({
          _rangeKey(range): partialShifts,
        }),
        shiftPatternRepository: _FakeShiftPatternRepository(pattern: null),
        shiftPatternEntryRepository: _FakeShiftPatternEntryRepository(const []),
        shiftInstanceRepository: _FakeShiftInstanceRepository(overrides),
        payRuleSet: payRuleSet,
        holidayRuleSet: holidayRuleSet,
        advancedPayRuleSet: null,
      );

      final result = await useCase(
        jobId: 'job-1',
        range: range,
        windowPreset: ForecastWindowPreset.days30,
      );

      final summary = result.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
      expect(summary.coverage.daysCovered, 9);
      expect(summary.coverage.coveredShiftCount, 9);
      expect(summary.coverage.uncoveredDayCount, 21);
      expect(summary.confidence, ForecastConfidenceLevel.low);
      expect(
        summary.confidenceWarnings.single,
        contains('Only part of this window has scheduled shifts'),
      );
      expect(summary.projectedGrossPayMinor, 176000);
    },
  );

  test(
    'builds coverage-aware forecast with goal progress and advanced allowance totals',
    () async {
      final range = AppDateRange(
        start: DateTime.utc(2026, 4, 1),
        end: DateTime.utc(2026, 4, 30),
      );
      final pattern = ShiftPattern(
        id: 'pattern-1',
        jobId: 'job-1',
        name: '2-day cycle',
        cycleLengthDays: 2,
        startDate: range.start,
        timezone: 'UTC',
        isActive: true,
      );
      final entries = const [
        ShiftPatternEntry(
          id: 'entry-1',
          patternId: 'pattern-1',
          dayOffset: 0,
          shiftTemplateId: 'template-day',
          isOffDay: false,
        ),
        ShiftPatternEntry(
          id: 'entry-2',
          patternId: 'pattern-1',
          dayOffset: 1,
          shiftTemplateId: null,
          isOffDay: true,
        ),
      ];
      final generatedShifts = _buildEveryOtherDayShifts(range);
      final advancedPayRuleSet = AdvancedPayRuleSet(
        id: 'advanced-1',
        jobId: 'job-1',
        enabled: true,
        overtimeRules: const [],
        differentialRules: const [],
        allowanceRules: const [
          AllowancePayRule(
            id: 'period-allowance',
            type: AllowanceRuleType.perPeriod,
            amountMinor: 1000,
            enabled: true,
          ),
        ],
        breakRules: const [],
        version: 1,
        createdAt: DateTime.utc(2026, 4, 1),
        updatedAt: DateTime.utc(2026, 4, 1),
      );

      final useCase = _buildUseCase(
        scheduleUseCase: _FakeGenerateShiftScheduleUseCase({
          _rangeKey(range): generatedShifts,
        }),
        shiftPatternRepository: _FakeShiftPatternRepository(pattern: pattern),
        shiftPatternEntryRepository: _FakeShiftPatternEntryRepository(entries),
        shiftInstanceRepository: _FakeShiftInstanceRepository({
          _rangeKey(range): const [],
        }),
        payRuleSet: payRuleSet,
        holidayRuleSet: holidayRuleSet,
        advancedPayRuleSet: advancedPayRuleSet,
      );

      final result = await useCase(
        jobId: 'job-1',
        range: range,
        windowPreset: ForecastWindowPreset.days30,
        monthlyGoalMinor: 330000,
        goalMonthAnchor: range.start,
      );

      final summary = result.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
      expect(summary.coverage.daysCovered, 30);
      expect(summary.coverage.coverageRatio, 1);
      expect(summary.confidence, ForecastConfidenceLevel.high);
      expect(summary.projectedShiftCount, 15);
      expect(summary.projectedAllowancePayMinor, 1000);
      expect(summary.projectedGrossPayMinor, 321000);
      expect(summary.goalProgress, isNotNull);
      expect(summary.goalProgress!.status, ForecastGoalStatus.atRisk);
      expect(summary.goalProgress!.deltaToGoalMinor, -9000);
      expect(summary.nudges.map((item) => item.id), contains('goal_at_risk'));
    },
  );

  test(
    'tracks monthly overtime target and marks it on track when projected overtime reaches target',
    () async {
      final range = AppDateRange(
        start: DateTime.utc(2026, 4, 1),
        end: DateTime.utc(2026, 4, 30),
      );
      final twelveLongShifts = _buildLongShifts(start: range.start, count: 12);
      final useCase = _buildUseCase(
        scheduleUseCase: _FakeGenerateShiftScheduleUseCase({
          _rangeKey(range): twelveLongShifts,
        }),
        shiftPatternRepository: _FakeShiftPatternRepository(pattern: null),
        shiftPatternEntryRepository: _FakeShiftPatternEntryRepository(const []),
        shiftInstanceRepository: _FakeShiftInstanceRepository({
          _rangeKey(range): twelveLongShifts,
        }),
        payRuleSet: payRuleSet,
        holidayRuleSet: holidayRuleSet,
        advancedPayRuleSet: null,
      );

      final result = await useCase(
        jobId: 'job-1',
        range: range,
        windowPreset: ForecastWindowPreset.days30,
        monthlyOvertimeTargetMinutes: 24 * 60,
        goalMonthAnchor: range.start,
      );

      final summary = result.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
      expect(summary.overtimeProgress, isNotNull);
      expect(summary.overtimeProgress!.projectedOvertimeMinutes, 6240);
      expect(
        summary.overtimeProgress!.status,
        ForecastOvertimeTargetStatus.onTrack,
      );
      expect(
        summary.nudges.map((item) => item.id),
        contains('overtime_on_track'),
      );
    },
  );

  test(
    'keeps targets in not-enough-data state when future coverage is too sparse',
    () async {
      final range = AppDateRange(
        start: DateTime.utc(2026, 4, 1),
        end: DateTime.utc(2026, 4, 30),
      );
      final sparseShifts = _buildLongShifts(start: range.start, count: 4);
      final useCase = _buildUseCase(
        scheduleUseCase: _FakeGenerateShiftScheduleUseCase({
          _rangeKey(range): sparseShifts,
        }),
        shiftPatternRepository: _FakeShiftPatternRepository(pattern: null),
        shiftPatternEntryRepository: _FakeShiftPatternEntryRepository(const []),
        shiftInstanceRepository: _FakeShiftInstanceRepository({
          _rangeKey(range): sparseShifts,
        }),
        payRuleSet: payRuleSet,
        holidayRuleSet: holidayRuleSet,
        advancedPayRuleSet: null,
      );

      final result = await useCase(
        jobId: 'job-1',
        range: range,
        windowPreset: ForecastWindowPreset.days30,
        monthlyGoalMinor: 200000,
        monthlyOvertimeTargetMinutes: 20 * 60,
        goalMonthAnchor: range.start,
      );

      final summary = result.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
      expect(summary.coverage.coverageRatio, lessThan(0.4));
      expect(summary.goalProgress!.status, ForecastGoalStatus.notEnoughData);
      expect(
        summary.overtimeProgress!.status,
        ForecastOvertimeTargetStatus.notEnoughData,
      );
      expect(
        summary.nudges.map((item) => item.id),
        containsAll(['goal_not_enough_data', 'overtime_not_enough_data']),
      );
    },
  );
}

GetIncomeForecastUseCaseImpl _buildUseCase({
  required GenerateShiftScheduleUseCase scheduleUseCase,
  required ShiftPatternRepository shiftPatternRepository,
  required ShiftPatternEntryRepository shiftPatternEntryRepository,
  required ShiftInstanceRepository shiftInstanceRepository,
  required PayRuleSet payRuleSet,
  required HolidayRuleSet holidayRuleSet,
  required AdvancedPayRuleSet? advancedPayRuleSet,
}) {
  return GetIncomeForecastUseCaseImpl(
    jobRepository: _FakeJobRepository(),
    payRuleSetRepository: _FakePayRuleSetRepository(payRuleSet),
    advancedPayRuleSetRepository: _FakeAdvancedPayRuleSetRepository(
      advancedPayRuleSet,
    ),
    holidayRuleSetRepository: _FakeHolidayRuleSetRepository(holidayRuleSet),
    shiftPatternRepository: shiftPatternRepository,
    shiftPatternEntryRepository: shiftPatternEntryRepository,
    shiftInstanceRepository: shiftInstanceRepository,
    generateShiftScheduleUseCase: scheduleUseCase,
    grossPayCalculator: const GrossPayCalculator(),
    forecastConfidenceEvaluator: const ForecastConfidenceEvaluator(),
    forecastTargetTracker: const ForecastTargetTracker(),
  );
}

class _FakeJobRepository implements JobRepository {
  @override
  Future<Result<void>> archiveJob(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<Job?>> getJobById(String id) async {
    return Success(
      Job(
        id: 'job-1',
        name: 'Forecast job',
        colorHex: '#4F46E5',
        currencyCode: 'USD',
        hourlyRate: const CurrencyAmount(minorUnits: 2000, currencyCode: 'USD'),
        payRuleSetId: 'pay-rules-1',
        holidayRuleSetId: 'holiday-rules-1',
        defaultSleepLeadMinutes: 480,
        isArchived: false,
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      ),
    );
  }

  @override
  Future<Result<List<Job>>> listJobs() {
    throw UnimplementedError();
  }

  @override
  Future<Result<Job>> saveJob(Job job) {
    throw UnimplementedError();
  }
}

class _FakePayRuleSetRepository implements PayRuleSetRepository {
  _FakePayRuleSetRepository(this.ruleSet);

  final PayRuleSet ruleSet;

  @override
  Future<Result<PayRuleSet?>> getForJob(String jobId) async => Success(ruleSet);

  @override
  Future<Result<PayRuleSet>> save(PayRuleSet ruleSet) {
    throw UnimplementedError();
  }
}

class _FakeAdvancedPayRuleSetRepository
    implements AdvancedPayRuleSetRepository {
  _FakeAdvancedPayRuleSetRepository(this.ruleSet);

  final AdvancedPayRuleSet? ruleSet;

  @override
  Future<Result<AdvancedPayRuleSet?>> getForJob(String jobId) async =>
      Success(ruleSet);

  @override
  Future<Result<AdvancedPayRuleSet>> save(AdvancedPayRuleSet ruleSet) {
    throw UnimplementedError();
  }
}

class _FakeHolidayRuleSetRepository implements HolidayRuleSetRepository {
  _FakeHolidayRuleSetRepository(this.ruleSet);

  final HolidayRuleSet ruleSet;

  @override
  Future<Result<HolidayRuleSet?>> getForJob(String jobId) async =>
      Success(ruleSet);

  @override
  Future<Result<HolidayRuleSet>> save(HolidayRuleSet ruleSet) {
    throw UnimplementedError();
  }
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

class _FakeShiftPatternRepository implements ShiftPatternRepository {
  _FakeShiftPatternRepository({required this.pattern});

  final ShiftPattern? pattern;

  @override
  Future<Result<ShiftPattern?>> getActivePatternForJob(String jobId) async =>
      Success(pattern);

  @override
  Future<Result<List<ShiftPattern>>> listPatternsForJob(String jobId) {
    throw UnimplementedError();
  }

  @override
  Future<Result<ShiftPattern>> savePattern(ShiftPattern pattern) {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> setPatternActive({
    required String patternId,
    required bool isActive,
  }) {
    throw UnimplementedError();
  }
}

class _FakeShiftPatternEntryRepository implements ShiftPatternEntryRepository {
  _FakeShiftPatternEntryRepository(this.entries);

  final List<ShiftPatternEntry> entries;

  @override
  Future<Result<List<ShiftPatternEntry>>> listEntriesForPattern(
    String patternId,
  ) async => Success(entries);

  @override
  Future<Result<List<ShiftPatternEntry>>> replaceEntries({
    required String patternId,
    required List<ShiftPatternEntry> entries,
  }) {
    throw UnimplementedError();
  }
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

List<ShiftInstance> _buildDailyShifts({
  required DateTime start,
  required int everyDays,
  required int count,
}) {
  return List.generate(count, (index) {
    final date = start.add(Duration(days: index * everyDays));
    return _shiftOn(date);
  });
}

List<ShiftInstance> _buildEveryOtherDayShifts(AppDateRange range) {
  final shifts = <ShiftInstance>[];
  for (
    var date = range.start;
    !date.isAfter(range.end);
    date = date.add(const Duration(days: 2))
  ) {
    shifts.add(_shiftOn(date));
  }
  return shifts;
}

List<ShiftInstance> _buildLongShifts({
  required DateTime start,
  required int count,
}) {
  return List.generate(count, (index) {
    final date = start.add(Duration(days: index));
    return ShiftInstance(
      id: 'long-shift-${date.toIso8601String()}',
      jobId: 'job-1',
      date: DateTime.utc(date.year, date.month, date.day),
      templateSnapshot: const ShiftTemplateSnapshot(
        templateId: 'template-long',
        name: 'Long',
        category: ShiftCategory.day,
        startMinutesLocal: 8 * 60,
        endMinutesLocal: 20 * 60,
        unpaidBreakMinutes: 0,
        defaultNote: null,
      ),
      startDateTime: DateTime.utc(date.year, date.month, date.day, 8),
      endDateTime: DateTime.utc(date.year, date.month, date.day, 20),
      unpaidBreakMinutes: 0,
      source: ShiftSource.pattern,
      note: null,
      isHoliday: false,
      overrideType: null,
    );
  });
}

ShiftInstance _shiftOn(DateTime date) {
  return ShiftInstance(
    id: 'shift-${date.toIso8601String()}',
    jobId: 'job-1',
    date: DateTime.utc(date.year, date.month, date.day),
    templateSnapshot: const ShiftTemplateSnapshot(
      templateId: 'template-day',
      name: 'Day',
      category: ShiftCategory.day,
      startMinutesLocal: 8 * 60,
      endMinutesLocal: 16 * 60,
      unpaidBreakMinutes: 0,
      defaultNote: null,
    ),
    startDateTime: DateTime.utc(date.year, date.month, date.day, 8),
    endDateTime: DateTime.utc(date.year, date.month, date.day, 16),
    unpaidBreakMinutes: 0,
    source: ShiftSource.pattern,
    note: null,
    isHoliday: false,
    overrideType: null,
  );
}

String _rangeKey(AppDateRange range) =>
    '${range.start.toIso8601String()}::${range.end.toIso8601String()}';
