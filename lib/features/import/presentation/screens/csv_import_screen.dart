import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/routing/app_router.dart';
import '../../../../app/widgets/cards/app_card.dart';
import '../../../../app/widgets/feature_gate.dart';
import '../../../../data/local/database/database_providers.dart';
import '../../../../domain/entities/app_entitlement.dart';
import '../../../../domain/entities/import_preview.dart';
import '../../../../domain/entities/job.dart';
import '../../../jobs/application/jobs_providers.dart';
import '../../../premium/application/entitlement_provider.dart';
import '../../../premium/presentation/widgets/premium_lifecycle_message_card.dart';
import '../../application/import_providers.dart';

class CsvImportScreen extends ConsumerStatefulWidget {
  const CsvImportScreen({required this.jobId, super.key});

  final String jobId;

  @override
  ConsumerState<CsvImportScreen> createState() => _CsvImportScreenState();
}

class _CsvImportScreenState extends ConsumerState<CsvImportScreen> {
  bool _showFollowUpPrompt = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<CsvImportState>(csvImportControllerProvider(widget.jobId), (
      previous,
      next,
    ) {
      if (!mounted) {
        return;
      }

      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      }
      if (next.completedAt != null &&
          next.completedAt != previous?.completedAt) {
        final preferences = ref.read(appPreferencesProvider);
        final shouldShowFollowUp = !preferences.importFollowUpSeen;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Imported ${next.importedRowCount ?? 0} accepted rows into the schedule.',
            ),
          ),
        );
        if (shouldShowFollowUp) {
          preferences.setImportFollowUpSeen(true);
          setState(() {
            _showFollowUpPrompt = true;
          });
        } else if (Navigator.of(context).canPop()) {
          context.pop(true);
        }
      }
    });

    final jobsAsync = ref.watch(jobsProvider);
    final state = ref.watch(csvImportControllerProvider(widget.jobId));
    final controller = ref.read(
      csvImportControllerProvider(widget.jobId).notifier,
    );
    final entitlement = ref.watch(entitlementProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Import CSV rota')),
      body: SafeArea(
        child: jobsAsync.when(
          data: (jobs) {
            final job = jobs
                .where((entry) => entry.id == widget.jobId)
                .firstOrNull;
            if (job == null) {
              return const _ImportMessageState(
                icon: Icons.work_off_outlined,
                title: 'Job not found',
                description:
                    'This job is no longer available. Go back and choose another job before importing a rota.',
              );
            }

            final previewSections = state.preview == null
                ? null
                : _PreviewSections.fromPreview(state.preview!);

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                _ImportHeroCard(job: job),
                const SizedBox(height: 16),
                if (_showFollowUpPrompt) ...[
                  PremiumLifecycleMessageCard(
                    icon: Icons.check_circle_outline,
                    title:
                        'Imported rotas are easiest to trust when you review the next pay period',
                    body:
                        'Your schedule is now in ShiftMate. Next, use Pay to confirm the imported shifts still line up with your expected earnings and any advanced rules you rely on.',
                    ctaLabel: 'Open Pay',
                    onPressed: () => context.go(AppRoutes.pay),
                  ),
                  const SizedBox(height: 16),
                ],
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose a CSV file',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You can preview accepted, skipped, duplicate, and conflicted rows before anything is saved.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          FilledButton.icon(
                            onPressed:
                                state.isPickingFile ||
                                    state.isLoadingPreview ||
                                    state.isSaving
                                ? null
                                : controller.pickAndPreviewFile,
                            icon: state.isPickingFile || state.isLoadingPreview
                                ? const SizedBox.square(
                                    dimension: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.upload_file_outlined),
                            label: Text(
                              state.isPickingFile || state.isLoadingPreview
                                  ? 'Reading file...'
                                  : 'Choose CSV file',
                            ),
                          ),
                          if (state.fileName != null)
                            Chip(
                              avatar: const Icon(
                                Icons.description_outlined,
                                size: 18,
                              ),
                              label: Text(state.fileName!),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (previewSections != null) ...[
                  _PreviewSummaryCard(preview: previewSections.preview),
                  const SizedBox(height: 16),
                  _ReviewSection(
                    title: 'Accepted rows',
                    icon: Icons.check_circle_outline,
                    rows: previewSections.acceptedRows,
                    emptyLabel:
                        'No rows are ready to import from this file yet.',
                    accentColor: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _ReviewSection(
                    title: 'Conflicted rows',
                    icon: Icons.warning_amber_outlined,
                    rows: previewSections.conflictRows,
                    emptyLabel:
                        'No overlap conflicts were found against the current schedule.',
                    accentColor: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  _ReviewSection(
                    title: 'Duplicate rows',
                    icon: Icons.copy_all_outlined,
                    rows: previewSections.duplicateRows,
                    emptyLabel: 'No duplicate rows were detected.',
                    accentColor: Colors.blueGrey,
                  ),
                  const SizedBox(height: 16),
                  _ReviewSection(
                    title: 'Skipped rows',
                    icon: Icons.do_not_disturb_alt_outlined,
                    rows: previewSections.skippedRows,
                    emptyLabel: 'No rows were skipped during parsing.',
                    accentColor: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  _ImportActionCard(
                    preview: previewSections.preview,
                    isSaving: state.isSaving,
                    premiumUnlocked: entitlement.canAccess(AppFeature.import),
                    onImport: () async {
                      if (!entitlement.canAccess(AppFeature.import)) {
                        context.push(
                          AppRoutes.premiumWithContext(
                            entryPoint: 'jobs_csv_import_confirm',
                            feature: AppFeature.import.name,
                          ),
                        );
                        return;
                      }
                      await controller.importAcceptedRows();
                    },
                  ),
                ] else
                  const _ImportPreviewPlaceholderCard(),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _ImportMessageState(
            icon: Icons.error_outline,
            title: 'Unable to load jobs',
            description: error.toString(),
          ),
        ),
      ),
    );
  }
}

class _ImportHeroCard extends StatelessWidget {
  const _ImportHeroCard({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Import into ${job.name}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Release one imports one job at a time and never saves immediately after parsing.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewSummaryCard extends StatelessWidget {
  const _PreviewSummaryCard({required this.preview});

  final ShiftImportPreviewResult preview;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview summary',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _SummaryChip(label: '${preview.totalRows} total rows'),
              _SummaryChip(label: '${preview.acceptedRowCount} accepted'),
              _SummaryChip(label: '${preview.conflictRowCount} conflicts'),
              _SummaryChip(label: '${preview.duplicateRowCount} duplicates'),
              _SummaryChip(label: '${preview.skippedRowCount} skipped'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({
    required this.title,
    required this.icon,
    required this.rows,
    required this.emptyLabel,
    required this.accentColor,
  });

  final String title;
  final IconData icon;
  final List<ImportPreviewRow> rows;
  final String emptyLabel;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor),
              const SizedBox(width: 10),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          if (rows.isEmpty)
            Text(
              emptyLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          else
            for (final row in rows) ...[
              _PreviewRowTile(row: row, accentColor: accentColor),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _PreviewRowTile extends StatelessWidget {
  const _PreviewRowTile({required this.row, required this.accentColor});

  final ImportPreviewRow row;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final parsed = row.parsedRow;
    final shift = row.proposedShift;
    final title =
        shift?.templateSnapshot?.name ??
        parsed.shiftName ??
        parsed.jobName ??
        'Row ${parsed.rowNumber}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: accentColor.withValues(alpha: 0.08),
        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Row ${parsed.rowNumber}: $title',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              if (shift != null)
                _SummaryChip(
                  label: row.appliesAsOverride ? 'Override' : 'Direct shift',
                  color: accentColor,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _rowTimingLabel(parsed),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            row.message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (parsed.notes?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: 4),
            Text(
              'Note: ${parsed.notes!.trim()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  String _rowTimingLabel(ParsedShiftImportRow row) {
    if (row.startDateTime == null || row.endDateTime == null) {
      return 'Timing could not be parsed confidently.';
    }

    final dateLabel = DateFormat('EEE, d MMM yyyy').format(row.startDateTime!);
    final timeFormat = DateFormat('h:mm a');
    final breakLabel = row.unpaidBreakMinutes == null
        ? 'No break value provided'
        : '${row.unpaidBreakMinutes} min unpaid break';

    return '$dateLabel, ${timeFormat.format(row.startDateTime!)} - ${timeFormat.format(row.endDateTime!)} · $breakLabel';
  }
}

class _ImportActionCard extends StatelessWidget {
  const _ImportActionCard({
    required this.preview,
    required this.isSaving,
    required this.premiumUnlocked,
    required this.onImport,
  });

  final ShiftImportPreviewResult preview;
  final bool isSaving;
  final bool premiumUnlocked;
  final Future<void> Function() onImport;

  @override
  Widget build(BuildContext context) {
    final acceptedCount = preview.acceptedRowCount;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review before save',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            acceptedCount == 0
                ? 'There are no accepted rows to save yet. Resolve skipped or conflicted rows first.'
                : 'Only accepted rows will be saved. Duplicate and conflicted rows stay out of this batch until you review them.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          if (!premiumUnlocked)
            const FeatureGate(
              feature: AppFeature.import,
              entryPoint: 'jobs_csv_import_confirm',
              lockedLabel:
                  'Preview is free to review. Saving accepted import rows is a Premium action.',
              child: SizedBox.shrink(),
            ),
          if (!premiumUnlocked) const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: isSaving || acceptedCount == 0 ? null : onImport,
            icon: isSaving
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_alt_outlined),
            label: Text(
              isSaving
                  ? 'Importing rows...'
                  : acceptedCount == 0
                  ? 'No accepted rows to import'
                  : 'Import $acceptedCount accepted rows',
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, this.color});

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

class _ImportPreviewPlaceholderCard extends StatelessWidget {
  const _ImportPreviewPlaceholderCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview comes first',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Pick a CSV file to review accepted, conflicted, duplicate, and skipped rows before anything is saved.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Premium is only required when you decide to save accepted rows.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImportMessageState extends StatelessWidget {
  const _ImportMessageState({
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

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class _PreviewSections {
  const _PreviewSections({
    required this.preview,
    required this.acceptedRows,
    required this.conflictRows,
    required this.duplicateRows,
    required this.skippedRows,
  });

  final ShiftImportPreviewResult preview;
  final List<ImportPreviewRow> acceptedRows;
  final List<ImportPreviewRow> conflictRows;
  final List<ImportPreviewRow> duplicateRows;
  final List<ImportPreviewRow> skippedRows;

  factory _PreviewSections.fromPreview(ShiftImportPreviewResult preview) {
    final acceptedRows = <ImportPreviewRow>[];
    final conflictRows = <ImportPreviewRow>[];
    final duplicateRows = <ImportPreviewRow>[];
    final skippedRows = <ImportPreviewRow>[];

    for (final row in preview.rows) {
      switch (row.status) {
        case ImportPreviewRowStatus.accepted:
          acceptedRows.add(row);
          break;
        case ImportPreviewRowStatus.duplicate:
          duplicateRows.add(row);
          break;
        case ImportPreviewRowStatus.conflict:
          conflictRows.add(row);
          break;
        case ImportPreviewRowStatus.skipped:
          skippedRows.add(row);
          break;
      }
    }

    return _PreviewSections(
      preview: preview,
      acceptedRows: List.unmodifiable(acceptedRows),
      conflictRows: List.unmodifiable(conflictRows),
      duplicateRows: List.unmodifiable(duplicateRows),
      skippedRows: List.unmodifiable(skippedRows),
    );
  }
}
