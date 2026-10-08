import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/cards/app_card.dart';
import '../../../../app/widgets/feature_gate.dart';
import '../../../../core/money/money_formatter.dart';
import '../../../../core/time/app_date_range.dart';
import '../../../../domain/entities/app_entitlement.dart';
import '../../../../domain/entities/income_forecast.dart';
import '../../../../domain/entities/job.dart';
import '../../../jobs/application/jobs_providers.dart';
import '../../../premium/application/entitlement_provider.dart';
import '../../application/forecast_providers.dart';

class ForecastScreen extends ConsumerStatefulWidget {
  const ForecastScreen({
    required this.initialJobId,
    required this.initialAnchorDate,
    super.key,
  });

  final String initialJobId;
  final DateTime initialAnchorDate;

  @override
  ConsumerState<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends ConsumerState<ForecastScreen> {
  late String _selectedJobId = widget.initialJobId;
  late DateTime _anchorDate = DateTime(
    widget.initialAnchorDate.year,
    widget.initialAnchorDate.month,
    widget.initialAnchorDate.day,
  );
  ForecastWindowPreset _windowPreset = ForecastWindowPreset.days30;

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(jobsProvider);
    final args = ForecastRouteArgs(
      jobId: _selectedJobId,
      anchorDate: _anchorDate,
      windowPreset: _windowPreset,
    );
    final forecastAsync = ref.watch(forecastViewProvider(args));
    final entitlement = ref.watch(entitlementProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Forecast')),
      body: SafeArea(
        child: jobsAsync.when(
          data: (jobs) {
            if (jobs.isEmpty) {
              return const _ForecastMessageState(
                icon: Icons.timeline_outlined,
                title: 'No jobs yet',
                description:
                    'Create a job before using income forecasting and planning tools.',
              );
            }

            if (!jobs.any((job) => job.id == _selectedJobId)) {
              _selectedJobId = jobs.first.id;
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(forecastViewProvider(args));
                await ref.read(forecastViewProvider(args).future);
              },
              child: ListView(
                padding: AppSpacing.pagePaddingWithSafeBottom(context, top: 12),
                children: [
                  _ForecastHero(
                    jobs: jobs,
                    selectedJobId: _selectedJobId,
                    selectedPreset: _windowPreset,
                    rangeLabel: _formatRange(args.range),
                    onJobChanged: (jobId) {
                      setState(() {
                        _selectedJobId = jobId;
                      });
                    },
                    onPresetChanged: (preset) {
                      setState(() {
                        _windowPreset = preset;
                      });
                    },
                    onPreviousPressed: () {
                      setState(() {
                        _anchorDate = _anchorDate.subtract(
                          Duration(days: _daysForPreset(_windowPreset)),
                        );
                      });
                    },
                    onNextPressed: () {
                      setState(() {
                        _anchorDate = _anchorDate.add(
                          Duration(days: _daysForPreset(_windowPreset)),
                        );
                      });
                    },
                    onTodayPressed: () {
                      setState(() {
                        _anchorDate = DateTime.now();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  forecastAsync.when(
                    data: (viewData) => _ForecastBody(
                      viewData: viewData,
                      entitlement: entitlement,
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stackTrace) => _ForecastMessageState(
                      icon: Icons.error_outline,
                      title: 'Unable to load forecast',
                      description: error.toString(),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _ForecastMessageState(
            icon: Icons.error_outline,
            title: 'Unable to load jobs',
            description: error.toString(),
          ),
        ),
      ),
    );
  }
}

class _ForecastHero extends StatelessWidget {
  const _ForecastHero({
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
  final ForecastWindowPreset selectedPreset;
  final String rangeLabel;
  final ValueChanged<String> onJobChanged;
  final ValueChanged<ForecastWindowPreset> onPresetChanged;
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
                  isExpanded: true,
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
              SegmentedButton<ForecastWindowPreset>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: ForecastWindowPreset.days30,
                    label: Text('30d'),
                    icon: Icon(Icons.timeline_outlined),
                  ),
                  ButtonSegment(
                    value: ForecastWindowPreset.days60,
                    label: Text('60d'),
                    icon: Icon(Icons.timeline_outlined),
                  ),
                  ButtonSegment(
                    value: ForecastWindowPreset.days90,
                    label: Text('90d'),
                    icon: Icon(Icons.timeline_outlined),
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

class _ForecastBody extends StatelessWidget {
  const _ForecastBody({required this.viewData, required this.entitlement});

  final ForecastViewData viewData;
  final AppEntitlement entitlement;

  @override
  Widget build(BuildContext context) {
    final summary = viewData.summary;
    final hasCoverage = summary.coverage.daysCovered > 0;
    final paceEstimate = _paceEstimate(summary);

    if (!hasCoverage) {
      return AppCard(
        child: Column(
          children: [
            const Icon(Icons.insights_outlined, size: 40),
            const SizedBox(height: 12),
            Text(
              'No future shifts in this window',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'There are no scheduled future shifts yet for this forecast range. Add future shifts or import a rota to improve the forecast.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Once this window has some future coverage, ShiftMate can show whether the total looks solid or still needs more rota detail.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _ForecastTotalCard(summary: summary),
        const SizedBox(height: 16),
        _ForecastCoverageGrid(summary: summary),
        const SizedBox(height: 16),
        if (summary.coverage.uncoveredDayCount > 0 && paceEstimate != null) ...[
          _ForecastScenarioCard(
            summary: summary,
            paceEstimateMinor: paceEstimate,
          ),
          const SizedBox(height: 16),
        ],
        if (summary.confidenceWarnings.isNotEmpty) ...[
          _ForecastWarningsCard(summary: summary),
          const SizedBox(height: 16),
        ],
        if (entitlement.canAccess(AppFeature.forecasting)) ...[
          _ExtraShiftSimulationCard(
            key: ValueKey(
              '${viewData.job.id}:${summary.range.start.toIso8601String()}:${summary.range.end.toIso8601String()}',
            ),
            jobId: viewData.job.id,
            range: summary.range,
          ),
          const SizedBox(height: 16),
          _ForecastTargetCard(summary: summary),
          const SizedBox(height: 16),
          _ForecastNudgesCard(summary: summary),
        ] else
          const PremiumTeaserCard(
            title: 'Unlock full forecast insights',
            description:
                'You are already looking at a real future-income forecast. Premium adds the planning layer once there is actual coverage to review.',
            ctaLabel: 'See Premium forecast tools',
            entryPoint: 'pay_forecast_insight',
            feature: 'forecasting',
            features: [
              'Track earnings and overtime targets with calm nudges.',
              'Switch between 30, 60, and 90 day planning views.',
              'Preview one extra shift before you commit anything to the rota.',
              'Keep coverage and confidence tied to real saved schedules.',
            ],
          ),
      ],
    );
  }

  int? _paceEstimate(IncomeForecastSummary summary) {
    if (summary.coverage.daysCovered == 0 ||
        summary.coverage.daysCovered >= summary.coverage.daysTotal) {
      return null;
    }
    final averagePerCoveredDay =
        summary.projectedGrossPayMinor / summary.coverage.daysCovered;
    return (averagePerCoveredDay * summary.coverage.daysTotal).round();
  }
}

class _ExtraShiftSimulationCard extends ConsumerStatefulWidget {
  const _ExtraShiftSimulationCard({
    required this.jobId,
    required this.range,
    super.key,
  });

  final String jobId;
  final AppDateRange range;

  @override
  ConsumerState<_ExtraShiftSimulationCard> createState() =>
      _ExtraShiftSimulationCardState();
}

class _ExtraShiftSimulationCardState
    extends ConsumerState<_ExtraShiftSimulationCard> {
  String? _selectedTemplateId;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(forecastTemplatesProvider(widget.jobId));

    return templatesAsync.when(
      data: (templates) {
        if (templates.isEmpty) {
          return AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Extra-shift simulation',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create at least one shift template for this job before previewing what an extra shift could add to this forecast.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        final dates = _datesInRange(widget.range);
        _selectedTemplateId ??= templates.first.id;
        _selectedDate ??= dates.first;

        final simulationArgs = ForecastSimulationArgs(
          jobId: widget.jobId,
          range: widget.range,
          templateId: _selectedTemplateId!,
          simulatedDate: _selectedDate!,
        );
        final simulationAsync = ref.watch(
          forecastSimulationProvider(simulationArgs),
        );

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Extra-shift simulation',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Preview one saved shift template inside this forecast window without saving anything.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 220,
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedTemplateId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Shift template',
                        border: OutlineInputBorder(),
                      ),
                      items: templates
                          .map(
                            (template) => DropdownMenuItem<String>(
                              value: template.id,
                              child: Text(template.name),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedTemplateId = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: DropdownButtonFormField<DateTime>(
                      initialValue: _selectedDate,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Preview on',
                        border: OutlineInputBorder(),
                      ),
                      items: dates
                          .map(
                            (date) => DropdownMenuItem<DateTime>(
                              value: date,
                              child: Text(_formatSimulationDate(date)),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedDate = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              simulationAsync.when(
                data: (simulation) =>
                    _ExtraShiftSimulationResult(simulation: simulation),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stackTrace) => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(error.toString()),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Extra-shift simulation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      error: (error, stackTrace) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Extra-shift simulation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(error.toString()),
          ],
        ),
      ),
    );
  }
}

class _ExtraShiftSimulationResult extends StatelessWidget {
  const _ExtraShiftSimulationResult({required this.simulation});

  final ForecastShiftSimulationResult simulation;

  @override
  Widget build(BuildContext context) {
    final triggerLabels = simulation.triggeredChanges
        .map(_triggerLabel)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _ForecastValueColumn(
                label: 'Added pay',
                value: _formatDeltaMoney(
                  simulation.additionalGrossPayMinor,
                  simulation.currencyCode,
                ),
                color: AppColors.success,
              ),
            ),
            Expanded(
              child: _ForecastValueColumn(
                label: 'Updated total',
                value: MoneyFormatter.formatMinorUnits(
                  simulation.updatedGrossPayMinor,
                  currencyCode: simulation.currencyCode,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ForecastChip(
              label:
                  '${simulation.updatedCoverage.daysCovered} of ${simulation.updatedCoverage.daysTotal} days covered',
            ),
            _ForecastChip(
              label: _formatMinutes(simulation.additionalWorkedMinutes),
              color: AppColors.info,
            ),
            for (final label in triggerLabels)
              _ForecastChip(label: label, color: AppColors.warning),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _SimulationBreakdownLine(
                label: 'Base',
                amountMinor: simulation.additionalBasePayMinor,
                currencyCode: simulation.currencyCode,
              ),
            ),
            Expanded(
              child: _SimulationBreakdownLine(
                label: 'Overtime',
                amountMinor: simulation.additionalOvertimePayMinor,
                currencyCode: simulation.currencyCode,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _SimulationBreakdownLine(
                label: 'Differentials',
                amountMinor: simulation.additionalDifferentialPayMinor,
                currencyCode: simulation.currencyCode,
              ),
            ),
            Expanded(
              child: _SimulationBreakdownLine(
                label: 'Allowances',
                amountMinor: simulation.additionalAllowancePayMinor,
                currencyCode: simulation.currencyCode,
              ),
            ),
          ],
        ),
        if (simulation.goalStatusBefore != null ||
            simulation.overtimeStatusBefore != null) ...[
          const SizedBox(height: 16),
          if (simulation.goalStatusBefore != null &&
              simulation.goalStatusAfter != null)
            _SimulationStatusLine(
              label: 'Goal status',
              before: simulation.goalStatusBefore!.name,
              after: simulation.goalStatusAfter!.name,
            ),
          if (simulation.goalStatusBefore != null &&
              simulation.overtimeStatusBefore != null)
            const SizedBox(height: 8),
          if (simulation.overtimeStatusBefore != null &&
              simulation.overtimeStatusAfter != null)
            _SimulationStatusLine(
              label: 'Overtime status',
              before: simulation.overtimeStatusBefore!.name,
              after: simulation.overtimeStatusAfter!.name,
            ),
        ],
        const SizedBox(height: 16),
        Text(
          'Advisory only: this preview does not save the shift or guarantee it will be worked.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SimulationBreakdownLine extends StatelessWidget {
  const _SimulationBreakdownLine({
    required this.label,
    required this.amountMinor,
    required this.currencyCode,
  });

  final String label;
  final int amountMinor;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(
          _formatDeltaMoney(amountMinor, currencyCode),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}

class _SimulationStatusLine extends StatelessWidget {
  const _SimulationStatusLine({
    required this.label,
    required this.before,
    required this.after,
  });

  final String label;
  final String before;
  final String after;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
        Text(
          '${_displayStatus(before)} -> ${_displayStatus(after)}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _ForecastTotalCard extends StatelessWidget {
  const _ForecastTotalCard({required this.summary});

  final IncomeForecastSummary summary;

  @override
  Widget build(BuildContext context) {
    final confidenceColor = switch (summary.confidence) {
      ForecastConfidenceLevel.high => AppColors.success,
      ForecastConfidenceLevel.medium => AppColors.warning,
      ForecastConfidenceLevel.low => Colors.deepOrange,
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current schedule forecast',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Text(
            MoneyFormatter.formatMinorUnits(
              summary.projectedGrossPayMinor,
              currencyCode: summary.currencyCode,
            ),
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ForecastChip(
                label:
                    '${summary.coverage.daysCovered} of ${summary.coverage.daysTotal} days covered',
              ),
              _ForecastChip(
                label: 'Confidence: ${summary.confidence.name}',
                color: confidenceColor,
              ),
              _ForecastChip(label: '${summary.projectedShiftCount} shifts'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ForecastCoverageGrid extends StatelessWidget {
  const _ForecastCoverageGrid({required this.summary});

  final IncomeForecastSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ForecastStatCard(
            icon: Icons.schedule_outlined,
            label: 'Worked time',
            value: _formatMinutes(summary.projectedWorkedMinutes),
            color: AppColors.info,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ForecastStatCard(
            icon: Icons.percent_outlined,
            label: 'Coverage',
            value: '${(summary.coverage.coverageRatio * 100).round()}%',
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _ForecastStatCard extends StatelessWidget {
  const _ForecastStatCard({
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

class _ForecastScenarioCard extends StatelessWidget {
  const _ForecastScenarioCard({
    required this.summary,
    required this.paceEstimateMinor,
  });

  final IncomeForecastSummary summary;
  final int paceEstimateMinor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Best-case pace scenario',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Current scheduled total uses only saved shifts. This pace scenario shows what the window could look like if uncovered days matched your current covered-day pace.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ForecastValueColumn(
                  label: 'Current schedule',
                  value: MoneyFormatter.formatMinorUnits(
                    summary.projectedGrossPayMinor,
                    currencyCode: summary.currencyCode,
                  ),
                ),
              ),
              Expanded(
                child: _ForecastValueColumn(
                  label: 'Pace scenario',
                  value: MoneyFormatter.formatMinorUnits(
                    paceEstimateMinor,
                    currencyCode: summary.currencyCode,
                  ),
                  color: AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ForecastWarningsCard extends StatelessWidget {
  const _ForecastWarningsCard({required this.summary});

  final IncomeForecastSummary summary;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confidence notes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          for (final warning in summary.confidenceWarnings) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(warning)),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ForecastTargetCard extends StatelessWidget {
  const _ForecastTargetCard({required this.summary});

  final IncomeForecastSummary summary;

  @override
  Widget build(BuildContext context) {
    if (summary.goalProgress == null && summary.overtimeProgress == null) {
      return AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Planning targets',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Target tracking is ready for earnings and overtime goals when those values are provided later in the flow.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Planning targets',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (summary.goalProgress != null)
            _TargetRow(
              label: 'Earnings goal',
              status: summary.goalProgress!.status.name,
              detail:
                  '${(summary.goalProgress!.progressBps / 100).toStringAsFixed(0)}% of goal',
            ),
          if (summary.overtimeProgress != null) ...[
            const SizedBox(height: 10),
            _TargetRow(
              label: 'Overtime target',
              status: summary.overtimeProgress!.status.name,
              detail:
                  '${(summary.overtimeProgress!.progressBps / 100).toStringAsFixed(0)}% of target',
            ),
          ],
        ],
      ),
    );
  }
}

class _TargetRow extends StatelessWidget {
  const _TargetRow({
    required this.label,
    required this.status,
    required this.detail,
  });

  final String label;
  final String status;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                detail,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        _ForecastChip(label: status),
      ],
    );
  }
}

class _ForecastNudgesCard extends StatelessWidget {
  const _ForecastNudgesCard({required this.summary});

  final IncomeForecastSummary summary;

  @override
  Widget build(BuildContext context) {
    if (summary.nudges.isEmpty) {
      return AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Planning nudges',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'No target nudges are active for this forecast yet.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Planning nudges',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          for (final nudge in summary.nudges) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    (nudge.severity == ForecastNudgeSeverity.warning
                            ? AppColors.warning
                            : AppColors.info)
                        .withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(nudge.message),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _ForecastMessageState extends StatelessWidget {
  const _ForecastMessageState({
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

class _ForecastValueColumn extends StatelessWidget {
  const _ForecastValueColumn({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ForecastChip extends StatelessWidget {
  const _ForecastChip({required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: (color ?? Theme.of(context).colorScheme.surfaceContainerHighest)
            .withValues(alpha: 0.14),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

int _daysForPreset(ForecastWindowPreset preset) {
  return switch (preset) {
    ForecastWindowPreset.days30 => 30,
    ForecastWindowPreset.days60 => 60,
    ForecastWindowPreset.days90 => 90,
  };
}

String _formatRange(AppDateRange range) {
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

Color _parseHexColor(String hex) {
  final sanitized = hex.replaceFirst('#', '');
  final value = sanitized.length == 6 ? 'FF$sanitized' : sanitized;
  return Color(int.parse(value, radix: 16));
}

List<DateTime> _datesInRange(AppDateRange range) {
  final dates = <DateTime>[];
  for (
    var date = DateTime(range.start.year, range.start.month, range.start.day);
    !date.isAfter(range.end);
    date = date.add(const Duration(days: 1))
  ) {
    dates.add(date);
  }
  return dates;
}

String _formatSimulationDate(DateTime date) {
  return DateFormat('EEE, d MMM').format(date);
}

String _triggerLabel(ForecastShiftSimulationTrigger trigger) {
  return switch (trigger) {
    ForecastShiftSimulationTrigger.overtime => 'Overtime changes',
    ForecastShiftSimulationTrigger.differential => 'Differentials change',
    ForecastShiftSimulationTrigger.allowance => 'Allowance applied',
  };
}

String _displayStatus(String status) {
  return switch (status) {
    'onTrack' => 'On track',
    'atRisk' => 'At risk',
    'offTrack' => 'Off track',
    'notEnoughData' => 'Not enough data',
    _ => status,
  };
}

String _formatDeltaMoney(int minorUnits, String currencyCode) {
  final formatted = MoneyFormatter.formatMinorUnits(
    minorUnits.abs(),
    currencyCode: currencyCode,
  );
  if (minorUnits > 0) {
    return '+$formatted';
  }
  if (minorUnits < 0) {
    return '-$formatted';
  }
  return formatted;
}
