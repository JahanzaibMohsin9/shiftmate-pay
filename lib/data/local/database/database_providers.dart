import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/reminder_notification_service.dart';
import '../../../domain/entities/app_entitlement.dart';
import '../../../domain/repositories/repositories.dart';
import '../../../domain/services/services.dart';
import '../../../domain/usecases/get_pay_summary_usecase_impl.dart';
import '../../../domain/usecases/get_pay_verification_summary_usecase_impl.dart';
import '../../../domain/usecases/get_income_forecast_usecase_impl.dart';
import '../../../domain/usecases/build_shift_import_preview_usecase_impl.dart';
import '../../../domain/usecases/simulate_extra_shift_forecast_usecase_impl.dart';
import '../../../domain/usecases/generate_shift_schedule_usecase_impl.dart';
import '../../../domain/usecases/build_schedule_export_usecase_impl.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../features/premium/application/entitlement_provider.dart';
import '../../repositories/drift_holiday_rule_set_repository.dart';
import '../../repositories/drift_advanced_pay_rule_set_repository.dart';
import '../../repositories/drift_actual_payslip_repository.dart';
import '../../repositories/drift_availability_rule_repository.dart';
import '../../repositories/drift_job_repository.dart';
import '../../repositories/drift_onboarding_repository.dart';
import '../../repositories/drift_pay_rule_set_repository.dart';
import '../../repositories/drift_planning_settings_repository.dart';
import '../../repositories/drift_reminder_rule_repository.dart';
import '../../repositories/drift_shift_instance_repository.dart';
import '../../repositories/drift_shift_pattern_entry_repository.dart';
import '../../repositories/drift_shift_pattern_repository.dart';
import '../../repositories/drift_shift_template_repository.dart';
import '../../repositories/preferences_entitlement_repository.dart';
import '../preferences/app_preferences.dart';
import 'app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final appPreferencesProvider = Provider<AppPreferences>(
  (ref) => throw UnimplementedError(
    'AppPreferences must be overridden during bootstrap.',
  ),
);

final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => DriftOnboardingRepository(ref.watch(appPreferencesProvider)),
);

final jobRepositoryProvider = Provider<JobRepository>(
  (ref) => DriftJobRepository(ref.watch(appDatabaseProvider)),
);

final shiftTemplateRepositoryProvider = Provider<ShiftTemplateRepository>(
  (ref) => DriftShiftTemplateRepository(ref.watch(appDatabaseProvider)),
);

final shiftPatternRepositoryProvider = Provider<ShiftPatternRepository>(
  (ref) => DriftShiftPatternRepository(ref.watch(appDatabaseProvider)),
);

final shiftPatternEntryRepositoryProvider =
    Provider<ShiftPatternEntryRepository>(
      (ref) => DriftShiftPatternEntryRepository(ref.watch(appDatabaseProvider)),
    );

final shiftInstanceRepositoryProvider = Provider<ShiftInstanceRepository>(
  (ref) => DriftShiftInstanceRepository(ref.watch(appDatabaseProvider)),
);

final payRuleSetRepositoryProvider = Provider<PayRuleSetRepository>(
  (ref) => DriftPayRuleSetRepository(ref.watch(appDatabaseProvider)),
);

final planningSettingsRepositoryProvider = Provider<PlanningSettingsRepository>(
  (ref) => DriftPlanningSettingsRepository(ref.watch(appDatabaseProvider)),
);

final availabilityRuleRepositoryProvider = Provider<AvailabilityRuleRepository>(
  (ref) => DriftAvailabilityRuleRepository(ref.watch(appDatabaseProvider)),
);

final advancedPayRuleSetRepositoryProvider =
    Provider<AdvancedPayRuleSetRepository>(
      (ref) =>
          DriftAdvancedPayRuleSetRepository(ref.watch(appDatabaseProvider)),
    );

final holidayRuleSetRepositoryProvider = Provider<HolidayRuleSetRepository>(
  (ref) => DriftHolidayRuleSetRepository(ref.watch(appDatabaseProvider)),
);

final reminderRuleRepositoryProvider = Provider<ReminderRuleRepository>(
  (ref) => DriftReminderRuleRepository(ref.watch(appDatabaseProvider)),
);

final actualPayslipRepositoryProvider = Provider<ActualPayslipRepository>(
  (ref) => DriftActualPayslipRepository(ref.watch(appDatabaseProvider)),
);

final generatedScheduleServiceProvider = Provider<PatternExpansionService>(
  (ref) => const PatternExpansionService(),
);

final csvShiftImportParserProvider = Provider<CsvShiftImportParser>(
  (ref) => const CsvShiftImportParser(),
);

final shiftImportPreviewBuilderProvider = Provider<ShiftImportPreviewBuilder>(
  (ref) => const ShiftImportPreviewBuilder(),
);

final reminderSchedulePlanningServiceProvider =
    Provider<ReminderSchedulePlanningService>(
      (ref) => const ReminderSchedulePlanningService(),
    );

final personalPlanningServiceProvider = Provider<PersonalPlanningService>(
  (ref) => const PersonalPlanningService(),
);

final reminderNotificationServiceProvider =
    Provider<ReminderNotificationService>(
      (ref) => ReminderNotificationService(
        jobRepository: ref.watch(jobRepositoryProvider),
        reminderRuleRepository: ref.watch(reminderRuleRepositoryProvider),
        planningSettingsRepository: ref.watch(planningSettingsRepositoryProvider),
        generateShiftScheduleUseCase: ref.watch(
          generatedShiftScheduleUseCaseProvider,
        ),
        reminderSchedulePlanningService: ref.watch(
          reminderSchedulePlanningServiceProvider,
        ),
        premiumUnlocked: ref
            .watch(entitlementProvider)
            .canAccess(AppFeature.reminders),
      ),
    );

final generatedShiftScheduleUseCaseProvider =
    Provider<GenerateShiftScheduleUseCaseImpl>(
      (ref) => GenerateShiftScheduleUseCaseImpl(
        shiftPatternRepository: ref.watch(shiftPatternRepositoryProvider),
        shiftPatternEntryRepository: ref.watch(
          shiftPatternEntryRepositoryProvider,
        ),
        shiftTemplateRepository: ref.watch(shiftTemplateRepositoryProvider),
        shiftInstanceRepository: ref.watch(shiftInstanceRepositoryProvider),
        patternExpansionService: ref.watch(generatedScheduleServiceProvider),
      ),
    );

final entitlementRepositoryProvider = Provider<EntitlementRepository>(
  (ref) => PreferencesEntitlementRepository(ref.watch(appPreferencesProvider)),
);

final getPaySummaryUseCaseProvider = Provider<GetPaySummaryUseCase>(
  (ref) => GetPaySummaryUseCaseImpl(
    jobRepository: ref.watch(jobRepositoryProvider),
    payRuleSetRepository: ref.watch(payRuleSetRepositoryProvider),
    advancedPayRuleSetRepository: ref.watch(
      advancedPayRuleSetRepositoryProvider,
    ),
    holidayRuleSetRepository: ref.watch(holidayRuleSetRepositoryProvider),
    generateShiftScheduleUseCase: ref.watch(
      generatedShiftScheduleUseCaseProvider,
    ),
    grossPayCalculator: const GrossPayCalculator(),
  ),
);

final payVerificationComparatorProvider = Provider<PayVerificationComparator>(
  (ref) => const PayVerificationComparator(),
);

final payDiscrepancyDetectorProvider = Provider<PayDiscrepancyDetector>(
  (ref) => const PayDiscrepancyDetector(),
);

final forecastConfidenceEvaluatorProvider =
    Provider<ForecastConfidenceEvaluator>(
      (ref) => const ForecastConfidenceEvaluator(),
    );

final forecastTargetTrackerProvider = Provider<ForecastTargetTracker>(
  (ref) => const ForecastTargetTracker(),
);

final getPayVerificationSummaryUseCaseProvider =
    Provider<GetPayVerificationSummaryUseCase>(
      (ref) => GetPayVerificationSummaryUseCaseImpl(
        actualPayslipRepository: ref.watch(actualPayslipRepositoryProvider),
        getPaySummaryUseCase: ref.watch(getPaySummaryUseCaseProvider),
        comparator: ref.watch(payVerificationComparatorProvider),
        discrepancyDetector: ref.watch(payDiscrepancyDetectorProvider),
      ),
    );

final getIncomeForecastUseCaseProvider = Provider<GetIncomeForecastUseCase>(
  (ref) => GetIncomeForecastUseCaseImpl(
    jobRepository: ref.watch(jobRepositoryProvider),
    payRuleSetRepository: ref.watch(payRuleSetRepositoryProvider),
    advancedPayRuleSetRepository: ref.watch(
      advancedPayRuleSetRepositoryProvider,
    ),
    holidayRuleSetRepository: ref.watch(holidayRuleSetRepositoryProvider),
    shiftPatternRepository: ref.watch(shiftPatternRepositoryProvider),
    shiftPatternEntryRepository: ref.watch(shiftPatternEntryRepositoryProvider),
    shiftInstanceRepository: ref.watch(shiftInstanceRepositoryProvider),
    generateShiftScheduleUseCase: ref.watch(
      generatedShiftScheduleUseCaseProvider,
    ),
    grossPayCalculator: const GrossPayCalculator(),
    forecastConfidenceEvaluator: ref.watch(forecastConfidenceEvaluatorProvider),
    forecastTargetTracker: ref.watch(forecastTargetTrackerProvider),
  ),
);

final simulateExtraShiftForecastUseCaseProvider =
    Provider<SimulateExtraShiftForecastUseCase>(
      (ref) => SimulateExtraShiftForecastUseCaseImpl(
        jobRepository: ref.watch(jobRepositoryProvider),
        payRuleSetRepository: ref.watch(payRuleSetRepositoryProvider),
        advancedPayRuleSetRepository: ref.watch(
          advancedPayRuleSetRepositoryProvider,
        ),
        holidayRuleSetRepository: ref.watch(holidayRuleSetRepositoryProvider),
        shiftTemplateRepository: ref.watch(shiftTemplateRepositoryProvider),
        shiftPatternRepository: ref.watch(shiftPatternRepositoryProvider),
        shiftPatternEntryRepository: ref.watch(
          shiftPatternEntryRepositoryProvider,
        ),
        shiftInstanceRepository: ref.watch(shiftInstanceRepositoryProvider),
        generateShiftScheduleUseCase: ref.watch(
          generatedShiftScheduleUseCaseProvider,
        ),
        grossPayCalculator: const GrossPayCalculator(),
        forecastConfidenceEvaluator: ref.watch(
          forecastConfidenceEvaluatorProvider,
        ),
        forecastTargetTracker: ref.watch(forecastTargetTrackerProvider),
      ),
    );

final buildShiftImportPreviewUseCaseProvider =
    Provider<BuildShiftImportPreviewUseCase>(
      (ref) => BuildShiftImportPreviewUseCaseImpl(
        shiftInstanceRepository: ref.watch(shiftInstanceRepositoryProvider),
        generateShiftScheduleUseCase: ref.watch(
          generatedShiftScheduleUseCaseProvider,
        ),
        parser: ref.watch(csvShiftImportParserProvider),
        previewBuilder: ref.watch(shiftImportPreviewBuilderProvider),
      ),
    );

final buildScheduleExportUseCaseProvider = Provider<BuildScheduleExportUseCase>(
  (ref) => BuildScheduleExportUseCaseImpl(
    jobRepository: ref.watch(jobRepositoryProvider),
    generateShiftScheduleUseCase: ref.watch(
      generatedShiftScheduleUseCaseProvider,
    ),
  ),
);
