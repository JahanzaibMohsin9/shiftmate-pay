import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/time/app_date_range.dart';
import '../../../core/services/reminder_notification_service.dart';
import '../../../data/local/database/database_providers.dart';
import '../../../domain/entities/app_entitlement.dart';
import '../../../domain/entities/job.dart';
import '../../../domain/entities/reminder_rule.dart';
import '../../../domain/services/reminder_schedule_planning_service.dart';
import '../../jobs/application/jobs_providers.dart';
import '../../planning/application/planning_providers.dart';
import '../../premium/application/entitlement_provider.dart';

final reminderSelectedJobIdProvider = StateProvider<String?>((ref) => null);

final reminderResolvedJobProvider = Provider<Job?>((ref) {
  final selectedJobId = ref.watch(reminderSelectedJobIdProvider);
  final jobsAsync = ref.watch(jobsProvider);

  return jobsAsync.maybeWhen(
    data: (jobs) {
      if (jobs.isEmpty) {
        return null;
      }

      if (selectedJobId != null) {
        for (final job in jobs) {
          if (job.id == selectedJobId) {
            return job;
          }
        }
      }

      return jobs.first;
    },
    orElse: () => null,
  );
});

final reminderSchedulingWindowProvider = Provider<AppDateRange>((ref) {
  return ref
      .watch(reminderSchedulePlanningServiceProvider)
      .buildSchedulingWindow();
});

final reminderRulesForJobProvider =
    FutureProvider.family<List<ReminderRule>, String>((ref, jobId) async {
      final result = await ref
          .watch(reminderRuleRepositoryProvider)
          .listForJob(jobId);
      return result.when(
        success: (rules) => rules,
        failure: (error) => throw error,
      );
    });

final reminderSchedulePlanProvider = FutureProvider<ReminderSchedulePlan?>((
  ref,
) async {
  final job = ref.watch(reminderResolvedJobProvider);
  if (job == null) {
    return null;
  }

  final reminderRules = await ref.watch(
    reminderRulesForJobProvider(job.id).future,
  );
  final planningSettings = await ref.watch(
    planningSettingsForJobProvider(job.id).future,
  );
  final window = ref.watch(reminderSchedulingWindowProvider);
  final scheduleResult = await ref
      .watch(generatedShiftScheduleUseCaseProvider)
      .call(jobId: job.id, range: window);

  final schedule = scheduleResult.when(
    success: (instances) => instances,
    failure: (error) => throw error,
  );

  return ref
      .watch(reminderSchedulePlanningServiceProvider)
      .buildPlan(
        job: job,
        rules: reminderRules,
        schedule: schedule,
        planningSettings: planningSettings,
        premiumUnlocked: ref
            .watch(entitlementProvider)
            .canAccess(AppFeature.reminders),
      );
});

final reminderNotificationPermissionProvider =
    FutureProvider<NotificationPermissionState>((ref) async {
      return ref
          .watch(reminderNotificationServiceProvider)
          .getPermissionState();
    });
