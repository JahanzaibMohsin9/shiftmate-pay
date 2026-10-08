import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftmate_pay/app/routing/app_router.dart';
import 'package:shiftmate_pay/core/common/app_constants.dart';
import 'package:shiftmate_pay/core/common/result.dart';
import 'package:shiftmate_pay/core/services/reminder_notification_service.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/data/local/database/app_database.dart';
import 'package:shiftmate_pay/data/local/database/database_providers.dart';
import 'package:shiftmate_pay/data/local/preferences/app_preferences.dart';
import 'package:shiftmate_pay/domain/entities/job.dart';
import 'package:shiftmate_pay/domain/entities/planning_settings.dart';
import 'package:shiftmate_pay/domain/entities/reminder_rule.dart';
import 'package:shiftmate_pay/domain/entities/shift_instance.dart';
import 'package:shiftmate_pay/domain/repositories/repositories.dart';
import 'package:shiftmate_pay/domain/services/reminder_schedule_planning_service.dart';
import 'package:shiftmate_pay/domain/usecases/usecases.dart';
import 'package:shiftmate_pay/features/onboarding/application/onboarding_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OnboardingController', () {
    late AppDatabase database;
    late AppPreferences preferences;
    late ProviderContainer container;
    late _FakeReminderNotificationService reminderNotificationService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = AppPreferences(await SharedPreferences.getInstance());
      database = AppDatabase(executor: NativeDatabase.memory());
      reminderNotificationService = _FakeReminderNotificationService();
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          appPreferencesProvider.overrideWithValue(preferences),
          reminderNotificationServiceProvider.overrideWithValue(
            reminderNotificationService,
          ),
        ],
      );
    });

    tearDown(() async {
      container.dispose();
      await database.close();
    });

    test(
      'submits onboarding and persists job, rules, and completion flag',
      () async {
        final controller = container.read(
          onboardingControllerProvider.notifier,
        );

        final route = await controller.submit(
          jobName: '  Ward Nights  ',
          colorHex: '#4F46E5',
          currencyCode: 'usd',
          hourlyRateMajorUnits: 32.5,
          overtimeDailyHours: 8,
          overtimeWeeklyHours: 40,
          overtimeMultiplier: 1.75,
          holidayMultiplier: 2.0,
          defaultReminderLeadMinutes: 480,
        );

        final state = container.read(onboardingControllerProvider);
        final jobs = await database.select(database.jobsTable).get();
        final payRules = await database.select(database.payRuleSetsTable).get();
        final holidayRules = await database
            .select(database.holidayRuleSetsTable)
            .get();
        final reminderRules = await database
            .select(database.reminderRulesTable)
            .get();

        expect(route, AppRoutes.calendar);
        expect(state.isSubmitting, isFalse);
        expect(state.errorMessage, isNull);
        expect(jobs, hasLength(1));
        expect(jobs.single.name, 'Ward Nights');
        expect(jobs.single.currencyCode, 'USD');
        expect(jobs.single.hourlyRateMinorUnits, 3250);
        expect(jobs.single.defaultSleepLeadMinutes, 480);
        expect(payRules, hasLength(1));
        expect(
          payRules.single.overtimeThresholdDailyMinutes,
          8 * AppConstants.minutesPerHour,
        );
        expect(
          payRules.single.overtimeThresholdWeeklyMinutes,
          40 * AppConstants.minutesPerHour,
        );
        expect(payRules.single.overtimeMultiplierBps, 17500);
        expect(holidayRules, hasLength(1));
        expect(holidayRules.single.holidayMultiplierBps, 20000);
        expect(reminderRules, hasLength(1));
        expect(reminderRules.single.leadMinutes, 480);
        expect(reminderRules.single.enabled, isTrue);
        expect(preferences.onboardingCompleted, isTrue);
        expect(reminderNotificationService.syncAllCalls, 1);
      },
    );

    test('editing an existing job also reschedules reminders', () async {
      final controller = container.read(onboardingControllerProvider.notifier);

      final firstRoute = await controller.submit(
        jobName: 'Ward Nights',
        colorHex: '#4F46E5',
        currencyCode: 'usd',
        hourlyRateMajorUnits: 32.5,
        overtimeDailyHours: 8,
        overtimeWeeklyHours: 40,
        overtimeMultiplier: 1.5,
        holidayMultiplier: 2.0,
        defaultReminderLeadMinutes: 480,
      );

      final existingJob =
          (await database.select(database.jobsTable).get()).single;
      final existingPayRule =
          (await database.select(database.payRuleSetsTable).get()).single;
      final existingHolidayRule =
          (await database.select(database.holidayRuleSetsTable).get()).single;

      final secondRoute = await controller.submit(
        existingJobId: existingJob.id,
        existingPayRuleSetId: existingPayRule.id,
        existingHolidayRuleSetId: existingHolidayRule.id,
        jobName: 'Ward Nights Updated',
        colorHex: '#4F46E5',
        currencyCode: 'usd',
        hourlyRateMajorUnits: 34,
        overtimeDailyHours: 8,
        overtimeWeeklyHours: 40,
        overtimeMultiplier: 2.0,
        holidayMultiplier: 2.0,
        defaultReminderLeadMinutes: 420,
      );

      final updatedJob =
          (await database.select(database.jobsTable).get()).single;

      expect(firstRoute, AppRoutes.calendar);
      expect(secondRoute, AppRoutes.jobs);
      expect(updatedJob.name, 'Ward Nights Updated');
      expect(updatedJob.defaultSleepLeadMinutes, 420);
      expect(reminderNotificationService.syncAllCalls, 2);
    });
  });
}

class _FakeReminderNotificationService extends ReminderNotificationService {
  _FakeReminderNotificationService()
    : super(
        jobRepository: _NoopJobRepository(),
        reminderRuleRepository: _NoopReminderRuleRepository(),
        planningSettingsRepository: _NoopPlanningSettingsRepository(),
        generateShiftScheduleUseCase: _NoopGenerateShiftScheduleUseCase(),
        reminderSchedulePlanningService:
            const ReminderSchedulePlanningService(),
        premiumUnlocked: true,
      );

  int syncAllCalls = 0;

  @override
  Future<void> syncAllReminderSchedules() async {
    syncAllCalls += 1;
  }
}

class _NoopReminderRuleRepository implements ReminderRuleRepository {
  @override
  Future<Result<void>> delete(String id) async => const Success(null);

  @override
  Future<Result<List<ReminderRule>>> listForJob(String jobId) async =>
      const Success([]);

  @override
  Future<Result<ReminderRule>> save(ReminderRule rule) async => Success(rule);
}

class _NoopPlanningSettingsRepository implements PlanningSettingsRepository {
  @override
  Future<Result<PlanningSettings?>> getForJob(String jobId) async =>
      const Success(null);

  @override
  Future<Result<PlanningSettings>> save(PlanningSettings settings) async =>
      Success(settings);
}

class _NoopJobRepository implements JobRepository {
  @override
  Future<Result<void>> archiveJob(String id) async => const Success(null);

  @override
  Future<Result<Job?>> getJobById(String id) async => const Success(null);

  @override
  Future<Result<List<Job>>> listJobs() async => const Success([]);

  @override
  Future<Result<Job>> saveJob(Job job) async => Success(job);
}

class _NoopGenerateShiftScheduleUseCase
    implements GenerateShiftScheduleUseCase {
  @override
  Future<Result<List<ShiftInstance>>> call({
    required String jobId,
    required AppDateRange range,
  }) async => const Success([]);
}
