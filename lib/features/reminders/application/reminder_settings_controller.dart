import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/identifiers.dart';
import '../../../core/common/shared_types.dart';
import '../../../data/local/database/database_providers.dart';
import '../../../domain/entities/app_entitlement.dart';
import '../../../domain/entities/job.dart';
import '../../../domain/entities/reminder_rule.dart';
import '../../jobs/application/jobs_providers.dart';
import '../../premium/application/entitlement_provider.dart';
import 'reminder_analytics.dart';
import 'reminder_providers.dart';

class ReminderSettingsState {
  const ReminderSettingsState({
    this.isSaving = false,
    this.errorMessage,
    this.savedAt,
  });

  final bool isSaving;
  final String? errorMessage;
  final DateTime? savedAt;

  ReminderSettingsState copyWith({
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
    DateTime? savedAt,
  }) {
    return ReminderSettingsState(
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}

class ReminderSettingsController extends StateNotifier<ReminderSettingsState> {
  ReminderSettingsController(this._ref) : super(const ReminderSettingsState());

  final Ref _ref;

  void selectJob(String? jobId) {
    _ref.read(reminderSelectedJobIdProvider.notifier).state = jobId;
  }

  Future<void> saveSettings({
    required Job job,
    required List<ReminderRule> existingRules,
    required bool shiftStartEnabled,
    required int shiftStartLeadMinutes,
    required bool sleepEnabled,
    required int sleepLeadMinutes,
    required bool prepEnabled,
    required int prepLeadMinutes,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);

    final database = _ref.read(appDatabaseProvider);
    final jobRepository = _ref.read(jobRepositoryProvider);
    final reminderRepository = _ref.read(reminderRuleRepositoryProvider);

    final premiumUnlocked = _ref
        .read(entitlementProvider)
        .canAccess(AppFeature.reminders);

    try {
      await database.transaction(() async {
        final updatedJob = Job(
          id: job.id,
          name: job.name,
          colorHex: job.colorHex,
          currencyCode: job.currencyCode,
          hourlyRate: job.hourlyRate,
          payRuleSetId: job.payRuleSetId,
          holidayRuleSetId: job.holidayRuleSetId,
          defaultSleepLeadMinutes: sleepLeadMinutes,
          isArchived: job.isArchived,
          createdAt: job.createdAt,
          updatedAt: DateTime.now().toUtc(),
        );

        final jobSave = await jobRepository.saveJob(updatedJob);
        if (jobSave.isFailure) {
          throw jobSave.when(
            success: (_) => StateError('Expected job save failure.'),
            failure: (error) => error,
          );
        }

        for (final entry in <(ReminderType, bool, int)>[
          (ReminderType.shiftStart, shiftStartEnabled, shiftStartLeadMinutes),
          (ReminderType.sleep, sleepEnabled, sleepLeadMinutes),
          if (premiumUnlocked ||
              _findRule(existingRules, ReminderType.prep) != null)
            (
              ReminderType.prep,
              premiumUnlocked && prepEnabled,
              prepLeadMinutes,
            ),
        ]) {
          final existingRule = _findRule(existingRules, entry.$1);
          final rule = ReminderRule(
            id: existingRule?.id ?? AppId.generate(),
            jobId: job.id,
            type: entry.$1,
            leadMinutes: entry.$3,
            enabled: entry.$2,
          );

          final saveResult = await reminderRepository.save(rule);
          if (saveResult.isFailure) {
            throw saveResult.when(
              success: (_) => StateError('Expected reminder save failure.'),
              failure: (error) => error,
            );
          }
        }
      });

      _ref.invalidate(jobsProvider);
      _ref.invalidate(reminderRulesForJobProvider(job.id));
      _ref.invalidate(reminderSchedulePlanProvider);
      _ref.invalidate(reminderNotificationPermissionProvider);
      await _ref
          .read(reminderNotificationServiceProvider)
          .syncAllReminderSchedules();
      _ref
          .read(reminderAnalyticsTrackerProvider)
          .track(
            ReminderAnalyticsEvent.reminderSettingsSaved,
            fields: {
              'job_id': job.id,
              'entitlement_state': premiumUnlocked ? 'premium' : 'free',
              'shift_start_enabled': shiftStartEnabled,
              'sleep_enabled': sleepEnabled,
              'prep_enabled': premiumUnlocked && prepEnabled,
              'active_types': [
                if (shiftStartEnabled) ReminderType.shiftStart.name,
                if (sleepEnabled) ReminderType.sleep.name,
                if (premiumUnlocked && prepEnabled) ReminderType.prep.name,
              ].join(','),
            },
          );

      state = ReminderSettingsState(isSaving: false, savedAt: DateTime.now());
    } catch (error) {
      state = state.copyWith(isSaving: false, errorMessage: error.toString());
    }
  }

  ReminderRule? _findRule(List<ReminderRule> rules, ReminderType type) {
    for (final rule in rules) {
      if (rule.type == type) {
        return rule;
      }
    }

    return null;
  }
}

final reminderSettingsControllerProvider =
    StateNotifierProvider<ReminderSettingsController, ReminderSettingsState>(
      ReminderSettingsController.new,
    );
