import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/routing/app_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/cards/app_card.dart';
import '../../../../core/common/shared_types.dart';
import '../../../../core/money/money_formatter.dart';
import '../../../../core/time/date_range_extensions.dart';
import '../../../../domain/entities/app_entitlement.dart';
import '../../../../domain/entities/job.dart';
import '../../../../domain/entities/planning_alert.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../jobs/application/jobs_providers.dart';
import '../../../planning/application/planning_providers.dart';
import '../../../premium/application/entitlement_provider.dart';
import '../../application/pay_providers.dart';

class PayScreen extends ConsumerWidget {
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(jobsProvider);
    final summaryAsync = ref.watch(paySummaryProvider);
    final selectedJobId = ref.watch(payResolvedJobIdProvider);
    final selectedPreset = ref.watch(paySelectedPresetProvider);
    final selectedAnchor = ref.watch(paySelectedAnchorDateProvider);
    final selectedRange = ref.watch(paySelectedRangeProvider);
    final planningAlertsAsync = selectedJobId == null
        ? const AsyncValue<List<PlanningAlert>>.data(<PlanningAlert>[])
        : ref.watch(
            planningAlertsProvider(
              PlanningAlertsQuery(jobId: selectedJobId, range: selectedRange),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.export),
            icon: const Icon(Icons.ios_share_outlined),
            tooltip: 'Open export',
          ),
        ],
      ),
      body: SafeArea(
        child: jobsAsync.when(
          data: (jobs) {
            if (jobs.isEmpty) {
              return const _PayMessageState(
                icon: Icons.payments_outlined,
                title: 'No jobs yet',
                description:
                    'Create your first job to start tracking weekly and monthly pay estimates. Premium only becomes relevant later if you need imports, deeper pay rules, or payslip checks.',
              );
            }

            final selectedJob = jobs.firstWhere(
              (job) => job.id == selectedJobId,
              orElse: () => jobs.first,
            );

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(paySummaryProvider);
                await ref.read(paySummaryProvider.future);
              },
              child: ListView(
                padding: AppSpacing.pagePaddingWithSafeBottom(context, top: 12),
                children: [
                  _PayHero(
                    jobs: jobs,
                    selectedJobId: selectedJob.id,
                    selectedPreset: selectedPreset,
                    rangeLabel: _formatRange(selectedRange),
                    onJobChanged: (jobId) {
                      ref.read(paySelectedJobIdProvider.notifier).state = jobId;
                    },
                    onPresetChanged: (preset) {
                      ref.read(paySelectedPresetProvider.notifier).state =
                          preset;
                    },
                    onPreviousPressed: () {
                      ref
                          .read(paySelectedAnchorDateProvider.notifier)
                          .state = selectedPreset == DateRangePreset.week
                          ? selectedAnchor
                                .subtract(const Duration(days: 7))
                                .startOfDay
                          : DateTime(
                              selectedAnchor.year,
                              selectedAnchor.month - 1,
                              1,
                            );
                    },
                    onNextPressed: () {
                      ref
                          .read(paySelectedAnchorDateProvider.notifier)
                          .state = selectedPreset == DateRangePreset.week
                          ? selectedAnchor
                                .add(const Duration(days: 7))
                                .startOfDay
                          : DateTime(
                              selectedAnchor.year,
                              selectedAnchor.month + 1,
                              1,
                            );
                    },
                    onTodayPressed: () {
                      ref.read(paySelectedAnchorDateProvider.notifier).state =
                          DateTime.now().startOfDay;
                    },
                  ),
                  const SizedBox(height: 16),
                  summaryAsync.when(
                    data: (summary) {
                      if (summary == null) {
                        return const _PayMessageState(
                          icon: Icons.calendar_today_outlined,
                          title: 'No period selected',
                          description:
                              'Choose a job and pay period to load an estimate.',
                        );
                      }

                      final accent = _parseHexColor(selectedJob.colorHex);
                      final hasWorkedShifts = summary.totalShifts > 0;

                      if (!hasWorkedShifts) {
                        return _PayMessageState(
                          icon: Icons.event_busy_outlined,
                          title: 'No shifts in this period',
                          description:
                              'There are no worked shifts in ${summary.periodLabel} yet. Add shifts or review another period to see an estimate. Premium comes in later when you need imports, more accurate rules, or payslip checks.',
                        );
                      }

                      return Column(
                        children: [
                          _PayTotalCard(summary: summary, accent: accent),
                          const SizedBox(height: 16),
                          planningAlertsAsync.when(
                            data: (alerts) {
                              final relevantAlerts = alerts
                                  .where(_isPayRelevantPlanningAlert)
                                  .toList(growable: false);
                              if (relevantAlerts.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _PlanningPayCard(alerts: relevantAlerts),
                              );
                            },
                            loading: () => const SizedBox.shrink(),
                            error: (error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                          _PayStatGrid(summary: summary, accent: accent),
                          const SizedBox(height: 16),
                          _PayBreakdownCard(summary: summary, accent: accent),
                          const SizedBox(height: 16),
                          _PayToolsCard(
                            jobId: selectedJob.id,
                            anchorDate: selectedAnchor,
                          ),
                          const SizedBox(height: 16),
                          _PayVerificationCard(
                            summary: summary,
                            jobId: selectedJob.id,
                          ),
                        ],
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stackTrace) => _PayMessageState(
                      icon: Icons.error_outline,
                      title: 'Unable to calculate pay',
                      description: error.toString(),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _PayMessageState(
            icon: Icons.error_outline,
            title: 'Unable to load jobs',
            description: error.toString(),
          ),
        ),
      ),
    );
  }
}

class _PlanningPayCard extends StatelessWidget {
  const _PlanningPayCard({required this.alerts});

  final List<PlanningAlert> alerts;

  @override
  Widget build(BuildContext context) {
    final topAlerts = alerts.take(2).toList(growable: false);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Planning watch-outs',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Worker-side planning warnings only.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          ...topAlerts.map(
            (alert) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (alerts.length > topAlerts.length)
            Text(
              '+ ${alerts.length - topAlerts.length} more warning(s) in this period',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}

class _PayHero extends StatelessWidget {
  const _PayHero({
    required this.jobs,
    required this.selectedJobId,
    required this.selectedPreset,
    required this.rangeLabel,
    required this.onJobChanged,
    required this.onPresetChanged,
    required this.onPreviousPressed,
    required this.onNextPressed,
    required this.onTodayPressed,
  });

  final List<Job> jobs;
  final String selectedJobId;
  final DateRangePreset selectedPreset;
  final String rangeLabel;
  final ValueChanged<String> onJobChanged;
  final ValueChanged<DateRangePreset> onPresetChanged;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;
  final VoidCallback onTodayPressed;

  @override
  Widget build(BuildContext context) {
    final selectedJob = jobs.firstWhere((job) => job.id == selectedJobId);
    final accent = _parseHexColor(selectedJob.colorHex);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  selectedJob.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              OutlinedButton.icon(
                onPressed: onTodayPressed,
                icon: const Icon(Icons.today_outlined),
                label: const Text('Today'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            rangeLabel,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<String>(
                  initialValue: selectedJobId,
                  decoration: const InputDecoration(
                    labelText: 'Job',
                    border: OutlineInputBorder(),
                  ),
                  items: jobs
                      .map(
                        (job) => DropdownMenuItem<String>(
                          value: job.id,
                          child: Text(job.name),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) {
                      onJobChanged(value);
                    }
                  },
                ),
              ),
              SegmentedButton<DateRangePreset>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: DateRangePreset.week,
                    label: Text('Week'),
                    icon: Icon(Icons.view_week_outlined),
                  ),
                  ButtonSegment(
                    value: DateRangePreset.month,
                    label: Text('Month'),
                    icon: Icon(Icons.calendar_view_month_outlined),
                  ),
                ],
                selected: {selectedPreset},
                onSelectionChanged: (selection) =>
                    onPresetChanged(selection.first),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onPreviousPressed,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  IconButton(
                    onPressed: onNextPressed,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PayTotalCard extends StatelessWidget {
  const _PayTotalCard({required this.summary, required this.accent});

  final PayPeriodSummary summary;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Projected pay', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(
            MoneyFormatter.formatMinorUnits(
              summary.grossPay,
              currencyCode: summary.currencyCode,
            ),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Calculated from ${summary.totalShifts} shifts in ${summary.periodLabel}.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayStatGrid extends StatelessWidget {
  const _PayStatGrid({required this.summary, required this.accent});

  final PayPeriodSummary summary;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PayStatCard(
            icon: Icons.schedule_outlined,
            label: 'Worked time',
            value: _formatMinutes(summary.totalWorkedMinutes),
            color: accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PayStatCard(
            icon: Icons.celebration_outlined,
            label: 'Holiday shifts',
            value: '${summary.holidayShifts}',
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _PayStatCard extends StatelessWidget {
  const _PayStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _PayBreakdownCard extends StatelessWidget {
  const _PayBreakdownCard({required this.summary, required this.accent});

  final PayPeriodSummary summary;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Breakdown', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ...summary.breakdownItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PayBreakdownRow(
                item: item,
                currencyCode: summary.currencyCode,
                accent: _breakdownColor(item.type, accent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PayBreakdownRow extends StatelessWidget {
  const _PayBreakdownRow({
    required this.item,
    required this.currencyCode,
    required this.accent,
  });

  final PaySummaryBreakdownItem item;
  final String currencyCode;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final detail =
        item.type == PaySummaryBreakdownType.doubleTime && item.minutes == 0
        ? 'Enabled, but no double-time minutes were triggered in this period.'
        : _formatMinutes(item.minutes);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            MoneyFormatter.formatMinorUnits(
              item.amount,
              currencyCode: currencyCode,
            ),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayVerificationCard extends StatelessWidget {
  const _PayVerificationCard({required this.summary, required this.jobId});

  final PayPeriodSummary summary;
  final String jobId;

  @override
  Widget build(BuildContext context) {
    final startLabel = DateFormat('EEE, d MMM').format(summary.range.start);
    final endLabel = DateFormat('EEE, d MMM yyyy').format(summary.range.end);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compare with a payslip',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Enter what your payslip says for this period and ShiftMate will compare it with your expected pay estimate using discrepancy hints and confidence notes.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Text('Selected period: $startLabel to $endLabel'),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: FilledButton.icon(
              onPressed: () => context.push(
                AppRoutes.payVerificationRoute(
                  jobId: jobId,
                  start: summary.range.start,
                  end: summary.range.end,
                ),
              ),
              icon: const Icon(Icons.receipt_long_outlined),
              label: const Text('Compare with payslip'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PayToolsCard extends ConsumerWidget {
  const _PayToolsCard({required this.jobId, required this.anchorDate});

  final String jobId;
  final DateTime anchorDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitlement = ref.watch(entitlementProvider);
    final forecastUnlocked = entitlement.canAccess(AppFeature.forecasting);
    final advancedRulesUnlocked = entitlement.canAccess(
      AppFeature.advancedPayRules,
    );
    final hasLockedPremiumTools = !forecastUnlocked || !advancedRulesUnlocked;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pay tools', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Keep the next step close to the estimate you are reviewing now, whether that means planning ahead or tightening pay accuracy.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          _PayToolListTile(
            icon: Icons.insights_outlined,
            title: 'Forecast income',
            description:
                'Use a rolling 30, 60, or 90 day forecast to see how much future income is already scheduled and how confident that total looks.',
            actionLabel: forecastUnlocked ? 'Open forecast' : null,
            showPremiumBadge: !forecastUnlocked,
            onPressed: forecastUnlocked
                ? () => context.push(
                    AppRoutes.forecastRoute(jobId: jobId, anchor: anchorDate),
                  )
                : null,
          ),
          const SizedBox(height: 12),
          _PayToolListTile(
            icon: Icons.tune_outlined,
            title: 'Advanced pay rules',
            description:
                'Model night premiums, weekend uplifts, allowances, and smarter break assumptions when basic hourly setup stops matching real payslips.',
            actionLabel: advancedRulesUnlocked ? 'Review rules' : null,
            showPremiumBadge: !advancedRulesUnlocked,
            onPressed: advancedRulesUnlocked
                ? () => context.push(AppRoutes.advancedPaySettings(jobId))
                : null,
          ),
          if (hasLockedPremiumTools) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: FilledButton.icon(
                onPressed: () => context.push(
                  AppRoutes.premiumWithContext(
                    entryPoint: 'pay_tools_card',
                    feature: forecastUnlocked
                        ? 'advancedPayRules'
                        : advancedRulesUnlocked
                        ? 'forecasting'
                        : 'advancedPayRules',
                  ),
                ),
                icon: const Icon(Icons.workspace_premium_outlined),
                label: const Text('See Premium tools'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PayToolListTile extends StatelessWidget {
  const _PayToolListTile({
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.showPremiumBadge = false,
    this.onPressed,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final bool showPremiumBadge;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    if (showPremiumBadge) const _PremiumBadge(),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(width: 12),
            OutlinedButton(onPressed: onPressed, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium_outlined, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            'Premium',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayMessageState extends StatelessWidget {
  const _PayMessageState({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _breakdownColor(PaySummaryBreakdownType type, Color fallback) {
  return switch (type) {
    PaySummaryBreakdownType.base => fallback,
    PaySummaryBreakdownType.overtime => AppColors.warning,
    PaySummaryBreakdownType.doubleTime => Colors.deepOrange,
    PaySummaryBreakdownType.holiday => AppColors.success,
  };
}

bool _isPayRelevantPlanningAlert(PlanningAlert alert) {
  return switch (alert.type) {
    PlanningAlertType.restGapRisk ||
    PlanningAlertType.weeklyOvertimeCapRisk ||
    PlanningAlertType.monthlyOvertimeCapRisk => true,
    PlanningAlertType.overlapConflict ||
    PlanningAlertType.availabilityConflict ||
    PlanningAlertType.availabilityPreference ||
    PlanningAlertType.consecutiveDaysRisk => false,
  };
}

String _formatMinutes(int totalMinutes) {
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  if (hours == 0) {
    return '${minutes}m';
  }
  if (minutes == 0) {
    return '${hours}h';
  }
  return '${hours}h ${minutes}m';
}

String _formatRange(dynamic range) {
  final sameMonth =
      range.start.month == range.end.month &&
      range.start.year == range.end.year;
  final sameYear = range.start.year == range.end.year;

  if (sameMonth) {
    return '${DateFormat('d').format(range.start)}-${DateFormat('d MMMM yyyy').format(range.end)}';
  }
  if (sameYear) {
    return '${DateFormat('d MMM').format(range.start)} - ${DateFormat('d MMM yyyy').format(range.end)}';
  }
  return '${DateFormat('d MMM yyyy').format(range.start)} - ${DateFormat('d MMM yyyy').format(range.end)}';
}

Color _parseHexColor(String hex) {
  final sanitized = hex.replaceFirst('#', '');
  final value = sanitized.length == 6 ? 'FF$sanitized' : sanitized;
  return Color(int.parse(value, radix: 16));
}
