import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routing/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/widgets/cards/app_card.dart';
import '../../../../core/common/shared_types.dart';
import '../../../../core/money/money_formatter.dart';
import '../../../../domain/entities/app_entitlement.dart';
import '../../../../domain/entities/job.dart';
import '../../../../domain/entities/shift_pattern.dart';
import '../../../../domain/entities/shift_template.dart';
import '../../../patterns/application/pattern_builder_providers.dart';
import '../../../planning/application/planning_providers.dart';
import '../../../premium/application/entitlement_provider.dart';
import '../../../premium/application/premium_analytics.dart';
import '../../application/jobs_providers.dart';
import 'create_shift_template_screen.dart';
import 'personal_planning_screen.dart';

class JobsScreen extends ConsumerWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(jobsProvider);
    final entitlement = ref.watch(entitlementProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        actions: [
          IconButton(
            tooltip: 'Premium',
            onPressed: () => context.push(AppRoutes.premium),
            icon: const Icon(Icons.workspace_premium_outlined),
          ),
        ],
      ),
      body: jobsAsync.when(
        data: (jobs) {
          if (jobs.isEmpty) {
            return _EmptyJobsState(
              onCreateJob: () => context.go(AppRoutes.onboarding),
              onViewPremium: () => context.push(
                AppRoutes.premiumWithContext(entryPoint: 'jobs_empty_state'),
              ),
            );
          }

          return ListView(
            padding: AppSpacing.pagePadding,
            children: [
              for (final job in jobs) ...[_JobCard(job: job), AppSpacing.gapMd],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _JobsErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(jobsProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New job',
        onPressed: () {
          final jobs = jobsAsync.valueOrNull;
          if (jobs == null) {
            return;
          }

          if (jobs.isEmpty) {
            context.go(AppRoutes.onboarding);
            return;
          }

          if (!entitlement.canAccess(AppFeature.multipleJobs)) {
            ref
                .read(premiumAnalyticsTrackerProvider)
                .track(
                  PremiumAnalyticsEvent.premiumGateEncountered,
                  fields: {
                    'screen_name': 'jobs',
                    'entry_point': 'jobs_new_job_limit',
                    'entitlement_state': entitlement.premium
                        ? 'premium'
                        : 'free',
                    'result': AppFeature.multipleJobs.name,
                  },
                );
            context.push(
              AppRoutes.premiumWithContext(
                entryPoint: 'jobs_new_job_limit',
                feature: AppFeature.multipleJobs.name,
              ),
            );
            return;
          }

          context.go(AppRoutes.newJob);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _JobCard extends ConsumerWidget {
  const _JobCard({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(shiftTemplatesForJobProvider(job.id));
    final patternsAsync = ref.watch(shiftPatternsForJobProvider(job.id));
    final planningSettingsAsync = ref.watch(
      planningSettingsForJobProvider(job.id),
    );
    final availabilityRulesAsync = ref.watch(
      availabilityRulesForJobProvider(job.id),
    );
    final entitlement = ref.watch(entitlementProvider);
    final theme = Theme.of(context);

    return AppCard(
      padding: AppSpacing.cardPaddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: _parseHexColor(job.colorHex),
                radius: 8,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  job.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                label: 'Pay ${MoneyFormatter.formatAmount(job.hourlyRate)}',
              ),
              _InfoChip(
                label:
                    'Sleep ${job.defaultSleepLeadMinutes ?? 0}m before shift',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: _JobActions(job: job, entitlement: entitlement),
          ),
          const SizedBox(height: 20),
          _CollapsibleSection(
            title: 'Planning support',
            subtitle: 'Worker-side rest, overtime, and availability guidance.',
            icon: Icons.health_and_safety_outlined,
            initiallyExpanded: true,
            action: _SectionActionButton(
              icon: Icons.tune_outlined,
              label: 'Edit',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PersonalPlanningScreen(
                      jobId: job.id,
                      jobName: job.name,
                    ),
                  ),
                );
              },
            ),
            child: _PlanningSummary(
              settingsAsync: planningSettingsAsync,
              availabilityRulesAsync: availabilityRulesAsync,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PersonalPlanningScreen(
                      jobId: job.id,
                      jobName: job.name,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _CollapsibleSection(
            title: 'Shift patterns',
            subtitle: 'Your rotation setup for this job.',
            icon: Icons.repeat_outlined,
            initiallyExpanded: true,
            action: _SectionActionButton(
              icon: Icons.add_circle_outline,
              label: 'Build pattern',
              onPressed: () =>
                  context.push('${AppRoutes.jobs}/${job.id}/patterns/new'),
            ),
            child: patternsAsync.when(
              data: (patterns) => _PatternSection(job: job, patterns: patterns),
              loading: () =>
                  const _InlineLoadingState(label: 'Loading patterns...'),
              error: (error, _) => _InlineErrorState(
                label: 'Failed to load patterns',
                message: error.toString(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _CollapsibleSection(
            title: 'Shift templates',
            subtitle: 'Reusable shifts for your rota.',
            icon: Icons.schedule_outlined,
            initiallyExpanded: true,
            action: _SectionActionButton(
              icon: Icons.add_alarm_outlined,
              label: 'Add template',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CreateShiftTemplateScreen(jobId: job.id),
                  ),
                );
              },
            ),
            child: templatesAsync.when(
              data: (templates) =>
                  _TemplateSection(job: job, templates: templates),
              loading: () =>
                  const _InlineLoadingState(label: 'Loading templates...'),
              error: (error, _) => _InlineErrorState(
                label: 'Failed to load templates',
                message: error.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanningSummary extends StatelessWidget {
  const _PlanningSummary({
    required this.settingsAsync,
    required this.availabilityRulesAsync,
    required this.onTap,
  });

  final AsyncValue<dynamic> settingsAsync;
  final AsyncValue<dynamic> availabilityRulesAsync;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.brMd,
        child: _SectionSurface(
          child: settingsAsync.when(
            data: (settings) {
              return availabilityRulesAsync.when(
                data: (rules) {
                  final chips = <String>[
                    if ((settings?.minimumRestMinutes ?? 0) > 0)
                      'Rest ${_formatHours(settings.minimumRestMinutes as int)}',
                    if ((settings?.maxConsecutiveWorkDays ?? 0) > 0)
                      'Max ${settings.maxConsecutiveWorkDays} days',
                    if ((settings?.weeklyOvertimeCapMinutes ?? 0) > 0)
                      'Weekly OT ${_formatHours(settings.weeklyOvertimeCapMinutes as int)}',
                    if ((settings?.monthlyOvertimeCapMinutes ?? 0) > 0)
                      'Monthly OT ${_formatHours(settings.monthlyOvertimeCapMinutes as int)}',
                    '${rules.length} unavailable date${rules.length == 1 ? '' : 's'}',
                  ];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            settings?.planningAlertsEnabled == true
                                ? Icons.notifications_active_outlined
                                : Icons.notifications_off_outlined,
                            size: 18,
                            color: settings?.planningAlertsEnabled == true
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  settings == null
                                      ? 'No planning rules saved yet'
                                      : settings.planningAlertsEnabled
                                      ? 'Planning alerts are active'
                                      : 'Planning alerts are turned off',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        settings?.planningAlertsEnabled == true
                                        ? theme.colorScheme.primary
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'View details and update alert settings',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: chips
                            .map((chip) => _InfoChip(label: chip))
                            .toList(growable: false),
                      ),
                    ],
                  );
                },
                loading: () => const _InlineLoadingState(
                  label: 'Loading planning support...',
                ),
                error: (error, _) => _InlineErrorState(
                  label: 'Failed to load planning support',
                  message: error.toString(),
                ),
              );
            },
            loading: () =>
                const _InlineLoadingState(label: 'Loading planning support...'),
            error: (error, _) => _InlineErrorState(
              label: 'Failed to load planning support',
              message: error.toString(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.isExpanded,
    this.icon,
    this.action,
    this.onToggle,
  });

  final String title;
  final String subtitle;
  final bool isExpanded;
  final IconData? icon;
  final Widget? action;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.brSm,
                ),
                child: Icon(icon, size: 18, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: isExpanded ? 'Collapse section' : 'Expand section',
              onPressed: onToggle,
              icon: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        if (action != null) ...[const SizedBox(height: 10), action!],
      ],
    );
  }
}

class _SectionSurface extends StatelessWidget {
  const _SectionSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: AppRadius.brMd,
        color: theme.colorScheme.surfaceContainerLow,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: child,
    );
  }
}

class _SecondaryOutlinedButton extends StatelessWidget {
  const _SecondaryOutlinedButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        iconSize: 18,
        alignment: Alignment.centerLeft,
      ),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _EmptyJobsState extends StatelessWidget {
  const _EmptyJobsState({
    required this.onCreateJob,
    required this.onViewPremium,
  });

  final VoidCallback onCreateJob;
  final VoidCallback onViewPremium;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.work_history_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            AppSpacing.gapLg,
            Text(
              'No jobs yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            AppSpacing.gapSm,
            Text(
              'Add your first job to unlock the calendar, pay estimates, reminders, and exports.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              'You can stay on the basic setup here. Premium is meant for the later moments where pay gets complicated, rota entry gets repetitive, or a payslip needs checking.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.sectionGap,
            FilledButton.icon(
              onPressed: onCreateJob,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Create first job'),
            ),
            AppSpacing.gapSm,
            OutlinedButton.icon(
              onPressed: onViewPremium,
              icon: const Icon(Icons.workspace_premium_outlined),
              label: const Text('View Premium'),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobActions extends ConsumerWidget {
  const _JobActions({required this.job, required this.entitlement});

  final Job job;
  final AppEntitlement entitlement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _SecondaryOutlinedButton(
          onPressed: () {
            context.push(AppRoutes.editJob(job.id));
          },
          icon: Icons.edit_outlined,
          label: 'Edit job',
        ),
        PopupMenuButton<_JobMenuAction>(
          tooltip: 'More actions',
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.more_vert),
          onSelected: (action) => _handleAction(context, ref, action),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: _JobMenuAction.importCsv,
              child: ListTile(
                leading: Icon(Icons.upload_file_outlined),
                title: Text('Import CSV rota'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: _JobMenuAction.advancedPayRules,
              child: ListTile(
                leading: Icon(
                  entitlement.canAccess(AppFeature.advancedPayRules)
                      ? Icons.tune_outlined
                      : Icons.workspace_premium_outlined,
                ),
                title: const Text('Advanced pay rules'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleAction(
    BuildContext context,
    WidgetRef ref,
    _JobMenuAction action,
  ) {
    switch (action) {
      case _JobMenuAction.advancedPayRules:
        if (!entitlement.canAccess(AppFeature.advancedPayRules)) {
          ref
              .read(premiumAnalyticsTrackerProvider)
              .track(
                PremiumAnalyticsEvent.premiumGateEncountered,
                fields: {
                  'screen_name': 'jobs',
                  'entry_point': 'jobs_advanced_rules_menu',
                  'entitlement_state': entitlement.premium ? 'premium' : 'free',
                  'result': AppFeature.advancedPayRules.name,
                },
              );
          context.push(
            AppRoutes.premiumWithContext(
              entryPoint: 'jobs_advanced_rules_menu',
              feature: AppFeature.advancedPayRules.name,
            ),
          );
          return;
        }
        context.push(AppRoutes.advancedPaySettings(job.id));
      case _JobMenuAction.importCsv:
        context.push(AppRoutes.csvImport(job.id));
    }
  }
}

enum _JobMenuAction { advancedPayRules, importCsv }

class _JobsErrorState extends StatelessWidget {
  const _JobsErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 56,
              color: Theme.of(context).colorScheme.error,
            ),
            AppSpacing.gapLg,
            Text(
              'Could not load jobs',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            AppSpacing.gapSm,
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.sectionGap,
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PatternSection extends StatelessWidget {
  const _PatternSection({required this.job, required this.patterns});

  final Job job;
  final List<ShiftPattern> patterns;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (patterns.isEmpty) {
      return _SectionSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No rotating pattern yet',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Build one active pattern for ${job.name} so the calendar and pay screens can generate shifts.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final pattern in patterns)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SectionSurface(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pattern.isActive
                          ? AppColors.success.withValues(alpha: 0.14)
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: Icon(
                      pattern.isActive
                          ? Icons.check_circle_outline
                          : Icons.pause_circle_outline,
                      color: pattern.isActive
                          ? AppColors.success
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                pattern.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _StatusBadge(
                              label: pattern.isActive ? 'Active' : 'Inactive',
                              isPositive: pattern.isActive,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _MetaLine(
                          items: [
                            '${pattern.cycleLengthDays}-day cycle',
                            'Starts: ${_formatDate(pattern.startDate)}',
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _TemplateSection extends StatelessWidget {
  const _TemplateSection({required this.job, required this.templates});

  final Job job;
  final List<ShiftTemplate> templates;

  @override
  Widget build(BuildContext context) {
    if (templates.isEmpty) {
      return _EmptyTemplatesState(jobName: job.name);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final template in templates)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _TemplateListItem(job: job, template: template),
          ),
      ],
    );
  }
}

class _EmptyTemplatesState extends StatelessWidget {
  const _EmptyTemplatesState({required this.jobName});

  final String jobName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No shift templates yet',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Create reusable day, evening, night, or custom shifts for $jobName.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateListItem extends StatelessWidget {
  const _TemplateListItem({required this.job, required this.template});

  final Job job;
  final ShiftTemplate template;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primaryContainer,
                ),
                child: Icon(
                  _categoryIcon(template.category),
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatMinutes(template.startMinutesLocal)} - ${_formatMinutes(template.endMinutesLocal)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit template',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => CreateShiftTemplateScreen(
                        jobId: job.id,
                        initialTemplate: template,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(label: _categoryLabel(template.category)),
              _InfoChip(label: 'Break ${template.unpaidBreakMinutes}m'),
              if (template.crossesMidnight) const _InfoChip(label: 'Overnight'),
            ],
          ),
          if (template.defaultNote?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: 12),
            Text(
              template.defaultNote!.trim(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      items.where((item) => item.trim().isNotEmpty).join(' • '),
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.isPositive});

  final String label;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: isPositive
            ? AppColors.success.withValues(alpha: 0.12)
            : theme.colorScheme.surfaceContainerHighest,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isPositive
              ? AppColors.success
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _InlineLoadingState extends StatelessWidget {
  const _InlineLoadingState({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return _SectionSurface(
      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}

class _InlineErrorState extends StatelessWidget {
  const _InlineErrorState({required this.label, required this.message});

  final String label;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: AppRadius.brMd,
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.75),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsibleSection extends StatefulWidget {
  const _CollapsibleSection({
    required this.title,
    required this.subtitle,
    required this.child,
    this.icon,
    this.action,
    this.initiallyExpanded = false,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final IconData? icon;
  final Widget? action;
  final bool initiallyExpanded;

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: AppRadius.brMd,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _SectionHeader(
              title: widget.title,
              subtitle: widget.subtitle,
              icon: widget.icon,
              action: widget.action,
              isExpanded: _isExpanded,
              onToggle: () => setState(() => _isExpanded = !_isExpanded),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: widget.child,
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }
}

class _SectionActionButton extends StatelessWidget {
  const _SectionActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _SecondaryOutlinedButton(
      onPressed: onPressed,
      icon: icon,
      label: label,
    );
  }
}

String _formatMinutes(int totalMinutes) {
  final hours = (totalMinutes ~/ 60).toString().padLeft(2, '0');
  final minutes = (totalMinutes % 60).toString().padLeft(2, '0');
  return '$hours:$minutes';
}

String _formatDate(DateTime date) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

String _formatHours(int totalMinutes) {
  final hours = totalMinutes / 60;
  final label = hours.toStringAsFixed(1).replaceFirst(RegExp(r'\.0$'), '');
  return '${label}h';
}

String _categoryLabel(ShiftCategory category) {
  final label = category.name;
  return label.substring(0, 1).toUpperCase() + label.substring(1);
}

IconData _categoryIcon(ShiftCategory category) {
  switch (category) {
    case ShiftCategory.day:
      return Icons.wb_sunny_outlined;
    case ShiftCategory.evening:
      return Icons.wb_twilight_outlined;
    case ShiftCategory.night:
      return Icons.nightlight_outlined;
    case ShiftCategory.custom:
      return Icons.tune_outlined;
  }
}

Color _parseHexColor(String hex) {
  final value = hex.replaceFirst('#', '0xFF');
  return Color(int.parse(value));
}
