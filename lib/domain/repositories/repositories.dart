import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../core/time/app_date_range.dart';
import '../entities/entities.dart';

abstract interface class OnboardingRepository {
  Future<Result<bool>> hasCompletedOnboarding();

  Future<Result<void>> setOnboardingCompleted();
}

abstract interface class JobRepository {
  Future<Result<List<Job>>> listJobs();

  Future<Result<Job?>> getJobById(EntityId id);

  Future<Result<Job>> saveJob(Job job);

  Future<Result<void>> archiveJob(EntityId id);
}

abstract interface class ShiftTemplateRepository {
  Future<Result<List<ShiftTemplate>>> listTemplatesForJob(EntityId jobId);

  Future<Result<ShiftTemplate?>> getTemplateById(EntityId id);

  Future<Result<ShiftTemplate>> saveTemplate(ShiftTemplate template);

  Future<Result<void>> deleteTemplate(EntityId id);
}

abstract interface class ShiftPatternRepository {
  Future<Result<List<ShiftPattern>>> listPatternsForJob(EntityId jobId);

  Future<Result<ShiftPattern?>> getActivePatternForJob(EntityId jobId);

  Future<Result<ShiftPattern>> savePattern(ShiftPattern pattern);

  Future<Result<void>> setPatternActive({
    required EntityId patternId,
    required bool isActive,
  });
}

abstract interface class ShiftPatternEntryRepository {
  Future<Result<List<ShiftPatternEntry>>> listEntriesForPattern(
    EntityId patternId,
  );

  Future<Result<List<ShiftPatternEntry>>> replaceEntries({
    required EntityId patternId,
    required List<ShiftPatternEntry> entries,
  });
}

abstract interface class ShiftInstanceRepository {
  Future<Result<List<ShiftInstance>>> listInstancesForRange({
    required EntityId jobId,
    required AppDateRange range,
  });

  Future<Result<ShiftInstance?>> getInstanceById(EntityId id);

  Future<Result<ShiftInstance>> saveInstance(ShiftInstance instance);

  Future<Result<void>> deleteInstance(EntityId id);
}

abstract interface class PayRuleSetRepository {
  Future<Result<PayRuleSet?>> getForJob(EntityId jobId);

  Future<Result<PayRuleSet>> save(PayRuleSet ruleSet);
}

abstract interface class PlanningSettingsRepository {
  Future<Result<PlanningSettings?>> getForJob(EntityId jobId);

  Future<Result<PlanningSettings>> save(PlanningSettings settings);
}

abstract interface class AvailabilityRuleRepository {
  Future<Result<List<AvailabilityRule>>> listForJob(EntityId jobId);

  Future<Result<AvailabilityRule>> save(AvailabilityRule rule);

  Future<Result<void>> delete(EntityId id);
}

abstract interface class AdvancedPayRuleSetRepository {
  Future<Result<AdvancedPayRuleSet?>> getForJob(EntityId jobId);

  Future<Result<AdvancedPayRuleSet>> save(AdvancedPayRuleSet ruleSet);
}

abstract interface class HolidayRuleSetRepository {
  Future<Result<HolidayRuleSet?>> getForJob(EntityId jobId);

  Future<Result<HolidayRuleSet>> save(HolidayRuleSet ruleSet);
}

abstract interface class ReminderRuleRepository {
  Future<Result<List<ReminderRule>>> listForJob(EntityId jobId);

  Future<Result<ReminderRule>> save(ReminderRule rule);

  Future<Result<void>> delete(EntityId id);
}

abstract interface class ActualPayslipRepository {
  Future<Result<List<ActualPayslip>>> listForJob(EntityId jobId);

  Future<Result<ActualPayslip?>> getById(EntityId id);

  Future<Result<ActualPayslip?>> getForJobAndPeriod({
    required EntityId jobId,
    required DateTime periodStart,
    required DateTime periodEnd,
  });

  Future<Result<ActualPayslip>> save(ActualPayslip payslip);

  Future<Result<void>> delete(EntityId id);
}

abstract interface class EntitlementRepository {
  Future<Result<AppEntitlement>> getEntitlement();
}

abstract interface class ExportRepository {
  Future<Result<List<ShiftInstance>>> loadScheduleExportData({
    required EntityId jobId,
    required AppDateRange range,
  });
}
