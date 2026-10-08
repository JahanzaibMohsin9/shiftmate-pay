import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';
import '../../core/common/result.dart';
import '../../core/time/app_date_range.dart';
import '../entities/entities.dart';

abstract interface class CheckOnboardingStatusUseCase {
  Future<Result<bool>> call();
}

abstract interface class CompleteOnboardingUseCase {
  Future<Result<void>> call();
}

abstract interface class SaveOnboardingJobUseCase {
  Future<Result<Job>> call(Job job);
}

abstract interface class ListJobsUseCase {
  Future<Result<List<Job>>> call();
}

abstract interface class SaveJobUseCase {
  Future<Result<Job>> call(Job job);
}

abstract interface class ListShiftTemplatesUseCase {
  Future<Result<List<ShiftTemplate>>> call(EntityId jobId);
}

abstract interface class SaveShiftTemplateUseCase {
  Future<Result<ShiftTemplate>> call(ShiftTemplate template);
}

abstract interface class GenerateShiftScheduleUseCase {
  Future<Result<List<ShiftInstance>>> call({
    required EntityId jobId,
    required AppDateRange range,
  });
}

abstract interface class SaveShiftPatternUseCase {
  Future<Result<ShiftPattern>> call(ShiftPattern pattern);
}

abstract interface class ReplaceShiftPatternEntriesUseCase {
  Future<Result<List<ShiftPatternEntry>>> call({
    required EntityId patternId,
    required List<ShiftPatternEntry> entries,
  });
}

abstract interface class GetPaySummaryUseCase {
  Future<Result<PayPeriodSummary>> call({
    required EntityId jobId,
    required AppDateRange range,
  });
}

abstract interface class GetPayVerificationSummaryUseCase {
  Future<Result<PayVerificationSummary>> call({
    required EntityId jobId,
    required AppDateRange range,
  });
}

abstract interface class GetIncomeForecastUseCase {
  Future<Result<IncomeForecastSummary>> call({
    required EntityId jobId,
    required AppDateRange range,
    required ForecastWindowPreset windowPreset,
    MinorUnits? monthlyGoalMinor,
    Minutes? monthlyOvertimeTargetMinutes,
    DateTime? goalMonthAnchor,
  });
}

abstract interface class SimulateExtraShiftForecastUseCase {
  Future<Result<ForecastShiftSimulationResult>> call({
    required EntityId jobId,
    required AppDateRange range,
    required EntityId shiftTemplateId,
    required DateTime simulatedDate,
    MinorUnits? monthlyGoalMinor,
    Minutes? monthlyOvertimeTargetMinutes,
    DateTime? goalMonthAnchor,
  });
}

abstract interface class BuildShiftImportPreviewUseCase {
  Future<Result<ShiftImportPreviewResult>> call({
    required EntityId jobId,
    required String csvContent,
  });
}

abstract interface class ListReminderRulesUseCase {
  Future<Result<List<ReminderRule>>> call(EntityId jobId);
}

abstract interface class SaveReminderRuleUseCase {
  Future<Result<ReminderRule>> call(ReminderRule rule);
}

abstract interface class BuildScheduleExportUseCase {
  Future<Result<ScheduleExportBundle>> call({
    required EntityId jobId,
    required AppDateRange range,
  });
}

class PayPeriodSummary {
  const PayPeriodSummary({
    required this.jobId,
    required this.range,
    required this.currencyCode,
    required this.periodLabel,
    required this.totalWorkedMinutes,
    required this.totalShifts,
    required this.holidayShifts,
    required this.basePay,
    required this.overtimePay,
    required this.doubleTimePay,
    required this.holidayPay,
    required this.allowancePay,
    required this.differentialPay,
    required this.grossPay,
    required this.doubleTimeEnabled,
    required this.breakdownItems,
  });

  final EntityId jobId;
  final AppDateRange range;
  final String currencyCode;
  final String periodLabel;
  final int totalWorkedMinutes;
  final int totalShifts;
  final int holidayShifts;
  final int basePay;
  final int overtimePay;
  final int doubleTimePay;
  final int holidayPay;
  final int allowancePay;
  final int differentialPay;
  final int grossPay;
  final bool doubleTimeEnabled;
  final List<PaySummaryBreakdownItem> breakdownItems;
}

class PaySummaryBreakdownItem {
  const PaySummaryBreakdownItem({
    required this.label,
    required this.minutes,
    required this.amount,
    required this.type,
  });

  final String label;
  final Minutes minutes;
  final int amount;
  final PaySummaryBreakdownType type;
}

enum PaySummaryBreakdownType { base, overtime, doubleTime, holiday }

class ScheduleExportBundle {
  const ScheduleExportBundle({
    required this.job,
    required this.range,
    required this.instances,
  });

  final Job job;
  final AppDateRange range;
  final List<ShiftInstance> instances;
}
