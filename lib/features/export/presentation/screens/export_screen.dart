import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/widgets/cards/app_card.dart';
import '../../../../app/widgets/feature_gate.dart';
import '../../../../core/common/shared_types.dart';
import '../../../../core/money/money_formatter.dart';
import '../../../../domain/entities/app_entitlement.dart';
import '../../../../domain/entities/job.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../jobs/application/jobs_providers.dart';
import '../../application/backup_restore_service.dart';
import '../../application/export_models.dart';
import '../../application/export_providers.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  bool _isExportingPdf = false;
  bool _isExportingCalendar = false;
  bool _isExportingBackup = false;
  bool _isRestoring = false;
  String? _statusMessage;

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(jobsProvider);
    final bundleAsync = ref.watch(scheduleExportBundleProvider);
    final summaryAsync = ref.watch(exportPaySummaryProvider);
    final selectedJobId = ref.watch(exportResolvedJobIdProvider);
    final selectedPreset = ref.watch(exportSelectedPresetProvider);
    final selectedAnchor = ref.watch(exportSelectedAnchorDateProvider);
    final selectedRange = ref.watch(exportSelectedRangeProvider);
    final history = ref.watch(exportHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Export & backup')),
      body: SafeArea(
        child: jobsAsync.when(
          data: (jobs) {
            if (jobs.isEmpty) {
              return const _ExportMessageState(
                icon: Icons.ios_share_outlined,
                title: 'No jobs available',
                description:
                    'Create your first job before exporting schedules or backups.',
              );
            }

            final selectedJob = jobs.firstWhere(
              (job) => job.id == selectedJobId,
              orElse: () => jobs.first,
            );

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(scheduleExportBundleProvider);
                ref.invalidate(exportPaySummaryProvider);
                await Future.wait([
                  ref.read(scheduleExportBundleProvider.future),
                  ref.read(exportPaySummaryProvider.future),
                ]);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  _ExportHero(
                    jobs: jobs,
                    selectedJobId: selectedJob.id,
                    selectedPreset: selectedPreset,
                    rangeLabel: _formatRange(selectedRange),
                    onJobChanged: (jobId) {
                      ref.read(exportSelectedJobIdProvider.notifier).state =
                          jobId;
                    },
                    onPresetChanged: (preset) {
                      ref.read(exportSelectedPresetProvider.notifier).state =
                          preset;
                    },
                    onPreviousPressed: () {
                      ref
                          .read(exportSelectedAnchorDateProvider.notifier)
                          .state = selectedPreset == DateRangePreset.week
                          ? selectedAnchor.subtract(const Duration(days: 7))
                          : DateTime(
                              selectedAnchor.year,
                              selectedAnchor.month - 1,
                              1,
                            );
                    },
                    onNextPressed: () {
                      ref
                          .read(exportSelectedAnchorDateProvider.notifier)
                          .state = selectedPreset == DateRangePreset.week
                          ? selectedAnchor.add(const Duration(days: 7))
                          : DateTime(
                              selectedAnchor.year,
                              selectedAnchor.month + 1,
                              1,
                            );
                    },
                    onTodayPressed: () {
                      ref
                              .read(exportSelectedAnchorDateProvider.notifier)
                              .state =
                          DateTime.now();
                    },
                  ),
                  const SizedBox(height: 16),
                  summaryAsync.when(
                    data: (summary) {
                      return bundleAsync.when(
                        data: (bundle) {
                          if (bundle == null || summary == null) {
                            return const _ExportMessageState(
                              icon: Icons.calendar_today_outlined,
                              title: 'Nothing to export',
                              description:
                                  'Choose a job and date range to prepare your export files.',
                            );
                          }

                          final document = buildScheduleExportDocument(
                            bundle: bundle,
                            summary: summary,
                          );

                          return Column(
                            children: [
                              _ExportSummaryCard(summary: summary),
                              const SizedBox(height: 16),
                              _ExportActionsCard(
                                statusMessage: _statusMessage,
                                isExportingPdf: _isExportingPdf,
                                isExportingCalendar: _isExportingCalendar,
                                isExportingBackup: _isExportingBackup,
                                onExportCalendar: () =>
                                    _handleCalendarExport(bundle),
                                onExportPdf: () => _handlePdfExport(document),
                                onExportBackup: () =>
                                    _handleBackupExport(bundle, summary),
                              ),
                              const SizedBox(height: 16),
                              _RestoreBackupCard(
                                isRestoring: _isRestoring,
                                onRestore: _handleRestoreBackup,
                              ),
                              const SizedBox(height: 16),
                              _ExportPreviewCard(document: document),
                              const SizedBox(height: 16),
                              _ExportHistoryCard(history: history),
                            ],
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (error, stackTrace) => _ExportMessageState(
                          icon: Icons.error_outline,
                          title: 'Unable to prepare export data',
                          description: error.toString(),
                        ),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stackTrace) => _ExportMessageState(
                      icon: Icons.error_outline,
                      title: 'Unable to prepare pay summary',
                      description: error.toString(),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _ExportMessageState(
            icon: Icons.error_outline,
            title: 'Unable to load jobs',
            description: error.toString(),
          ),
        ),
      ),
    );
  }

  Future<void> _handlePdfExport(ScheduleExportDocument document) async {
    setState(() {
      _isExportingPdf = true;
      _statusMessage = null;
    });

    try {
      final artifact = await ref
          .read(exportFileServiceProvider)
          .writeSchedulePdf(document: document);
      ref.invalidate(exportHistoryProvider);
      setState(() {
        _statusMessage = 'PDF saved to ${artifact.filePath}';
      });
    } catch (error) {
      setState(() {
        _statusMessage = 'PDF export failed: $error';
      });
    } finally {
      if (mounted) {
        setState(() => _isExportingPdf = false);
      }
    }
  }

  Future<void> _handleCalendarExport(ScheduleExportBundle bundle) async {
    setState(() {
      _isExportingCalendar = true;
      _statusMessage = null;
    });

    try {
      final artifact = await ref
          .read(exportFileServiceProvider)
          .writeCalendarIcs(bundle: bundle);
      ref.invalidate(exportHistoryProvider);
      setState(() {
        _statusMessage = 'Calendar file refreshed at ${artifact.filePath}';
      });
    } catch (error) {
      setState(() {
        _statusMessage = 'Calendar export failed: $error';
      });
    } finally {
      if (mounted) {
        setState(() => _isExportingCalendar = false);
      }
    }
  }

  Future<void> _handleBackupExport(
    ScheduleExportBundle bundle,
    PayPeriodSummary summary,
  ) async {
    setState(() {
      _isExportingBackup = true;
      _statusMessage = null;
    });

    try {
      final artifact = await ref
          .read(exportFileServiceProvider)
          .writeJsonBackup(bundle: bundle, summary: summary);
      ref.invalidate(exportHistoryProvider);
      setState(() {
        _statusMessage = 'Backup saved to ${artifact.filePath}';
      });
    } catch (error) {
      setState(() {
        _statusMessage = 'Backup export failed: $error';
      });
    } finally {
      if (mounted) {
        setState(() => _isExportingBackup = false);
      }
    }
  }

  Future<void> _handleRestoreBackup() async {
    // Show confirmation dialog before destructive replace-all.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore from backup?'),
        content: const Text(
          'This will permanently replace all current data with the contents '
          'of the selected backup file.\n\n'
          'This action cannot be undone. Make sure you have an up-to-date '
          'backup before continuing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isRestoring = true;
      _statusMessage = null;
    });

    try {
      final report = await ref
          .read(backupRestoreServiceProvider)
          .restoreFromFilePicker();

      if (!mounted) return;

      switch (report.result) {
        case RestoreResult.success:
          // Invalidate everything so the UI refreshes from restored data.
          ref.invalidate(exportHistoryProvider);
          setState(
            () => _statusMessage = report.message ?? 'Restore complete.',
          );
        case RestoreResult.cancelled:
          // User cancelled the picker — no message needed.
          break;
        case RestoreResult.invalidFile:
        case RestoreResult.missingSnapshot:
        case RestoreResult.importFailed:
          setState(() => _statusMessage = report.message ?? 'Restore failed.');
      }
    } catch (error) {
      if (mounted) {
        setState(() => _statusMessage = 'Restore failed: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _isRestoring = false);
      }
    }
  }
}

class _RestoreBackupCard extends StatelessWidget {
  const _RestoreBackupCard({
    required this.isRestoring,
    required this.onRestore,
  });

  final bool isRestoring;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Restore from backup', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Choose a ShiftMate Pay JSON backup file to import. '
            'This will permanently replace all current data in the app.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'All existing schedules, jobs, patterns, and reminders will be replaced.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: isRestoring ? null : onRestore,
            icon: isRestoring
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.restore_page_outlined),
            label: Text(
              isRestoring ? 'Restoring...' : 'Choose backup file to restore',
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportHero extends StatelessWidget {
  const _ExportHero({
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
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Export schedule data',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Create a printable PDF summary and a JSON backup from the same schedule window.',
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
              Text(rangeLabel),
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
                  OutlinedButton.icon(
                    onPressed: onTodayPressed,
                    icon: const Icon(Icons.today_outlined),
                    label: const Text('Today'),
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

class _ExportSummaryCard extends StatelessWidget {
  const _ExportSummaryCard({required this.summary});

  final PayPeriodSummary summary;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Export coverage',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _SummaryPill(label: 'Period', value: summary.periodLabel),
              _SummaryPill(
                label: 'Worked time',
                value: _formatMinutes(summary.totalWorkedMinutes),
              ),
              _SummaryPill(label: 'Shifts', value: '${summary.totalShifts}'),
              _SummaryPill(
                label: 'Holiday shifts',
                value: '${summary.holidayShifts}',
              ),
              _SummaryPill(
                label: 'Projected pay',
                value: MoneyFormatter.formatMinorUnits(
                  summary.grossPay,
                  currencyCode: summary.currencyCode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExportActionsCard extends StatelessWidget {
  const _ExportActionsCard({
    required this.statusMessage,
    required this.isExportingPdf,
    required this.isExportingCalendar,
    required this.isExportingBackup,
    required this.onExportCalendar,
    required this.onExportPdf,
    required this.onExportBackup,
  });

  final String? statusMessage;
  final bool isExportingPdf;
  final bool isExportingCalendar;
  final bool isExportingBackup;
  final Future<void> Function() onExportCalendar;
  final Future<void> Function() onExportPdf;
  final Future<void> Function() onExportBackup;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Export actions', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Calendar export writes an .ics file for personal calendars. PDF includes notes, holidays, off-day flags, and the pay summary. JSON backup includes the export window plus a local snapshot for recovery.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FeatureGate(
                feature: AppFeature.export,
                lockedLabel: 'Calendar export is reserved for Premium',
                entryPoint: 'calendar_sync_export',
                child: FilledButton.icon(
                  onPressed: isExportingCalendar
                      ? null
                      : () => onExportCalendar(),
                  icon: isExportingCalendar
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.calendar_month_outlined),
                  label: const Text('Create or refresh calendar (.ics)'),
                ),
              ),
              FeatureGate(
                feature: AppFeature.export,
                lockedLabel: 'PDF export is reserved for Premium',
                child: FilledButton.icon(
                  onPressed: isExportingPdf ? null : () => onExportPdf(),
                  icon: isExportingPdf
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text('Create PDF export'),
                ),
              ),
              OutlinedButton.icon(
                onPressed: isExportingBackup ? null : () => onExportBackup(),
                icon: isExportingBackup
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.backup_outlined),
                label: const Text('Create JSON backup'),
              ),
            ],
          ),
          if (statusMessage != null) ...[
            const SizedBox(height: 12),
            _StatusChip(message: statusMessage!),
          ],
        ],
      ),
    );
  }
}

class _ExportPreviewCard extends StatelessWidget {
  const _ExportPreviewCard({required this.document});

  final ScheduleExportDocument document;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'The export is prepared from ${document.shiftRows.length} schedule rows in ${document.rangeLabel}.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Calendar refresh uses the same range and keeps overnight shifts as timed events while off days become all-day entries.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ...document.shiftRows
              .take(6)
              .map(
                (row) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row.dateLabel,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text('${row.shiftLabel} - ${row.timeLabel}'),
                        if (row.note != null) ...[
                          const SizedBox(height: 4),
                          Text('Note: ${row.note}'),
                        ],
                        if (row.isHoliday || row.isOffDay) ...[
                          const SizedBox(height: 4),
                          Text(
                            [
                              if (row.isHoliday) 'Holiday',
                              if (row.isOffDay) 'Off day',
                            ].join(' - '),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
          if (document.shiftRows.length > 6)
            Text(
              '+ ${document.shiftRows.length - 6} more rows will be included in the file.',
            ),
        ],
      ),
    );
  }
}

class _ExportHistoryCard extends StatelessWidget {
  const _ExportHistoryCard({required this.history});

  final List<dynamic> history;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent export history',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (history.isEmpty)
            Text(
              'No export files have been created yet.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          else
            ...history.map(
              (entry) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(switch (entry.type) {
                  'pdf' => Icons.picture_as_pdf_outlined,
                  'calendar_ics' => Icons.calendar_month_outlined,
                  _ => Icons.backup_outlined,
                }),
                title: Text(entry.fileName as String),
                subtitle: Text(
                  '${DateFormat('d MMM yyyy, h:mm a').format(entry.createdAt as DateTime)}\n${entry.filePath as String}',
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text('$label: $value'),
    );
  }
}

class _ExportMessageState extends StatelessWidget {
  const _ExportMessageState({
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isError =
        message.toLowerCase().contains('failed') ||
        message.toLowerCase().contains('error');

    final bg = isError
        ? theme.colorScheme.errorContainer
        : theme.colorScheme.primaryContainer;
    final fg = isError
        ? theme.colorScheme.onErrorContainer
        : theme.colorScheme.onPrimaryContainer;
    final icon = isError ? Icons.error_outline : Icons.check_circle_outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(color: fg),
            ),
          ),
        ],
      ),
    );
  }
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
