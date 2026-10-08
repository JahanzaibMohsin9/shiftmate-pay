import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/widgets/cards/app_card.dart';
import '../../../../app/widgets/feature_gate.dart';
import '../../../../app/widgets/inputs/app_text_field.dart';
import '../../../../app/widgets/layout/page_scaffold.dart';
import '../../../../core/common/shared_types.dart';
import '../../../../core/services/reminder_notification_service.dart';
import '../../../../data/local/database/database_providers.dart';
import '../../../../domain/entities/app_entitlement.dart';
import '../../../../domain/entities/job.dart';
import '../../../../domain/entities/reminder_rule.dart';
import '../../../../domain/entities/shift_instance.dart';
import '../../../../domain/services/reminder_schedule_planning_service.dart';
import '../../../jobs/application/jobs_providers.dart';
import '../../../premium/application/entitlement_provider.dart';
import '../../application/reminder_analytics.dart';
import '../../application/reminder_providers.dart';
import '../../application/reminder_settings_controller.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shiftLeadController = TextEditingController(
    text: ReminderSchedulePlanningService.defaultShiftStartLeadMinutes
        .toString(),
  );
  final _sleepLeadController = TextEditingController(
    text: ReminderSchedulePlanningService.defaultSleepLeadMinutes.toString(),
  );
  final _prepLeadController = TextEditingController(text: '75');

  bool _shiftStartEnabled = true;
  bool _sleepEnabled = true;
  bool _prepEnabled = false;
  String? _initializedJobId;

  @override
  void dispose() {
    _shiftLeadController.dispose();
    _sleepLeadController.dispose();
    _prepLeadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(jobsProvider);
    final selectedJob = ref.watch(reminderResolvedJobProvider);
    final planAsync = ref.watch(reminderSchedulePlanProvider);
    final permissionAsync = ref.watch(reminderNotificationPermissionProvider);
    final settingsState = ref.watch(reminderSettingsControllerProvider);
    final entitlement = ref.watch(entitlementProvider);

    return PageScaffold(
      title: 'Reminders',
      body: jobsAsync.when(
        data: (jobs) {
          if (jobs.isEmpty || selectedJob == null) {
            return const Center(
              child: Text('Create a job first to configure reminders.'),
            );
          }

          final rulesAsync = ref.watch(
            reminderRulesForJobProvider(selectedJob.id),
          );

          return rulesAsync.when(
            data: (rules) {
              final previewPlan = planAsync.maybeWhen(
                data: (plan) => plan,
                orElse: () => null,
              );
              _syncForm(
                job: selectedJob,
                rules: rules,
                previewPlan: previewPlan,
                planningService: ref.read(
                  reminderSchedulePlanningServiceProvider,
                ),
                premiumUnlocked: entitlement.canAccess(AppFeature.reminders),
              );

              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.only(top: 16, bottom: 24),
                  children: [
                    _JobPicker(
                      jobs: jobs,
                      selectedJobId: selectedJob.id,
                      onChanged: (jobId) => ref
                          .read(reminderSettingsControllerProvider.notifier)
                          .selectJob(jobId),
                    ),
                    const SizedBox(height: 16),
                    permissionAsync.when(
                      data: (permissionState) => _NotificationPermissionCard(
                        permissionState: permissionState,
                        onRequestPermission: () => _requestPermission(context),
                        onRescheduleNow: () =>
                            _rescheduleNotifications(context),
                      ),
                      loading: () => const AppCard(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                      error: (error, _) => AppCard(
                        child: Text(
                          'Unable to check notification permission: $error',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ReminderStrategyCard(
                      premiumUnlocked: entitlement.canAccess(
                        AppFeature.reminders,
                      ),
                      nextShift: previewPlan?.nextShift,
                      shortRestContext: previewPlan?.shortRestContext,
                      suggestedPrepMinutes:
                          int.tryParse(_prepLeadController.text) ?? 75,
                    ),
                    const SizedBox(height: 16),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reminder settings',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            entitlement.canAccess(AppFeature.reminders)
                                ? 'Keep the free basics easy to scan, then layer one extra prep reminder when a shift needs more buffer than a simple heads-up.'
                                : 'Free reminders stay focused on the basics: one shift-start alert plus one sleep reminder per job.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          _ReminderRuleTile(
                            title: 'Shift start reminder',
                            subtitle:
                                'Alert before the next scheduled shift begins.',
                            value: _shiftStartEnabled,
                            onChanged: (value) =>
                                setState(() => _shiftStartEnabled = value),
                            field: AppTextField(
                              label: 'Lead time (minutes)',
                              controller: _shiftLeadController,
                              keyboardType: TextInputType.number,
                              validator: _validateMinutes,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _ReminderRuleTile(
                            title: 'Sleep reminder',
                            subtitle:
                                'Suggest when to start winding down before the next shift.',
                            value: _sleepEnabled,
                            onChanged: (value) =>
                                setState(() => _sleepEnabled = value),
                            field: AppTextField(
                              label: 'Lead time (minutes)',
                              controller: _sleepLeadController,
                              keyboardType: TextInputType.number,
                              validator: _validateMinutes,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (entitlement.canAccess(AppFeature.reminders))
                            _ReminderRuleTile(
                              title: 'Prep reminder',
                              subtitle:
                                  'Add a calmer buffer for commute, bag check, or shift-specific prep.',
                              value: _prepEnabled,
                              onChanged: (value) =>
                                  setState(() => _prepEnabled = value),
                              badge: const _RuleBadge(label: 'Premium'),
                              field: Column(
                                children: [
                                  AppTextField(
                                    label: 'Lead time (minutes)',
                                    controller: _prepLeadController,
                                    keyboardType: TextInputType.number,
                                    validator: _validateMinutes,
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _prepSuggestionCopy(previewPlan),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            const PremiumTeaserCard(
                              title: 'Premium reminder upgrade',
                              feature: 'reminders',
                              entryPoint: 'reminders_prep_teaser',
                              description:
                                  'Keep free reminders simple, then add one richer prep reminder when you want commute or get-ready buffer tied to the next shift type.',
                              ctaLabel: 'See Premium reminder tools',
                              features: [
                                'Prep reminder with personalized wording',
                                'Shift-type-aware default timing suggestions',
                                'Richer preview of all active reminder types',
                              ],
                            ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: settingsState.isSaving
                                ? null
                                : () => _save(job: selectedJob, rules: rules),
                            icon: settingsState.isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save_outlined),
                            label: Text(
                              settingsState.isSaving
                                  ? 'Saving...'
                                  : 'Save reminder settings',
                            ),
                          ),
                          if (settingsState.errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              settingsState.errorMessage!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                          if (settingsState.savedAt != null &&
                              settingsState.errorMessage == null) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Saved ${DateFormat('MMM d, h:mm a').format(settingsState.savedAt!)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    planAsync.when(
                      data: (plan) => _ReminderPlanCard(
                        plan: plan,
                        premiumUnlocked: entitlement.canAccess(
                          AppFeature.reminders,
                        ),
                      ),
                      loading: () => const AppCard(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                      error: (error, _) => AppCard(
                        child: Text(
                          'Unable to build the reminder preview: $error',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) =>
                Center(child: Text('Unable to load reminder rules: $error')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Unable to load jobs: $error')),
      ),
    );
  }

  void _syncForm({
    required Job job,
    required List<ReminderRule> rules,
    required ReminderSchedulePlan? previewPlan,
    required ReminderSchedulePlanningService planningService,
    required bool premiumUnlocked,
  }) {
    if (_initializedJobId == job.id) {
      return;
    }

    _initializedJobId = job.id;
    final shiftRule = _findRule(rules, ReminderType.shiftStart);
    final sleepRule = _findRule(rules, ReminderType.sleep);
    final prepRule = _findRule(rules, ReminderType.prep);
    final shiftCategory = previewPlan?.nextShift?.templateSnapshot?.category;

    _shiftStartEnabled = shiftRule?.enabled ?? false;
    _sleepEnabled = sleepRule?.enabled ?? true;
    _prepEnabled = premiumUnlocked && (prepRule?.enabled ?? false);
    _shiftLeadController.text =
        (shiftRule?.leadMinutes ??
                ReminderSchedulePlanningService.defaultShiftStartLeadMinutes)
            .toString();
    _sleepLeadController.text =
        (sleepRule?.leadMinutes ??
                job.defaultSleepLeadMinutes ??
                ReminderSchedulePlanningService.defaultSleepLeadMinutes)
            .toString();
    _prepLeadController.text =
        (prepRule?.leadMinutes ??
                planningService.suggestedLeadMinutesFor(
                  type: ReminderType.prep,
                  shiftCategory: shiftCategory,
                ))
            .toString();
  }

  ReminderRule? _findRule(List<ReminderRule> rules, ReminderType type) {
    for (final rule in rules) {
      if (rule.type == type) {
        return rule;
      }
    }

    return null;
  }

  String? _validateMinutes(String? value) {
    final parsed = int.tryParse(value ?? '');
    if (parsed == null) {
      return 'Enter reminder lead minutes.';
    }
    if (parsed < 0) {
      return 'Lead minutes must be zero or more.';
    }
    if (parsed > 7 * 24 * 60) {
      return 'Lead minutes must stay within one week.';
    }
    return null;
  }

  Future<void> _save({
    required Job job,
    required List<ReminderRule> rules,
  }) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(reminderSettingsControllerProvider.notifier)
        .saveSettings(
          job: job,
          existingRules: rules,
          shiftStartEnabled: _shiftStartEnabled,
          shiftStartLeadMinutes: int.parse(_shiftLeadController.text),
          sleepEnabled: _sleepEnabled,
          sleepLeadMinutes: int.parse(_sleepLeadController.text),
          prepEnabled: _prepEnabled,
          prepLeadMinutes: int.parse(_prepLeadController.text),
        );
  }

  Future<void> _requestPermission(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final permission = await ref
        .read(reminderNotificationServiceProvider)
        .requestPermission();
    ref.invalidate(reminderNotificationPermissionProvider);

    if (permission == NotificationPermissionState.granted) {
      await ref
          .read(reminderNotificationServiceProvider)
          .syncAllReminderSchedules();
      ref
          .read(reminderAnalyticsTrackerProvider)
          .track(
            ReminderAnalyticsEvent.reminderRescheduled,
            fields: const {'source': 'permission_granted'},
          );
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Notification permission granted and reminders rescheduled.',
          ),
        ),
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          permission == NotificationPermissionState.unsupported
              ? 'Notifications are not supported on this platform.'
              : 'Notification permission was not granted. Reminder previews are still available in the app.',
        ),
      ),
    );
  }

  Future<void> _rescheduleNotifications(BuildContext context) async {
    await ref
        .read(reminderNotificationServiceProvider)
        .syncAllReminderSchedules();
    ref.invalidate(reminderNotificationPermissionProvider);
    ref
        .read(reminderAnalyticsTrackerProvider)
        .track(
          ReminderAnalyticsEvent.reminderRescheduled,
          fields: const {'source': 'manual_reschedule'},
        );

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reminder notifications have been rescheduled.'),
      ),
    );
  }

  String _prepSuggestionCopy(ReminderSchedulePlan? plan) {
    final category = plan?.nextShift?.templateSnapshot?.category;
    return switch (category) {
      ShiftCategory.night =>
        'Suggested because the next shift looks like a night shift: start with 180 minutes so commute and prep do not eat into rest.',
      ShiftCategory.evening =>
        'Suggested because the next shift looks like an evening shift: start with 120 minutes for commute and handoff prep.',
      ShiftCategory.day =>
        'Suggested because the next shift looks like a day shift: start with 75 minutes for commute or get-ready time.',
      _ =>
        'Prep reminder defaults stay intentionally light: one extra reminder with a single lead time, no template sprawl in this release.',
    };
  }
}

class _JobPicker extends StatelessWidget {
  const _JobPicker({
    required this.jobs,
    required this.selectedJobId,
    required this.onChanged,
  });

  final List<Job> jobs;
  final String selectedJobId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: DropdownButtonFormField<String>(
        initialValue: selectedJobId,
        decoration: const InputDecoration(
          labelText: 'Job',
          prefixIcon: Icon(Icons.work_outline),
        ),
        items: jobs
            .map(
              (job) => DropdownMenuItem<String>(
                value: job.id,
                child: Text(job.name),
              ),
            )
            .toList(growable: false),
        onChanged: onChanged,
      ),
    );
  }
}

class _ReminderRuleTile extends StatelessWidget {
  const _ReminderRuleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.field,
    this.badge,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget field;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.flat,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(title),
                  subtitle: Text(subtitle),
                  value: value,
                  onChanged: onChanged,
                ),
              ),
              if (badge != null) ...[const SizedBox(width: 12), badge!],
            ],
          ),
          AbsorbPointer(
            absorbing: !value,
            child: Opacity(opacity: value ? 1 : 0.45, child: field),
          ),
        ],
      ),
    );
  }
}

class _ReminderStrategyCard extends StatelessWidget {
  const _ReminderStrategyCard({
    required this.premiumUnlocked,
    required this.nextShift,
    required this.shortRestContext,
    required this.suggestedPrepMinutes,
  });

  final bool premiumUnlocked;
  final ShiftInstance? nextShift;
  final ShortRestContext? shortRestContext;
  final int suggestedPrepMinutes;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEE, MMM d h:mm a');
    final resolvedNextShift = nextShift;
    final shiftCategory = resolvedNextShift?.templateSnapshot?.category;
    final nextShiftLabel = resolvedNextShift == null
        ? 'No upcoming shift in the next reminder window yet.'
        : 'Next shift: ${formatter.format(resolvedNextShift.startDateTime)}';
    final shiftTypeLabel = switch (shiftCategory) {
      ShiftCategory.night => 'Night shift defaults are the best fit right now.',
      ShiftCategory.evening =>
        'Evening shift defaults are the best fit right now.',
      ShiftCategory.day => 'Day shift defaults are the best fit right now.',
      ShiftCategory.custom =>
        'Custom shift timing is active, so reminder defaults stay conservative.',
      _ => 'Reminder defaults stay generic until a shift type is visible.',
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Smarter reminder plan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(nextShiftLabel),
          const SizedBox(height: 4),
          Text(shiftTypeLabel),
          if (shortRestContext != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.errorContainer.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Short rest ahead: ${shortRestContext!.restGapMinutes} minutes available against a target of ${shortRestContext!.minimumRestMinutes}.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            premiumUnlocked
                ? 'Premium adds one richer prep reminder, suggested here at about $suggestedPrepMinutes minutes.'
                : 'Free keeps reminders to two basics. Premium adds one extra prep reminder instead of a long list.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _RuleBadge extends StatelessWidget {
  const _RuleBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ReminderPlanCard extends StatelessWidget {
  const _ReminderPlanCard({required this.plan, required this.premiumUnlocked});

  final ReminderSchedulePlan? plan;
  final bool premiumUnlocked;

  @override
  Widget build(BuildContext context) {
    if (plan == null) {
      return const AppCard(
        child: Text('Reminder timing will appear after a job is available.'),
      );
    }

    final currentPlan = plan!;
    final nextShift = currentPlan.nextShift;
    final formatter = DateFormat('EEE, MMM d - h:mm a');

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reminder preview',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Rolling window: next ${ReminderSchedulePlanningService.defaultSchedulingWindowDays} days',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          if (nextShift == null)
            const Text(
              'No upcoming shifts were found in the current reminder window.',
            )
          else ...[
            Text(
              'Next shift: ${formatter.format(nextShift.startDateTime)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              _nextShiftTypeCopy(nextShift.templateSnapshot?.category),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 16),
          if (currentPlan.recommendations.isEmpty)
            Text(
              premiumUnlocked
                  ? 'No enabled reminder rules currently produce a future reminder in this window.'
                  : 'No enabled free-tier reminder rules currently produce a future reminder in this window.',
            )
          else
            for (final recommendation in currentPlan.recommendations) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(_iconFor(recommendation.type)),
                title: Text(recommendation.title),
                subtitle: Text(
                  '${recommendation.leadMinutes} minutes before ${formatter.format(recommendation.shiftStart)}\n${recommendation.message}',
                ),
                trailing: Text(
                  DateFormat('h:mm a').format(recommendation.scheduledFor),
                ),
              ),
              const Divider(height: 1),
            ],
        ],
      ),
    );
  }

  String _nextShiftTypeCopy(ShiftCategory? category) {
    return switch (category) {
      ShiftCategory.night =>
        'Night shifts get longer prep suggestions so travel and handoff time do not surprise you.',
      ShiftCategory.evening =>
        'Evening shifts keep prep suggestions slightly longer than a basic start alert.',
      ShiftCategory.day =>
        'Day shifts keep reminders lighter unless you enable the extra prep buffer.',
      _ =>
        'Reminder wording stays personalized where possible, but this release keeps the rule set intentionally small.',
    };
  }

  IconData _iconFor(ReminderType type) {
    return switch (type) {
      ReminderType.sleep => Icons.bedtime_outlined,
      ReminderType.prep => Icons.backpack_outlined,
      _ => Icons.notifications_active_outlined,
    };
  }
}

class _NotificationPermissionCard extends StatelessWidget {
  const _NotificationPermissionCard({
    required this.permissionState,
    required this.onRequestPermission,
    required this.onRescheduleNow,
  });

  final NotificationPermissionState permissionState;
  final VoidCallback onRequestPermission;
  final VoidCallback onRescheduleNow;

  @override
  Widget build(BuildContext context) {
    final (title, description, color) = switch (permissionState) {
      NotificationPermissionState.granted => (
        'Notifications enabled',
        'Reminder scheduling is active. Use reschedule if you change shifts through import, overrides, or job edits and want to force a fresh queue immediately.',
        Theme.of(context).colorScheme.primary,
      ),
      NotificationPermissionState.denied => (
        'Notifications not enabled',
        'The app can still preview reminder times, but local notifications will not fire until permission is granted.',
        Theme.of(context).colorScheme.error,
      ),
      NotificationPermissionState.unsupported => (
        'Notifications unsupported here',
        'Reminder previews still work, but this platform may not request permission or deliver reminders the same way.',
        Theme.of(context).colorScheme.secondary,
      ),
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_active_outlined, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(description),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (permissionState != NotificationPermissionState.granted)
                FilledButton.icon(
                  onPressed: onRequestPermission,
                  icon: const Icon(Icons.lock_open_outlined),
                  label: const Text('Request permission'),
                ),
              OutlinedButton.icon(
                onPressed: onRescheduleNow,
                icon: const Icon(Icons.sync_outlined),
                label: const Text('Reschedule reminders'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
