import 'package:intl/intl.dart';

import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../core/time/app_date_range.dart';
import '../repositories/repositories.dart';
import '../services/gross_pay_calculator.dart';
import 'generate_shift_schedule_usecase_impl.dart';
import 'usecases.dart';

class GetPaySummaryUseCaseImpl implements GetPaySummaryUseCase {
  GetPaySummaryUseCaseImpl({
    required JobRepository jobRepository,
    required PayRuleSetRepository payRuleSetRepository,
    required AdvancedPayRuleSetRepository advancedPayRuleSetRepository,
    required HolidayRuleSetRepository holidayRuleSetRepository,
    required GenerateShiftScheduleUseCaseImpl generateShiftScheduleUseCase,
    required GrossPayCalculator grossPayCalculator,
  }) : _jobRepository = jobRepository,
       _payRuleSetRepository = payRuleSetRepository,
       _advancedPayRuleSetRepository = advancedPayRuleSetRepository,
       _holidayRuleSetRepository = holidayRuleSetRepository,
       _generateShiftScheduleUseCase = generateShiftScheduleUseCase,
       _grossPayCalculator = grossPayCalculator;

  final JobRepository _jobRepository;
  final PayRuleSetRepository _payRuleSetRepository;
  final AdvancedPayRuleSetRepository _advancedPayRuleSetRepository;
  final HolidayRuleSetRepository _holidayRuleSetRepository;
  final GenerateShiftScheduleUseCaseImpl _generateShiftScheduleUseCase;
  final GrossPayCalculator _grossPayCalculator;

  @override
  Future<Result<PayPeriodSummary>> call({
    required EntityId jobId,
    required AppDateRange range,
  }) async {
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
      return Failure(
        const AppError(
          code: 'pay_rules_missing',
          message: 'Pay rules are missing for the selected job.',
        ),
      );
    }
    if (holidayRuleSet == null) {
      return Failure(
        const AppError(
          code: 'holiday_rules_missing',
          message: 'Holiday rules are missing for the selected job.',
        ),
      );
    }

    final scheduleResult = await _generateShiftScheduleUseCase.call(
      jobId: jobId,
      range: range,
    );
    if (scheduleResult.isFailure) {
      return scheduleResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }

    final schedule = scheduleResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );

    final breakdown = _grossPayCalculator.calculate(
      shifts: schedule,
      hourlyRateMinor: job.hourlyRate.minorUnits,
      dailyOvertimeThresholdMinutes: payRuleSet.overtimeThresholdDailyMinutes,
      weeklyOvertimeThresholdMinutes: payRuleSet.overtimeThresholdWeeklyMinutes,
      overtimeMultiplierBps: payRuleSet.overtimeMultiplierBps,
      holidayMultiplierBps: holidayRuleSet.holidayMultiplierBps,
      advancedPayRuleSet: advancedPayRuleSet,
    );

    final doubleTimeEnabled =
        payRuleSet.doubleTimeThresholdMinutes != null &&
        payRuleSet.doubleTimeMultiplierBps != null;

    return Success(
      PayPeriodSummary(
        jobId: jobId,
        range: range,
        currencyCode: job.hourlyRate.currencyCode,
        periodLabel: _periodLabel(range),
        totalWorkedMinutes: breakdown.totalWorkedMinutes,
        totalShifts: schedule
            .where((shift) => shift.endDateTime.isAfter(shift.startDateTime))
            .length,
        holidayShifts: schedule.where((shift) => shift.isHoliday).length,
        basePay: breakdown.basePayMinor,
        overtimePay: breakdown.overtimePayMinor,
        doubleTimePay: 0,
        holidayPay: breakdown.holidayPayMinor,
        allowancePay: breakdown.allowancePayMinor,
        differentialPay: breakdown.differentialPayMinor,
        grossPay: breakdown.grossPayMinor,
        doubleTimeEnabled: doubleTimeEnabled,
        breakdownItems: [
          PaySummaryBreakdownItem(
            label: 'Base pay',
            minutes: breakdown.baseMinutes,
            amount: breakdown.basePayMinor,
            type: PaySummaryBreakdownType.base,
          ),
          PaySummaryBreakdownItem(
            label: 'Overtime',
            minutes: breakdown.overtimeMinutes,
            amount: breakdown.overtimePayMinor,
            type: PaySummaryBreakdownType.overtime,
          ),
          if (doubleTimeEnabled)
            const PaySummaryBreakdownItem(
              label: 'Double time',
              minutes: 0,
              amount: 0,
              type: PaySummaryBreakdownType.doubleTime,
            ),
          PaySummaryBreakdownItem(
            label: 'Holiday pay',
            minutes: breakdown.holidayMinutes,
            amount: breakdown.holidayPayMinor,
            type: PaySummaryBreakdownType.holiday,
          ),
        ],
      ),
    );
  }

  String _periodLabel(AppDateRange range) {
    final sameMonth =
        range.start.month == range.end.month &&
        range.start.year == range.end.year;
    final sameYear = range.start.year == range.end.year;

    if (sameMonth) {
      return '${DateFormat('d').format(range.start)}-${DateFormat('d MMM yyyy').format(range.end)}';
    }
    if (sameYear) {
      return '${DateFormat('d MMM').format(range.start)} - ${DateFormat('d MMM yyyy').format(range.end)}';
    }
    return '${DateFormat('d MMM yyyy').format(range.start)} - ${DateFormat('d MMM yyyy').format(range.end)}';
  }
}
