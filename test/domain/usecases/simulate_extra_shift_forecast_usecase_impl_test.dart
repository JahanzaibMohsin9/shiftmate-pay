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
import 'package:shiftmate_pay/domain/usecases/simulate_extra_shift_forecast_usecase_impl.dart';
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
    'simulates one extra template shift without saving and reflects overtime, differential, and allowance deltas',
    () async {
      final range = AppDateRange(
        start: DateTime.utc(2026, 4, 1),
        end: DateTime.utc(2026, 4, 7),
      );
      final baselineShifts = [
        _dayShift(DateTime.utc(2026, 4, 1)),
        _dayShift(DateTime.utc(2026, 4, 2)),
        _dayShift(DateTime.utc(2026, 4, 3)),
        _dayShift(DateTime.utc(2026, 4, 4)),
      ];
      final nightTemplate = ShiftTemplate(
        id: 'template-night',
        jobId: 'job-1',
        name: 'Night 12h',
        startMinutesLocal: 20 * 60,
        endMinutesLocal: 8 * 60,
        unpaidBreakMinutes: 0,
        category: ShiftCategory.night,
        defaultNote: 'Simulated',
      );
      final advancedPayRuleSet = AdvancedPayRuleSet(
        id: 'advanced-1',
        jobId: 'job-1',
        enabled: true,
        overtimeRules: const [],
        differentialRules: const [
          DifferentialPayRule(
            id: 'night-rule',
            type: DifferentialRuleType.night,
            combinationMode: DifferentialCombinationMode.additivePremium,
            enabled: true,
            multiplierBps: 12500,
            startMinutesLocal: 22 * 60,
            endMinutesLocal: 6 * 60,
          ),
        ],
        allowanceRules: const [
          AllowancePayRule(
            id: 'night-allowance',
            type: AllowanceRuleType.perShift,
            amountMinor: 1200,
            enabled: true,
            shiftTemplateId: 'template-night',
          ),
        ],
        breakRules: const [],
        version: 1,
        createdAt: DateTime.utc(2026, 4, 1),
        updatedAt: DateTime.utc(2026, 4, 1),
      );

      final useCase = SimulateExtraShiftForecastUseCaseImpl(
        jobRepository: _FakeJobRepository(),
        payRuleSetRepository: _FakePayRuleSetRepository(payRuleSet),
        advancedPayRuleSetRepository: _FakeAdvancedPayRuleSetRepository(
          advancedPayRuleSet,
        ),
        holidayRuleSetRepository: _FakeHolidayRuleSetRepository(holidayRuleSet),
        shiftTemplateRepository: _FakeShiftTemplateRepository([nightTemplate]),
        shiftPatternRepository: _FakeShiftPatternRepository(pattern: null),
        shiftPatternEntryRepository: _FakeShiftPatternEntryRepository(const []),
        shiftInstanceRepository: _FakeShiftInstanceRepository({
          _rangeKey(range): baselineShifts,
        }),
        generateShiftScheduleUseCase: _FakeGenerateShiftScheduleUseCase({
          _rangeKey(range): baselineShifts,
        }),
        grossPayCalculator: const GrossPayCalculator(),
        forecastConfidenceEvaluator: const ForecastConfidenceEvaluator(),
        forecastTargetTracker: const ForecastTargetTracker(),
      );

      final result = await useCase(
        jobId: 'job-1',
        range: range,
        shiftTemplateId: 'template-night',
        simulatedDate: DateTime.utc(2026, 4, 6),
      );

      expect(result.isSuccess, isTrue);
      final simulation = result.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
      expect(simulation.additionalGrossPayMinor, 33200);
      expect(simulation.additionalBasePayMinor, 16000);
      expect(simulation.additionalOvertimePayMinor, 12000);
      expect(simulation.additionalDifferentialPayMinor, 4000);
      expect(simulation.additionalAllowancePayMinor, 1200);
      expect(simulation.additionalWorkedMinutes, 720);
      expect(simulation.baselineCoverage.daysCovered, 4);
      expect(simulation.updatedCoverage.daysCovered, 5);
      expect(
        simulation.triggeredChanges,
        containsAll([
          ForecastShiftSimulationTrigger.overtime,
          ForecastShiftSimulationTrigger.differential,
          ForecastShiftSimulationTrigger.allowance,
        ]),
      );
    },
  );

  test('rejects simulations outside the active forecast window', () async {
    final range = AppDateRange(
      start: DateTime.utc(2026, 4, 1),
      end: DateTime.utc(2026, 4, 7),
    );
    final useCase = SimulateExtraShiftForecastUseCaseImpl(
      jobRepository: _FakeJobRepository(),
      payRuleSetRepository: _FakePayRuleSetRepository(payRuleSet),
      advancedPayRuleSetRepository: _FakeAdvancedPayRuleSetRepository(null),
      holidayRuleSetRepository: _FakeHolidayRuleSetRepository(holidayRuleSet),
      shiftTemplateRepository: _FakeShiftTemplateRepository(const []),
      shiftPatternRepository: _FakeShiftPatternRepository(pattern: null),
      shiftPatternEntryRepository: _FakeShiftPatternEntryRepository(const []),
      shiftInstanceRepository: _FakeShiftInstanceRepository(const {}),
      generateShiftScheduleUseCase: _FakeGenerateShiftScheduleUseCase(const {}),
      grossPayCalculator: const GrossPayCalculator(),
      forecastConfidenceEvaluator: const ForecastConfidenceEvaluator(),
      forecastTargetTracker: const ForecastTargetTracker(),
    );

    final result = await useCase(
      jobId: 'job-1',
      range: range,
      shiftTemplateId: 'template-night',
      simulatedDate: DateTime.utc(2026, 5, 1),
    );

    expect(result.isFailure, isTrue);
  });
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

class _FakeShiftTemplateRepository implements ShiftTemplateRepository {
  _FakeShiftTemplateRepository(this.templates);

  final List<ShiftTemplate> templates;

  @override
  Future<Result<void>> deleteTemplate(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<ShiftTemplate?>> getTemplateById(String id) async {
    for (final template in templates) {
      if (template.id == id) {
        return Success(template);
      }
    }
    return const Success(null);
  }

  @override
  Future<Result<List<ShiftTemplate>>> listTemplatesForJob(String jobId) async =>
      Success(templates.where((template) => template.jobId == jobId).toList());

  @override
  Future<Result<ShiftTemplate>> saveTemplate(ShiftTemplate template) {
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

ShiftInstance _dayShift(DateTime date) {
  return ShiftInstance(
    id: 'shift-${date.toIso8601String()}',
    jobId: 'job-1',
    date: date,
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
