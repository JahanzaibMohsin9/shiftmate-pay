import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../core/common/shared_types.dart';
import '../../core/time/app_date_range.dart';
import '../../core/time/date_range_extensions.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';
import '../services/forecast_confidence_evaluator.dart';
import '../services/forecast_target_tracker.dart';
import '../services/gross_pay_calculator.dart';
import '../services/pay_calculation_models.dart';
import 'usecases.dart';

class SimulateExtraShiftForecastUseCaseImpl
    implements SimulateExtraShiftForecastUseCase {
  SimulateExtraShiftForecastUseCaseImpl({
    required JobRepository jobRepository,
    required PayRuleSetRepository payRuleSetRepository,
    required AdvancedPayRuleSetRepository advancedPayRuleSetRepository,
    required HolidayRuleSetRepository holidayRuleSetRepository,
    required ShiftTemplateRepository shiftTemplateRepository,
    required ShiftPatternRepository shiftPatternRepository,
    required ShiftPatternEntryRepository shiftPatternEntryRepository,
    required ShiftInstanceRepository shiftInstanceRepository,
    required GenerateShiftScheduleUseCase generateShiftScheduleUseCase,
    required GrossPayCalculator grossPayCalculator,
    required ForecastConfidenceEvaluator forecastConfidenceEvaluator,
    required ForecastTargetTracker forecastTargetTracker,
  }) : _jobRepository = jobRepository,
       _payRuleSetRepository = payRuleSetRepository,
       _advancedPayRuleSetRepository = advancedPayRuleSetRepository,
       _holidayRuleSetRepository = holidayRuleSetRepository,
       _shiftTemplateRepository = shiftTemplateRepository,
       _shiftPatternRepository = shiftPatternRepository,
       _shiftPatternEntryRepository = shiftPatternEntryRepository,
       _shiftInstanceRepository = shiftInstanceRepository,
       _generateShiftScheduleUseCase = generateShiftScheduleUseCase,
       _grossPayCalculator = grossPayCalculator,
       _forecastConfidenceEvaluator = forecastConfidenceEvaluator,
       _forecastTargetTracker = forecastTargetTracker;

  final JobRepository _jobRepository;
  final PayRuleSetRepository _payRuleSetRepository;
  final AdvancedPayRuleSetRepository _advancedPayRuleSetRepository;
  final HolidayRuleSetRepository _holidayRuleSetRepository;
  final ShiftTemplateRepository _shiftTemplateRepository;
  final ShiftPatternRepository _shiftPatternRepository;
  final ShiftPatternEntryRepository _shiftPatternEntryRepository;
  final ShiftInstanceRepository _shiftInstanceRepository;
  final GenerateShiftScheduleUseCase _generateShiftScheduleUseCase;
  final GrossPayCalculator _grossPayCalculator;
  final ForecastConfidenceEvaluator _forecastConfidenceEvaluator;
  final ForecastTargetTracker _forecastTargetTracker;

  @override
  Future<Result<ForecastShiftSimulationResult>> call({
    required EntityId jobId,
    required AppDateRange range,
    required EntityId shiftTemplateId,
    required DateTime simulatedDate,
    int? monthlyGoalMinor,
    int? monthlyOvertimeTargetMinutes,
    DateTime? goalMonthAnchor,
  }) async {
    if (!range.contains(simulatedDate.startOfDay)) {
      return const Failure(
        AppError(
          code: 'simulation_out_of_range',
          message:
              'The simulated shift must stay inside the active forecast window.',
        ),
      );
    }

    final contextResult = await _loadContext(jobId);
    if (contextResult.isFailure) {
      return contextResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }
    final context = contextResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );

    final templateResult = await _shiftTemplateRepository.getTemplateById(
      shiftTemplateId,
    );
    if (templateResult.isFailure) {
      return templateResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }
    final template = templateResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );
    if (template == null || template.jobId != jobId) {
      return Failure(
        AppError(
          code: 'template_not_found',
          message:
              'Shift template $shiftTemplateId was not found for job $jobId.',
        ),
      );
    }

    final baselineProjectionResult = await _buildProjection(
      context: context,
      range: range,
      additionalShift: null,
    );
    if (baselineProjectionResult.isFailure) {
      return baselineProjectionResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }
    final baselineProjection = baselineProjectionResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );

    final simulatedShift = _buildSimulatedShift(
      jobId: jobId,
      template: template,
      simulatedDate: simulatedDate.startOfDay,
    );

    final updatedProjectionResult = await _buildProjection(
      context: context,
      range: range,
      additionalShift: simulatedShift,
    );
    if (updatedProjectionResult.isFailure) {
      return updatedProjectionResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }
    final updatedProjection = updatedProjectionResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );

    final monthAnchor = goalMonthAnchor ?? range.start;
    final monthRange = _monthRangeFor(monthAnchor);
    final baselineTracking = await _trackingForProjection(
      context: context,
      range: monthRange,
      monthlyGoalMinor: monthlyGoalMinor,
      monthlyOvertimeTargetMinutes: monthlyOvertimeTargetMinutes,
      additionalShift: null,
    );
    if (baselineTracking.isFailure) {
      return baselineTracking.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }
    final updatedTracking = await _trackingForProjection(
      context: context,
      range: monthRange,
      monthlyGoalMinor: monthlyGoalMinor,
      monthlyOvertimeTargetMinutes: monthlyOvertimeTargetMinutes,
      additionalShift:
          range.contains(simulatedDate.startOfDay) &&
              monthRange.contains(simulatedDate.startOfDay)
          ? simulatedShift
          : null,
    );
    if (updatedTracking.isFailure) {
      return updatedTracking.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }

    final baselineTargetTracking = baselineTracking.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );
    final updatedTargetTracking = updatedTracking.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );

    final baselineBreakdown = baselineProjection.breakdown;
    final updatedBreakdown = updatedProjection.breakdown;

    return Success(
      ForecastShiftSimulationResult(
        jobId: jobId,
        range: range,
        simulatedDate: simulatedDate.startOfDay,
        templateId: template.id,
        templateName: template.name,
        currencyCode: context.job.hourlyRate.currencyCode,
        baselineGrossPayMinor: baselineBreakdown.grossPayMinor,
        updatedGrossPayMinor: updatedBreakdown.grossPayMinor,
        additionalGrossPayMinor:
            updatedBreakdown.grossPayMinor - baselineBreakdown.grossPayMinor,
        additionalBasePayMinor:
            updatedBreakdown.basePayMinor - baselineBreakdown.basePayMinor,
        additionalOvertimePayMinor:
            updatedBreakdown.overtimePayMinor -
            baselineBreakdown.overtimePayMinor,
        additionalHolidayPayMinor:
            updatedBreakdown.holidayPayMinor -
            baselineBreakdown.holidayPayMinor,
        additionalAllowancePayMinor:
            updatedBreakdown.allowancePayMinor -
            baselineBreakdown.allowancePayMinor,
        additionalDifferentialPayMinor:
            updatedBreakdown.differentialPayMinor -
            baselineBreakdown.differentialPayMinor,
        additionalWorkedMinutes:
            updatedBreakdown.totalWorkedMinutes -
            baselineBreakdown.totalWorkedMinutes,
        updatedShiftCount: updatedProjection.projectedShiftCount,
        baselineCoverage: baselineProjection.coverage,
        updatedCoverage: updatedProjection.coverage,
        baselineConfidence: baselineProjection.confidence.confidence,
        updatedConfidence: updatedProjection.confidence.confidence,
        triggeredChanges: _triggeredChanges(
          baseline: baselineBreakdown,
          updated: updatedBreakdown,
        ),
        goalStatusBefore: baselineTargetTracking.goalProgress?.status,
        goalStatusAfter: updatedTargetTracking.goalProgress?.status,
        overtimeStatusBefore: baselineTargetTracking.overtimeProgress?.status,
        overtimeStatusAfter: updatedTargetTracking.overtimeProgress?.status,
      ),
    );
  }

  Future<Result<_ForecastContext>> _loadContext(EntityId jobId) async {
    final jobResult = await _jobRepository.getJobById(jobId);
    if (jobResult.isFailure) {
      return jobResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }
    final job = jobResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );
    if (job == null) {
      return Failure(
        AppError(code: 'job_not_found', message: 'Job $jobId was not found.'),
      );
    }

    final payRuleResult = await _payRuleSetRepository.getForJob(jobId);
    if (payRuleResult.isFailure) {
      return payRuleResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }
    final holidayRuleResult = await _holidayRuleSetRepository.getForJob(jobId);
    if (holidayRuleResult.isFailure) {
      return holidayRuleResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }
    final advancedPayRuleResult = await _advancedPayRuleSetRepository.getForJob(
      jobId,
    );
    if (advancedPayRuleResult.isFailure) {
      return advancedPayRuleResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }

    final payRuleSet = payRuleResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );
    final holidayRuleSet = holidayRuleResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );
    final advancedPayRuleSet = advancedPayRuleResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );

    if (payRuleSet == null) {
      return const Failure(
        AppError(
          code: 'pay_rules_missing',
          message: 'Pay rules are missing for the selected job.',
        ),
      );
    }
    if (holidayRuleSet == null) {
      return const Failure(
        AppError(
          code: 'holiday_rules_missing',
          message: 'Holiday rules are missing for the selected job.',
        ),
      );
    }

    return Success(
      _ForecastContext(
        job: job,
        payRuleSet: payRuleSet,
        holidayRuleSet: holidayRuleSet,
        advancedPayRuleSet: advancedPayRuleSet,
      ),
    );
  }

  Future<Result<_ForecastProjection>> _buildProjection({
    required _ForecastContext context,
    required AppDateRange range,
    required ShiftInstance? additionalShift,
  }) async {
    final shiftsResult = await _generateShiftScheduleUseCase.call(
      jobId: context.job.id,
      range: range,
    );
    if (shiftsResult.isFailure) {
      return shiftsResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }
    final shifts = shiftsResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );

    final coverageResult = await _buildCoverage(
      jobId: context.job.id,
      range: range,
      additionalShift: additionalShift,
    );
    if (coverageResult.isFailure) {
      return coverageResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }
    final coverage = coverageResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );

    final simulatedShifts = additionalShift == null
        ? shifts
        : [...shifts, additionalShift];
    final projectedShiftCount = simulatedShifts
        .where((shift) => shift.endDateTime.isAfter(shift.startDateTime))
        .length;
    final normalizedCoverage = ForecastCoverage(
      daysCovered: coverage.daysCovered,
      daysTotal: coverage.daysTotal,
      coverageRatio: coverage.coverageRatio,
      coveredShiftCount: projectedShiftCount,
      uncoveredDayCount: coverage.uncoveredDayCount,
    );

    final breakdown = _grossPayCalculator.calculate(
      shifts: simulatedShifts,
      hourlyRateMinor: context.job.hourlyRate.minorUnits,
      dailyOvertimeThresholdMinutes:
          context.payRuleSet.overtimeThresholdDailyMinutes,
      weeklyOvertimeThresholdMinutes:
          context.payRuleSet.overtimeThresholdWeeklyMinutes,
      overtimeMultiplierBps: context.payRuleSet.overtimeMultiplierBps,
      holidayMultiplierBps: context.holidayRuleSet.holidayMultiplierBps,
      advancedPayRuleSet: context.advancedPayRuleSet,
    );
    final confidence = _forecastConfidenceEvaluator.evaluate(
      normalizedCoverage,
    );

    return Success(
      _ForecastProjection(
        breakdown: breakdown,
        coverage: normalizedCoverage,
        confidence: confidence,
        projectedShiftCount: projectedShiftCount,
      ),
    );
  }

  Future<Result<ForecastCoverage>> _buildCoverage({
    required EntityId jobId,
    required AppDateRange range,
    required ShiftInstance? additionalShift,
  }) async {
    final activePatternResult = await _shiftPatternRepository
        .getActivePatternForJob(jobId);
    if (activePatternResult.isFailure) {
      return activePatternResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }
    final overridesResult = await _shiftInstanceRepository
        .listInstancesForRange(jobId: jobId, range: range);
    if (overridesResult.isFailure) {
      return overridesResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }

    final activePattern = activePatternResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );
    final overrides = overridesResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );

    final overridesByDay = {
      for (final override in overrides)
        _dayKey(override.date.startOfDay): override,
    };
    if (additionalShift != null) {
      overridesByDay[_dayKey(additionalShift.date.startOfDay)] =
          additionalShift;
    }

    Map<int, ShiftPatternEntry>? entriesByOffset;
    if (activePattern != null) {
      final entriesResult = await _shiftPatternEntryRepository
          .listEntriesForPattern(activePattern.id);
      if (entriesResult.isFailure) {
        return entriesResult.when(
          success: (_) => throw StateError('Unreachable state'),
          failure: Failure.new,
        );
      }
      final entries = entriesResult.when(
        success: (value) => value,
        failure: (_) => throw StateError('Unreachable state'),
      );
      entriesByOffset = {
        for (final entry in entries)
          _normalizeOffset(entry.dayOffset, activePattern.cycleLengthDays):
              entry,
      };
    }

    var daysCovered = 0;
    for (
      var date = range.start.startOfDay;
      !date.isAfter(range.end.startOfDay);
      date = date.add(const Duration(days: 1))
    ) {
      final override = overridesByDay[_dayKey(date)];
      if (override != null) {
        daysCovered++;
        continue;
      }

      if (activePattern == null ||
          date.isBefore(activePattern.startDate.startOfDay)) {
        continue;
      }

      final cycleOffset = _normalizeOffset(
        date.startOfDay.difference(activePattern.startDate.startOfDay).inDays,
        activePattern.cycleLengthDays,
      );
      if (entriesByOffset?[cycleOffset] != null) {
        daysCovered++;
      }
    }

    final daysTotal = range.daySpan;
    final uncoveredDayCount = daysTotal - daysCovered;
    return Success(
      ForecastCoverage(
        daysCovered: daysCovered,
        daysTotal: daysTotal,
        coverageRatio: daysTotal == 0 ? 0 : daysCovered / daysTotal,
        coveredShiftCount: 0,
        uncoveredDayCount: uncoveredDayCount,
      ),
    );
  }

  Future<Result<ForecastTargetTrackingResult>> _trackingForProjection({
    required _ForecastContext context,
    required AppDateRange range,
    required MinorUnits? monthlyGoalMinor,
    required Minutes? monthlyOvertimeTargetMinutes,
    required ShiftInstance? additionalShift,
  }) async {
    if (monthlyGoalMinor == null && monthlyOvertimeTargetMinutes == null) {
      return const Success(
        ForecastTargetTrackingResult(
          goalProgress: null,
          overtimeProgress: null,
          nudges: <ForecastNudge>[],
        ),
      );
    }

    final projectionResult = await _buildProjection(
      context: context,
      range: range,
      additionalShift: additionalShift,
    );
    if (projectionResult.isFailure) {
      return projectionResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }
    final projection = projectionResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );

    return Success(
      _forecastTargetTracker.track(
        monthRange: range,
        projectedGrossPayMinor: projection.breakdown.grossPayMinor,
        projectedOvertimeMinutes: projection.breakdown.overtimeMinutes,
        confidence: projection.confidence.confidence,
        coverage: projection.coverage,
        monthlyGoalMinor: monthlyGoalMinor,
        monthlyOvertimeTargetMinutes: monthlyOvertimeTargetMinutes,
      ),
    );
  }

  ShiftInstance _buildSimulatedShift({
    required EntityId jobId,
    required ShiftTemplate template,
    required DateTime simulatedDate,
  }) {
    final startDateTime = _dateWithMinutes(
      simulatedDate,
      template.startMinutesLocal,
    );
    var endDateTime = _dateWithMinutes(simulatedDate, template.endMinutesLocal);
    if (!endDateTime.isAfter(startDateTime)) {
      endDateTime = endDateTime.add(const Duration(days: 1));
    }

    return ShiftInstance(
      id: 'simulated:${template.id}:${_dayKey(simulatedDate)}',
      jobId: jobId,
      date: simulatedDate,
      templateSnapshot: ShiftTemplateSnapshot(
        templateId: template.id,
        name: template.name,
        category: template.category,
        startMinutesLocal: template.startMinutesLocal,
        endMinutesLocal: template.endMinutesLocal,
        unpaidBreakMinutes: template.unpaidBreakMinutes,
        defaultNote: template.defaultNote,
      ),
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      unpaidBreakMinutes: template.unpaidBreakMinutes,
      source: ShiftSource.manual,
      note: template.defaultNote,
      isHoliday: false,
      overrideType: null,
    );
  }

  List<ForecastShiftSimulationTrigger> _triggeredChanges({
    required PayBreakdown baseline,
    required PayBreakdown updated,
  }) {
    final triggers = <ForecastShiftSimulationTrigger>[];
    if (updated.overtimePayMinor > baseline.overtimePayMinor) {
      triggers.add(ForecastShiftSimulationTrigger.overtime);
    }
    if (updated.differentialPayMinor > baseline.differentialPayMinor) {
      triggers.add(ForecastShiftSimulationTrigger.differential);
    }
    if (updated.allowancePayMinor > baseline.allowancePayMinor) {
      triggers.add(ForecastShiftSimulationTrigger.allowance);
    }
    return List.unmodifiable(triggers);
  }

  int _normalizeOffset(int rawOffset, int cycleLengthDays) {
    final remainder = rawOffset % cycleLengthDays;
    return remainder < 0 ? remainder + cycleLengthDays : remainder;
  }

  AppDateRange _monthRangeFor(DateTime anchor) {
    final start = anchor.isUtc
        ? DateTime.utc(anchor.year, anchor.month)
        : DateTime(anchor.year, anchor.month);
    final end = anchor.isUtc
        ? DateTime.utc(anchor.year, anchor.month + 1, 0)
        : DateTime(anchor.year, anchor.month + 1, 0);
    return AppDateRange(start: start, end: end);
  }

  DateTime _dateWithMinutes(DateTime date, int minutes) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      minutes ~/ 60,
      minutes % 60,
    );
  }

  String _dayKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}

class _ForecastContext {
  const _ForecastContext({
    required this.job,
    required this.payRuleSet,
    required this.holidayRuleSet,
    required this.advancedPayRuleSet,
  });

  final Job job;
  final PayRuleSet payRuleSet;
  final HolidayRuleSet holidayRuleSet;
  final AdvancedPayRuleSet? advancedPayRuleSet;
}

class _ForecastProjection {
  const _ForecastProjection({
    required this.breakdown,
    required this.coverage,
    required this.confidence,
    required this.projectedShiftCount,
  });

  final PayBreakdown breakdown;
  final ForecastCoverage coverage;
  final ForecastConfidenceResult confidence;
  final int projectedShiftCount;
}
