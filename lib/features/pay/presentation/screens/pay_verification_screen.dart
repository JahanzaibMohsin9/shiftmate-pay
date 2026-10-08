import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/routing/app_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/cards/app_card.dart';
import '../../../../app/widgets/feature_gate.dart';
import '../../../../core/common/app_constants.dart';
import '../../../../core/money/money_formatter.dart';
import '../../../../data/local/database/database_providers.dart';
import '../../../../domain/entities/app_entitlement.dart';
import '../../../../domain/entities/pay_verification.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../premium/application/entitlement_provider.dart';
import '../../../premium/application/premium_analytics.dart';
import '../../../premium/presentation/widgets/premium_lifecycle_message_card.dart';
import '../../application/pay_verification_controller.dart';
import '../../application/pay_verification_providers.dart';

class PayVerificationScreen extends ConsumerStatefulWidget {
  const PayVerificationScreen({
    required this.jobId,
    required this.periodStart,
    required this.periodEnd,
    super.key,
  });

  final String jobId;
  final DateTime periodStart;
  final DateTime periodEnd;

  @override
  ConsumerState<PayVerificationScreen> createState() =>
      _PayVerificationScreenState();
}

class _PayVerificationScreenState extends ConsumerState<PayVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _grossController = TextEditingController();
  final _overtimeController = TextEditingController();
  final _holidayController = TextEditingController();
  final _allowancesController = TextEditingController();
  final _workedMinutesController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _paidAt;
  String? _hydratedSignature;
  bool _showFollowUpPrompt = false;

  PayVerificationRouteArgs get _args => PayVerificationRouteArgs(
    jobId: widget.jobId,
    periodStart: widget.periodStart,
    periodEnd: widget.periodEnd,
  );

  @override
  void dispose() {
    _grossController.dispose();
    _overtimeController.dispose();
    _holidayController.dispose();
    _allowancesController.dispose();
    _workedMinutesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<PayVerificationControllerState>(
      payVerificationControllerProvider,
      (previous, next) {
        if (!mounted) {
          return;
        }
        if (next.errorMessage != null &&
            next.errorMessage != previous?.errorMessage) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        } else if (next.completedAt != null &&
            next.completedAt != previous?.completedAt) {
          final preferences = ref.read(appPreferencesProvider);
          if (!preferences.verificationFollowUpSeen) {
            preferences.setVerificationFollowUpSeen(true);
            setState(() {
              _showFollowUpPrompt = true;
            });
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payslip comparison saved for this pay period.'),
            ),
          );
        }
      },
    );

    final viewAsync = ref.watch(payVerificationViewProvider(_args));
    final controllerState = ref.watch(payVerificationControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Compare with payslip')),
      body: SafeArea(
        child: viewAsync.when(
          data: (viewData) {
            _hydrateIfNeeded(viewData);
            final entitlement = ref.watch(entitlementProvider);

            return ListView(
              padding: AppSpacing.pagePaddingWithSafeBottom(context, top: 12),
              children: [
                _PeriodSummaryCard(
                  jobName: viewData.job.name,
                  expectedSummary: viewData.expectedSummary,
                ),
                const SizedBox(height: 16),
                _EntryGuidanceCard(
                  currencyCode: viewData.expectedSummary.currencyCode,
                ),
                const SizedBox(height: 16),
                if (_showFollowUpPrompt) ...[
                  PremiumLifecycleMessageCard(
                    icon: Icons.receipt_long_outlined,
                    title:
                        'Keep this as your reference point for payday checks',
                    body:
                        'Once the same job has imported shifts, advanced pay rules, and a saved payslip comparison, it becomes much easier to spot whether a later mismatch is a setup issue or a real payroll problem.',
                  ),
                  const SizedBox(height: 16),
                ],
                AppCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payslip entry',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start with gross pay from the payslip. Add the other fields only if they are listed and you want a clearer review.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _grossController,
                          decoration: const InputDecoration(
                            labelText: 'Gross pay on payslip',
                            helperText:
                                'Required. This is enough for a basic comparison.',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: _validateRequiredMoney,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Add more payslip details',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add these if your payslip shows them. They improve confidence instead of blocking comparison.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 16),
                        _MoneyField(
                          controller: _overtimeController,
                          label: 'Overtime pay on payslip',
                          validator: _validateOptionalMoney,
                        ),
                        const SizedBox(height: 12),
                        _MoneyField(
                          controller: _holidayController,
                          label: 'Holiday pay on payslip',
                          validator: _validateOptionalMoney,
                        ),
                        const SizedBox(height: 12),
                        _MoneyField(
                          controller: _allowancesController,
                          label: 'Allowances on payslip',
                          validator: _validateOptionalMoney,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _workedMinutesController,
                          decoration: const InputDecoration(
                            labelText: 'Worked minutes on payslip',
                            helperText:
                                'Optional. Enter total paid minutes if your payslip lists them.',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: _validateWorkedMinutes,
                        ),
                        const SizedBox(height: 16),
                        _PaidDateField(
                          selectedDate: _paidAt,
                          onSelect: _pickPaidDate,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _notesController,
                          minLines: 2,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Notes',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            FilledButton.icon(
                              onPressed: controllerState.isSaving
                                  ? null
                                  : () => _onComparePressed(
                                      context,
                                      entitlement: entitlement,
                                    ),
                              icon: controllerState.isSaving
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.analytics_outlined),
                              label: Text(
                                controllerState.isSaving
                                    ? 'Comparing pay...'
                                    : 'Compare pay',
                              ),
                            ),
                            if (viewData.existingPayslip != null)
                              OutlinedButton.icon(
                                onPressed: controllerState.isDeleting
                                    ? null
                                    : () => ref
                                          .read(
                                            payVerificationControllerProvider
                                                .notifier,
                                          )
                                          .delete(
                                            args: _args,
                                            payslipId:
                                                viewData.existingPayslip!.id,
                                          ),
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Delete comparison'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _VerificationSummarySection(
                  summary: viewData.verificationSummary,
                  entitlement: entitlement,
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      'Could not load pay verification',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(error.toString(), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _hydrateIfNeeded(PayVerificationViewData viewData) {
    final signature =
        '${viewData.existingPayslip?.id ?? 'new'}:${viewData.existingPayslip?.updatedAt.toIso8601String() ?? 'empty'}';
    if (_hydratedSignature == signature) {
      return;
    }

    final payslip = viewData.existingPayslip;
    _grossController.text = _formatMinorInput(payslip?.grossPayMinor);
    _overtimeController.text = _formatMinorInput(payslip?.overtimePayMinor);
    _holidayController.text = _formatMinorInput(payslip?.holidayPayMinor);
    _allowancesController.text = _formatMinorInput(payslip?.allowancesMinor);
    _workedMinutesController.text =
        payslip?.workedMinutesReported?.toString() ?? '';
    _notesController.text = payslip?.notes ?? '';
    _paidAt = payslip?.paidAt;
    _hydratedSignature = signature;
  }

  Future<void> _pickPaidDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _paidAt ?? widget.periodEnd,
      firstDate: widget.periodStart.subtract(const Duration(days: 365)),
      lastDate: widget.periodEnd.add(const Duration(days: 365)),
    );
    if (selected == null || !mounted) {
      return;
    }
    setState(() {
      _paidAt = selected;
    });
  }

  Future<void> _onComparePressed(
    BuildContext context, {
    required AppEntitlement entitlement,
  }) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!entitlement.canAccess(AppFeature.payVerification)) {
      context.push(
        AppRoutes.premiumWithContext(
          entryPoint: 'pay_verification_compare_attempt',
          feature: 'payVerification',
        ),
      );
      return;
    }

    final draft = PayVerificationDraft(
      grossPayMinor: _parseMoneyToMinorUnits(_grossController.text)!,
      paidAt: _paidAt,
      workedMinutesReported: _parseOptionalInt(_workedMinutesController.text),
      overtimePayMinor: _parseMoneyToMinorUnits(_overtimeController.text),
      holidayPayMinor: _parseMoneyToMinorUnits(_holidayController.text),
      allowancesMinor: _parseMoneyToMinorUnits(_allowancesController.text),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    await ref
        .read(payVerificationControllerProvider.notifier)
        .saveAndCompare(args: _args, draft: draft);
  }

  String? _validateRequiredMoney(String? value) {
    final parsed = _parseMoneyToMinorUnits(value ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Enter the gross pay shown on your payslip';
    }
    return null;
  }

  String? _validateOptionalMoney(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return null;
    }
    final parsed = _parseMoneyToMinorUnits(value ?? '');
    if (parsed == null || parsed < 0) {
      return 'Enter a valid amount or leave this blank';
    }
    return null;
  }

  String? _validateWorkedMinutes(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return null;
    }
    final parsed = int.tryParse((value ?? '').trim());
    if (parsed == null || parsed < 0) {
      return 'Enter a whole number of minutes or leave this blank';
    }
    return null;
  }

  int? _parseOptionalInt(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return int.tryParse(trimmed);
  }

  int? _parseMoneyToMinorUnits(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final normalized = trimmed.replaceAll(',', '');
    final value = double.tryParse(normalized);
    if (value == null) {
      return null;
    }
    return (value * AppConstants.minorUnitsPerMajorUnit).round();
  }

  String _formatMinorInput(int? minorUnits) {
    if (minorUnits == null) {
      return '';
    }
    return (minorUnits / AppConstants.minorUnitsPerMajorUnit).toStringAsFixed(
      2,
    );
  }
}

class _PeriodSummaryCard extends StatelessWidget {
  const _PeriodSummaryCard({
    required this.jobName,
    required this.expectedSummary,
  });

  final String jobName;
  final PayPeriodSummary expectedSummary;

  @override
  Widget build(BuildContext context) {
    final periodLabel =
        '${DateFormat('EEE, d MMM').format(expectedSummary.range.start)} to ${DateFormat('EEE, d MMM yyyy').format(expectedSummary.range.end)}';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected period',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(jobName, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            periodLabel,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Expected gross pay',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          Text(
            MoneyFormatter.formatMinorUnits(
              expectedSummary.grossPay,
              currencyCode: expectedSummary.currencyCode,
            ),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}

class _EntryGuidanceCard extends StatelessWidget {
  const _EntryGuidanceCard({required this.currencyCode});

  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter what your payslip says',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'ShiftMate compares the values you enter with the expected pay estimate for this same period. A mismatch is a review prompt, not proof of a payroll mistake.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Currency: $currencyCode',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _PaidDateField extends StatelessWidget {
  const _PaidDateField({required this.selectedDate, required this.onSelect});

  final DateTime? selectedDate;
  final Future<void> Function() onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Paid date', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onSelect,
          icon: const Icon(Icons.event_outlined),
          label: Text(
            selectedDate == null
                ? 'Add paid date'
                : DateFormat('d MMM yyyy').format(selectedDate!),
          ),
        ),
      ],
    );
  }
}

class _MoneyField extends StatelessWidget {
  const _MoneyField({
    required this.controller,
    required this.label,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: validator,
    );
  }
}

class _VerificationSummarySection extends StatelessWidget {
  const _VerificationSummarySection({
    required this.summary,
    required this.entitlement,
  });

  final PayVerificationSummary? summary;
  final AppEntitlement entitlement;

  @override
  Widget build(BuildContext context) {
    if (summary == null) {
      return const _VerificationPlaceholderCard();
    }

    final discrepancyItems = summary!.discrepancies
        .where(
          (item) =>
              item.type != PayVerificationDiscrepancyType.incompletePayslipData,
        )
        .toList(growable: false);
    final showNoDiscrepancyState =
        summary!.totalVarianceMinor == 0 || discrepancyItems.isEmpty;

    return Column(
      children: [
        _VerificationTotalsCard(summary: summary!),
        const SizedBox(height: 16),
        if (summary!.comparisonWarnings.isNotEmpty) ...[
          _VerificationWarningsCard(summary: summary!),
          const SizedBox(height: 16),
        ],
        if (showNoDiscrepancyState)
          const _NoDiscrepancyCard()
        else if (!entitlement.canAccess(AppFeature.payVerification))
          const PremiumTeaserCard(
            title: 'Unlock detailed review notes',
            description:
                'You are already checking a real payslip. Premium adds calmer category-by-category guidance right at the review moment.',
            ctaLabel: 'See Premium review tools',
            entryPoint: 'pay_verification_discrepancy_details',
            feature: 'payVerification',
            promptKind: PremiumPromptKind.transactional,
            features: [
              'Read detailed review notes instead of only a mismatch summary.',
              'See likely overtime, allowance, holiday, and shift-gap causes.',
              'Keep payslip comparisons saved locally for later review.',
            ],
          )
        else
          _DiscrepancyListCard(discrepancies: discrepancyItems),
      ],
    );
  }
}

class _VerificationPlaceholderCard extends StatelessWidget {
  const _VerificationPlaceholderCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No comparison saved yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the gross pay from your payslip above to save the first comparison for this period.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerificationTotalsCard extends StatelessWidget {
  const _VerificationTotalsCard({required this.summary});

  final PayVerificationSummary summary;

  @override
  Widget build(BuildContext context) {
    final varianceColor = switch (summary.varianceDirection) {
      PayVerificationVarianceDirection.match => AppColors.success,
      PayVerificationVarianceDirection.overpaid => Colors.blue,
      PayVerificationVarianceDirection.underpaid => Colors.deepOrange,
      PayVerificationVarianceDirection.uncertain => AppColors.warning,
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expected vs actual',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ValueColumn(
                  label: 'Expected',
                  value: MoneyFormatter.formatMinorUnits(
                    summary.expectedGrossPayMinor,
                    currencyCode: summary.currencyCode,
                  ),
                ),
              ),
              Expanded(
                child: _ValueColumn(
                  label: 'Actual',
                  value: MoneyFormatter.formatMinorUnits(
                    summary.actualGrossPayMinor,
                    currencyCode: summary.currencyCode,
                  ),
                ),
              ),
              Expanded(
                child: _ValueColumn(
                  label: 'Variance',
                  value: MoneyFormatter.formatMinorUnits(
                    summary.totalVarianceMinor.abs(),
                    currencyCode: summary.currencyCode,
                  ),
                  color: varianceColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SummaryChip(label: _directionLabel(summary.varianceDirection)),
              _SummaryChip(label: _confidenceLabel(summary.confidence)),
              _SummaryChip(label: _comparisonLabel(summary.comparisonType)),
            ],
          ),
        ],
      ),
    );
  }

  String _directionLabel(PayVerificationVarianceDirection direction) {
    return switch (direction) {
      PayVerificationVarianceDirection.match => 'No mismatch detected',
      PayVerificationVarianceDirection.underpaid => 'Actual pay looks lower',
      PayVerificationVarianceDirection.overpaid => 'Actual pay looks higher',
      PayVerificationVarianceDirection.uncertain => 'Needs more payslip detail',
    };
  }

  String _confidenceLabel(PayVerificationConfidence confidence) {
    return switch (confidence) {
      PayVerificationConfidence.high => 'High confidence',
      PayVerificationConfidence.medium => 'Medium confidence',
      PayVerificationConfidence.low => 'Low confidence',
    };
  }

  String _comparisonLabel(PayVerificationComparisonType comparisonType) {
    return switch (comparisonType) {
      PayVerificationComparisonType.exact => 'Detailed comparison',
      PayVerificationComparisonType.likely => 'Partial-detail comparison',
    };
  }
}

class _VerificationWarningsCard extends StatelessWidget {
  const _VerificationWarningsCard({required this.summary});

  final PayVerificationSummary summary;

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
          for (final warning in summary.comparisonWarnings) ...[
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

class _NoDiscrepancyCard extends StatelessWidget {
  const _NoDiscrepancyCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const Icon(
            Icons.verified_outlined,
            size: 36,
            color: AppColors.success,
          ),
          const SizedBox(height: 12),
          Text(
            'No discrepancy highlighted',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Nothing entered so far points to a likely pay issue. If your payslip has more detail, you can still add it for a stronger review.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscrepancyListCard extends StatelessWidget {
  const _DiscrepancyListCard({required this.discrepancies});

  final List<PayVerificationDiscrepancy> discrepancies;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review notes', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(
            'These notes highlight likely causes based on the schedule and payslip details saved so far.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          for (final discrepancy in discrepancies) ...[
            _DiscrepancyTile(discrepancy: discrepancy),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _DiscrepancyTile extends StatelessWidget {
  const _DiscrepancyTile({required this.discrepancy});

  final PayVerificationDiscrepancy discrepancy;

  @override
  Widget build(BuildContext context) {
    final color = switch (discrepancy.severity) {
      PayVerificationDiscrepancySeverity.info => Colors.blueGrey,
      PayVerificationDiscrepancySeverity.warning => AppColors.warning,
      PayVerificationDiscrepancySeverity.high => Colors.deepOrange,
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  discrepancy.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              _SummaryChip(
                label:
                    '${_severityLabel(discrepancy.severity)} | ${_confidenceLabel(discrepancy.confidence)}',
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(discrepancy.explanation),
          const SizedBox(height: 8),
          Text(
            discrepancy.suggestedNextStep,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _severityLabel(PayVerificationDiscrepancySeverity severity) {
    return switch (severity) {
      PayVerificationDiscrepancySeverity.info => 'Info',
      PayVerificationDiscrepancySeverity.warning => 'Warning',
      PayVerificationDiscrepancySeverity.high => 'High priority',
    };
  }

  String _confidenceLabel(PayVerificationConfidence confidence) {
    return switch (confidence) {
      PayVerificationConfidence.high => 'High confidence',
      PayVerificationConfidence.medium => 'Medium confidence',
      PayVerificationConfidence.low => 'Low confidence',
    };
  }
}

class _ValueColumn extends StatelessWidget {
  const _ValueColumn({required this.label, required this.value, this.color});

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
