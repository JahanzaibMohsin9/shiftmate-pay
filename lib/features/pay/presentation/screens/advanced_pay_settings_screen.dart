import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routing/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/widgets/cards/app_card.dart';
import '../../../../core/common/identifiers.dart';
import '../../../../core/common/shared_types.dart';
import '../../../../core/money/currency_amount.dart';
import '../../../../core/money/money_formatter.dart';
import '../../../../data/local/database/database_providers.dart';
import '../../../../domain/entities/advanced_pay_rule_set.dart';
import '../../../../domain/entities/app_entitlement.dart';
import '../../../../features/premium/application/entitlement_provider.dart';
import '../../../../features/premium/application/premium_analytics.dart';
import '../../../../features/premium/presentation/widgets/premium_lifecycle_message_card.dart';
import '../../application/advanced_pay_settings_controller.dart';
import '../../application/advanced_pay_settings_providers.dart';

class AdvancedPaySettingsScreen extends ConsumerStatefulWidget {
  const AdvancedPaySettingsScreen({required this.jobId, super.key});

  final String jobId;

  @override
  ConsumerState<AdvancedPaySettingsScreen> createState() =>
      _AdvancedPaySettingsScreenState();
}

class _AdvancedPaySettingsScreenState
    extends ConsumerState<AdvancedPaySettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _gateTracked = false;
  bool _showCrossValidation = false;
  String? _initializedKey;
  DateTime? _lastShownSavedAt;
  List<_EditableOvertimeRule> _overtimeRules = const [];
  List<_EditableAllowanceRule> _allowanceRules = const [];
  List<_EditableBreakRule> _breakRules = const [];
  late _EditableDifferentialRule _nightRule;
  late _EditableDifferentialRule _weekendRule;
  bool _showFollowUpPrompt = false;

  @override
  Widget build(BuildContext context) {
    final entitlement = ref.watch(entitlementProvider);
    final viewAsync = ref.watch(advancedPaySettingsViewProvider(widget.jobId));
    final saveState = ref.watch(advancedPaySettingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Advanced pay rules')),
      body: SafeArea(
        child: viewAsync.when(
          data: (view) {
            _initializeDrafts(view);
            _trackGateIfNeeded(entitlement);
            _showErrorSnackBar(saveState.errorMessage);
            _showSavedSnackBar(saveState.savedAt);
            final blockingMessage = _showCrossValidation
                ? _blockingValidationMessage
                : null;
            final summaryLines = _buildRuleSummaryLines();
            final previewLines = _buildPreviewLines(view.job.hourlyRate);

            return Form(
              key: _formKey,
              child: ListView(
                padding: AppSpacing.pagePaddingWithSafeBottom(context),
                children: [
                  _HeroCard(
                    jobName: view.job.name,
                    entitlement: entitlement,
                    onUpgrade: () => context.push(
                      AppRoutes.premiumWithContext(
                        entryPoint: 'advanced_pay_setup',
                        feature: AppFeature.advancedPayRules.name,
                      ),
                    ),
                  ),
                  AppSpacing.gapMd,
                  _SimpleDefaultsCard(view: view),
                  AppSpacing.gapMd,
                  if (_showFollowUpPrompt) ...[
                    PremiumLifecycleMessageCard(
                      icon: Icons.tips_and_updates_outlined,
                      title: 'Your accuracy setup is in place',
                      body:
                          'The next high-value step is comparing a real payslip for the same job and period. That helps confirm whether the rules you saved now match what payroll is actually paying.',
                      ctaLabel: 'Open Pay',
                      onPressed: () => context.go(AppRoutes.pay),
                    ),
                    AppSpacing.gapMd,
                  ],
                  if (!entitlement.canAccess(AppFeature.advancedPayRules)) ...[
                    _GateMomentCard(
                      onUpgrade: () => context.push(
                        AppRoutes.premiumWithContext(
                          entryPoint: 'advanced_pay_setup',
                          feature: AppFeature.advancedPayRules.name,
                        ),
                      ),
                    ),
                    AppSpacing.gapMd,
                    _ReadOnlyRulePreview(
                      overtimeCount: _overtimeRules
                          .where((rule) => rule.enabled)
                          .length,
                      nightEnabled: _nightRule.enabled,
                      weekendEnabled: _weekendRule.enabled,
                      allowanceCount: _allowanceRules
                          .where((rule) => rule.enabled)
                          .length,
                      breakCount: _breakRules
                          .where((rule) => rule.enabled)
                          .length,
                    ),
                  ] else ...[
                    _EditingSummaryCard(
                      hasExistingRuleSet: view.advancedPayRuleSet != null,
                      onAddTier: _addOvertimeTier,
                    ),
                    AppSpacing.gapMd,
                    _RuleSummaryCard(lines: summaryLines),
                    AppSpacing.gapMd,
                    _PreviewImpactCard(lines: previewLines),
                    AppSpacing.gapMd,
                    _OvertimeEditorCard(
                      rules: _overtimeRules,
                      onAddTier: _addOvertimeTier,
                      onRemoveTier: _removeOvertimeTier,
                      onChanged: _updateOvertimeRule,
                      crossValidationMessage: _showCrossValidation
                          ? _overtimeCrossValidationMessage
                          : null,
                    ),
                    AppSpacing.gapMd,
                    _DifferentialEditorCard(
                      title: 'Night differential',
                      description:
                          'Use this when only part of a shift should earn more because it falls in a night window.',
                      rule: _nightRule,
                      onChanged: _updateNightRule,
                      defaultDaysLabel: 'Applies by local time window only',
                      sampleSummary: _nightPreviewSummary,
                    ),
                    AppSpacing.gapMd,
                    _DifferentialEditorCard(
                      title: 'Weekend differential',
                      description:
                          'Use this when Saturday and Sunday minutes should receive an uplift even if the rest of the week stays on the base rate.',
                      rule: _weekendRule,
                      onChanged: _updateWeekendRule,
                      defaultDaysLabel: 'Choose one or both weekend days',
                      sampleSummary: _weekendPreviewSummary,
                    ),
                    AppSpacing.gapMd,
                    _AllowanceEditorCard(
                      rules: _allowanceRules,
                      onAddRule: _addAllowanceRule,
                      onRemoveRule: _removeAllowanceRule,
                      onChanged: _updateAllowanceRule,
                    ),
                    AppSpacing.gapMd,
                    _BreakEditorCard(
                      rules: _breakRules,
                      onAddRule: _addBreakRule,
                      onRemoveRule: _removeBreakRule,
                      onChanged: _updateBreakRule,
                      validationMessage: _showCrossValidation
                          ? _breakValidationMessage
                          : null,
                    ),
                    AppSpacing.gapMd,
                    if (blockingMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _InlineStatusCard(
                          title: 'Fix these rule conflicts before saving',
                          body: blockingMessage,
                          isError: true,
                        ),
                      ),
                    if (_warningMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _InlineStatusCard(
                          title: 'Heads up',
                          body: _warningMessage!,
                          isError: false,
                        ),
                      ),
                    if (saveState.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          saveState.errorMessage!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    FilledButton.icon(
                      onPressed: saveState.isSaving ? null : () => _save(view),
                      icon: saveState.isSaving
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        saveState.isSaving
                            ? 'Saving advanced pay rules...'
                            : 'Save advanced pay rules',
                      ),
                    ),
                    if (saveState.savedAt != null) ...[
                      AppSpacing.gapSm,
                      Text(
                        'Last saved at ${TimeOfDay.fromDateTime(saveState.savedAt!).format(context)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: AppSpacing.pagePadding,
              child: AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 40,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    AppSpacing.gapMd,
                    Text(
                      'Could not load advanced pay settings',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.gapSm,
                    Text(
                      error.toString(),
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
        ),
      ),
    );
  }

  void _initializeDrafts(AdvancedPaySettingsViewData view) {
    final nextKey =
        '${view.job.id}:${view.advancedPayRuleSet?.updatedAt.toIso8601String() ?? 'empty'}';
    if (_initializedKey == nextKey) {
      return;
    }

    final existing = view.advancedPayRuleSet;
    _initializedKey = nextKey;
    _showCrossValidation = false;
    _overtimeRules =
        existing?.overtimeRules
            .map(
              (rule) => _EditableOvertimeRule(
                id: rule.id,
                periodType: rule.periodType,
                thresholdHoursText: _hoursTextFromMinutes(
                  rule.thresholdMinutes,
                ),
                multiplierText: _multiplierText(rule.multiplierBps),
                enabled: rule.enabled,
              ),
            )
            .toList(growable: true) ??
        <_EditableOvertimeRule>[
          _EditableOvertimeRule(
            id: AppId.generate(),
            periodType: OvertimePeriodType.daily,
            thresholdHoursText: '8',
            multiplierText: '1.5',
            enabled: true,
          ),
        ];

    final night = existing?.differentialRules
        .where((rule) => rule.type == DifferentialRuleType.night)
        .firstOrNull;
    final weekend = existing?.differentialRules
        .where((rule) => rule.type == DifferentialRuleType.weekend)
        .firstOrNull;

    _nightRule = _EditableDifferentialRule(
      id: night?.id ?? AppId.generate(),
      type: DifferentialRuleType.night,
      enabled: night?.enabled ?? false,
      multiplierText: _multiplierText(night?.multiplierBps ?? 12000),
      combinationMode:
          night?.combinationMode ?? DifferentialCombinationMode.additivePremium,
      startTimeText: _timeText(night?.startMinutesLocal ?? (22 * 60)),
      endTimeText: _timeText(night?.endMinutesLocal ?? (6 * 60)),
      appliesOnSaturday: false,
      appliesOnSunday: false,
    );
    _weekendRule = _EditableDifferentialRule(
      id: weekend?.id ?? AppId.generate(),
      type: DifferentialRuleType.weekend,
      enabled: weekend?.enabled ?? false,
      multiplierText: _multiplierText(weekend?.multiplierBps ?? 12500),
      combinationMode:
          weekend?.combinationMode ??
          DifferentialCombinationMode.additivePremium,
      startTimeText: '',
      endTimeText: '',
      appliesOnSaturday: weekend?.appliesOnSaturday ?? true,
      appliesOnSunday: weekend?.appliesOnSunday ?? true,
    );
    _allowanceRules =
        existing?.allowanceRules
            .map(
              (rule) => _EditableAllowanceRule(
                id: rule.id,
                type: rule.type,
                amountText: _amountText(rule.amountMinor),
                enabled: rule.enabled,
                appliesOnHoliday: rule.appliesOnHoliday,
              ),
            )
            .toList(growable: true) ??
        <_EditableAllowanceRule>[
          _EditableAllowanceRule(
            id: AppId.generate(),
            type: AllowanceRuleType.perShift,
            amountText: '',
            enabled: false,
            appliesOnHoliday: false,
          ),
        ];
    _breakRules =
        existing?.breakRules
            .map(
              (rule) => _EditableBreakRule(
                id: rule.id,
                minutesText: '${rule.minutes}',
                enabled: rule.enabled,
                shiftCategory: rule.shiftCategory,
              ),
            )
            .toList(growable: true) ??
        <_EditableBreakRule>[
          _EditableBreakRule(
            id: AppId.generate(),
            minutesText: '',
            enabled: false,
            shiftCategory: null,
          ),
        ];
  }

  void _trackGateIfNeeded(AppEntitlement entitlement) {
    if (_gateTracked || entitlement.canAccess(AppFeature.advancedPayRules)) {
      return;
    }

    _gateTracked = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref
          .read(premiumAnalyticsTrackerProvider)
          .track(
            PremiumAnalyticsEvent.premiumGateEncountered,
            fields: {
              'screen_name': 'advanced_pay_settings',
              'entry_point': 'advanced_pay_setup',
              'prompt_kind': PremiumPromptKind.transactional.name,
              'entitlement_state': entitlement.premium ? 'premium' : 'free',
              'result': AppFeature.advancedPayRules.name,
            },
          );
    });
  }

  void _showErrorSnackBar(String? errorMessage) {
    if (errorMessage == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final preferences = ref.read(appPreferencesProvider);
      if (!preferences.advancedPayFollowUpSeen) {
        setState(() {
          _showFollowUpPrompt = true;
        });
        unawaited(preferences.setAdvancedPayFollowUpSeen(true));
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(errorMessage)));
    });
  }

  void _showSavedSnackBar(DateTime? savedAt) {
    if (savedAt == null || savedAt == _lastShownSavedAt) {
      return;
    }
    _lastShownSavedAt = savedAt;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Advanced pay rules saved.')),
        );
    });
  }

  void _addOvertimeTier() {
    setState(() {
      _overtimeRules = [
        ..._overtimeRules,
        _EditableOvertimeRule(
          id: AppId.generate(),
          periodType: OvertimePeriodType.daily,
          thresholdHoursText: '',
          multiplierText: '1.5',
          enabled: true,
        ),
      ];
    });
  }

  void _removeOvertimeTier(String ruleId) {
    setState(() {
      _overtimeRules = _overtimeRules
          .where((rule) => rule.id != ruleId)
          .toList(growable: true);
    });
  }

  void _updateOvertimeRule(String ruleId, _EditableOvertimeRule next) {
    setState(() {
      _overtimeRules = [
        for (final rule in _overtimeRules)
          if (rule.id == ruleId) next else rule,
      ];
    });
  }

  void _updateNightRule(_EditableDifferentialRule next) {
    setState(() => _nightRule = next);
  }

  void _updateWeekendRule(_EditableDifferentialRule next) {
    setState(() => _weekendRule = next);
  }

  void _addAllowanceRule() {
    setState(() {
      _allowanceRules = [
        ..._allowanceRules,
        _EditableAllowanceRule(
          id: AppId.generate(),
          type: AllowanceRuleType.perShift,
          amountText: '',
          enabled: true,
          appliesOnHoliday: false,
        ),
      ];
    });
  }

  void _removeAllowanceRule(String ruleId) {
    setState(() {
      _allowanceRules = _allowanceRules
          .where((rule) => rule.id != ruleId)
          .toList(growable: true);
    });
  }

  void _updateAllowanceRule(String ruleId, _EditableAllowanceRule next) {
    setState(() {
      _allowanceRules = [
        for (final rule in _allowanceRules)
          if (rule.id == ruleId) next else rule,
      ];
    });
  }

  void _addBreakRule() {
    setState(() {
      _breakRules = [
        ..._breakRules,
        _EditableBreakRule(
          id: AppId.generate(),
          minutesText: '',
          enabled: true,
          shiftCategory: null,
        ),
      ];
    });
  }

  void _removeBreakRule(String ruleId) {
    setState(() {
      _breakRules = _breakRules
          .where((rule) => rule.id != ruleId)
          .toList(growable: true);
    });
  }

  void _updateBreakRule(String ruleId, _EditableBreakRule next) {
    setState(() {
      _breakRules = [
        for (final rule in _breakRules)
          if (rule.id == ruleId) next else rule,
      ];
    });
  }

  String? get _overtimeCrossValidationMessage {
    final grouped = <OvertimePeriodType, List<_EditableOvertimeRule>>{};
    for (final rule in _overtimeRules.where((entry) => entry.enabled)) {
      final threshold = double.tryParse(rule.thresholdHoursText);
      if (threshold == null) {
        continue;
      }
      grouped.putIfAbsent(rule.periodType, () => []).add(rule);
    }

    for (final entry in grouped.entries) {
      final values =
          entry.value
              .map((rule) => double.parse(rule.thresholdHoursText))
              .toList(growable: false)
            ..sort();
      for (var index = 1; index < values.length; index++) {
        if (values[index] <= values[index - 1]) {
          final label = entry.key == OvertimePeriodType.daily
              ? 'daily'
              : 'weekly';
          return 'Enabled $label overtime tiers must increase from one threshold to the next.';
        }
      }
    }

    return null;
  }

  String? get _breakValidationMessage {
    final enabledRules = _breakRules.where((rule) => rule.enabled).toList();
    final seenKeys = <String>{};

    for (final rule in enabledRules) {
      final key = rule.shiftCategory?.name ?? 'all';
      if (!seenKeys.add(key)) {
        final scope = rule.shiftCategory == null
            ? 'all shifts'
            : '${_shiftCategoryLabel(rule.shiftCategory)} shifts';
        return 'Only one advanced break override can target $scope. Merge duplicate break rules before saving.';
      }
    }

    return null;
  }

  String? get _blockingValidationMessage {
    final overtimeMessage = _overtimeCrossValidationMessage;
    if (overtimeMessage != null) {
      return overtimeMessage;
    }
    if (_weekendRule.enabled &&
        !_weekendRule.appliesOnSaturday &&
        !_weekendRule.appliesOnSunday) {
      return 'Weekend differential is enabled, but no weekend days are selected.';
    }

    final breakMessage = _breakValidationMessage;
    if (breakMessage != null) {
      return breakMessage;
    }

    return null;
  }

  String? get _warningMessage {
    if (_nightRule.enabled &&
        _weekendRule.enabled &&
        _nightRule.combinationMode ==
            DifferentialCombinationMode.exclusiveHighestWins &&
        _weekendRule.combinationMode ==
            DifferentialCombinationMode.exclusiveHighestWins) {
      return 'Night and weekend premiums are both set to highest-wins, so overlapping Saturday night minutes will only keep the strongest uplift.';
    }
    return null;
  }

  Future<void> _save(AdvancedPaySettingsViewData view) async {
    setState(() => _showCrossValidation = true);

    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) {
      return;
    }

    if (_blockingValidationMessage != null) {
      setState(() {});
      return;
    }

    final overtimeRules = _overtimeRules
        .where((rule) => rule.enabled)
        .mapIndexed(
          (index, rule) => OvertimeTierRule(
            id: rule.id,
            periodType: rule.periodType,
            thresholdMinutes: (double.parse(rule.thresholdHoursText) * 60)
                .round(),
            multiplierBps: (double.parse(rule.multiplierText) * 10000).round(),
            priority: index + 1,
            enabled: true,
          ),
        )
        .toList(growable: false);
    final editableDifferentials = [
      if (_nightRule.enabled)
        DifferentialPayRule(
          id: _nightRule.id,
          type: DifferentialRuleType.night,
          combinationMode: _nightRule.combinationMode,
          enabled: true,
          multiplierBps: (double.parse(_nightRule.multiplierText) * 10000)
              .round(),
          startMinutesLocal: _parseTimeText(_nightRule.startTimeText),
          endMinutesLocal: _parseTimeText(_nightRule.endTimeText),
        ),
      if (_weekendRule.enabled)
        DifferentialPayRule(
          id: _weekendRule.id,
          type: DifferentialRuleType.weekend,
          combinationMode: _weekendRule.combinationMode,
          enabled: true,
          multiplierBps: (double.parse(_weekendRule.multiplierText) * 10000)
              .round(),
          appliesOnSaturday: _weekendRule.appliesOnSaturday,
          appliesOnSunday: _weekendRule.appliesOnSunday,
        ),
    ];
    final allowanceRules = _allowanceRules
        .where((rule) => rule.enabled)
        .map(
          (rule) => AllowancePayRule(
            id: rule.id,
            type: rule.type,
            amountMinor: _parseAmountText(rule.amountText),
            enabled: true,
            appliesOnHoliday: rule.appliesOnHoliday,
          ),
        )
        .toList(growable: false);
    final breakRules = _breakRules
        .where((rule) => rule.enabled)
        .map(
          (rule) => AdvancedBreakRule(
            id: rule.id,
            minutes: int.parse(rule.minutesText),
            enabled: true,
            shiftCategory: rule.shiftCategory,
          ),
        )
        .toList(growable: false);

    await ref
        .read(advancedPaySettingsControllerProvider.notifier)
        .saveRules(
          jobId: view.job.id,
          existingRuleSet: view.advancedPayRuleSet,
          overtimeRules: overtimeRules,
          editableDifferentialRules: editableDifferentials,
          allowanceRules: allowanceRules,
          breakRules: breakRules,
        );
  }

  List<String> _buildRuleSummaryLines() {
    final lines = <String>[];

    final enabledOvertime = _overtimeRules
        .where((rule) => rule.enabled)
        .toList();
    if (enabledOvertime.isEmpty) {
      lines.add(
        'No advanced overtime tiers yet. Basic overtime defaults still decide when extra pay starts.',
      );
    } else {
      for (final rule in enabledOvertime) {
        lines.add(
          '${rule.periodType == OvertimePeriodType.daily ? 'Daily' : 'Weekly'} overtime starts after ${rule.thresholdHoursText}h at ${rule.multiplierText}x.',
        );
      }
    }

    lines.add(_nightPreviewSummary);
    lines.add(_weekendPreviewSummary);

    final enabledAllowances = _allowanceRules
        .where((rule) => rule.enabled)
        .toList(growable: false);
    if (enabledAllowances.isEmpty) {
      lines.add(
        'No allowances configured. Matching shifts will only use hourly pay and differentials.',
      );
    } else {
      for (final rule in enabledAllowances) {
        final cadence = rule.type == AllowanceRuleType.perShift
            ? 'each matching shift'
            : 'the pay period';
        final holidayNote = rule.appliesOnHoliday ? ' on holidays only' : '';
        lines.add(
          '${_formatMinorUnits(_parseAmountText(rule.amountText))} is added to $cadence$holidayNote.',
        );
      }
    }

    final enabledBreaks = _breakRules
        .where((rule) => rule.enabled)
        .toList(growable: false);
    if (enabledBreaks.isEmpty) {
      lines.add(
        'No advanced break overrides yet. Existing template break deductions stay in charge.',
      );
    } else {
      for (final rule in enabledBreaks) {
        final scope = rule.shiftCategory == null
            ? 'all shifts'
            : '${_shiftCategoryLabel(rule.shiftCategory)} shifts';
        lines.add(
          '$scope deduct ${rule.minutesText} unpaid minutes before pay is calculated.',
        );
      }
    }

    return lines;
  }

  List<String> _buildPreviewLines(CurrencyAmount hourlyRate) {
    final lines = <String>[];

    final enabledOvertime = _overtimeRules.where((rule) => rule.enabled);
    for (final rule in enabledOvertime) {
      final multiplier = double.parse(rule.multiplierText);
      final amount = _applyMultiplier(hourlyRate.minorUnits, multiplier);
      lines.add(
        'Once ${rule.thresholdHoursText}h is crossed in the ${rule.periodType == OvertimePeriodType.daily ? 'day' : 'week'}, each extra hour would pay about ${_formatMinorUnits(amount, currencyCode: hourlyRate.currencyCode)}.',
      );
    }

    if (_nightRule.enabled) {
      lines.add(
        'Hours between ${_nightRule.startTimeText} and ${_nightRule.endTimeText} would move to about ${_formatMinorUnits(_applyMultiplier(hourlyRate.minorUnits, double.parse(_nightRule.multiplierText)), currencyCode: hourlyRate.currencyCode)} per hour.',
      );
    }
    if (_weekendRule.enabled) {
      final days = [
        if (_weekendRule.appliesOnSaturday) 'Saturday',
        if (_weekendRule.appliesOnSunday) 'Sunday',
      ].join(' and ');
      lines.add(
        '$days minutes would pay about ${_formatMinorUnits(_applyMultiplier(hourlyRate.minorUnits, double.parse(_weekendRule.multiplierText)), currencyCode: hourlyRate.currencyCode)} per hour.',
      );
    }

    for (final rule in _allowanceRules.where((entry) => entry.enabled)) {
      lines.add(
        '${_formatMinorUnits(_parseAmountText(rule.amountText), currencyCode: hourlyRate.currencyCode)} would be added ${rule.type == AllowanceRuleType.perShift ? 'to each matching shift' : 'once per pay period'}${rule.appliesOnHoliday ? ' when the pay period includes a holiday shift' : ''}.',
      );
    }

    for (final rule in _breakRules.where((entry) => entry.enabled)) {
      final baseMinutes = int.tryParse(rule.minutesText) ?? 0;
      final scope = rule.shiftCategory == null
          ? 'matching shifts'
          : '${_shiftCategoryLabel(rule.shiftCategory)} shifts';
      lines.add(
        '$scope would lose $baseMinutes unpaid minutes before overtime and differentials are applied.',
      );
    }

    if (lines.isEmpty) {
      lines.add(
        'Turn on a rule to preview how this job\'s hourly pay would change before you save.',
      );
    }

    return lines;
  }

  String get _nightPreviewSummary {
    if (!_nightRule.enabled) {
      return 'Night differential is off. Basic hourly pay still applies to overnight shifts.';
    }

    return 'Night minutes from ${_nightRule.startTimeText} to ${_nightRule.endTimeText} pay ${_nightRule.multiplierText}x with ${_combinationLabel(_nightRule.combinationMode)} behavior.';
  }

  String get _weekendPreviewSummary {
    if (!_weekendRule.enabled) {
      return 'Weekend differential is off. Saturday and Sunday use the basic rate unless another rule applies.';
    }

    final days = [
      if (_weekendRule.appliesOnSaturday) 'Saturday',
      if (_weekendRule.appliesOnSunday) 'Sunday',
    ];
    final label = days.isEmpty ? 'No selected days yet' : days.join(' and ');
    return '$label minutes pay ${_weekendRule.multiplierText}x with ${_combinationLabel(_weekendRule.combinationMode)} behavior.';
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.jobName,
    required this.entitlement,
    required this.onUpgrade,
  });

  final String jobName;
  final AppEntitlement entitlement;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.brMd,
                  color: theme.colorScheme.primaryContainer,
                ),
                child: Icon(
                  Icons.tune_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Advanced pay settings for $jobName',
                  style: theme.textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            entitlement.canAccess(AppFeature.advancedPayRules)
                ? 'Edit the core Premium rules that most directly change pay accuracy: overtime tiers plus night and weekend uplifts.'
                : 'Keep simple job defaults easy to scan, then layer Premium rules only when your rota or payslip complexity makes them worth it.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _TagChip(
                label: 'Simple defaults stay visible',
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              _TagChip(
                label: entitlement.canAccess(AppFeature.advancedPayRules)
                    ? 'Premium unlocked'
                    : 'Premium required to edit',
                color: entitlement.canAccess(AppFeature.advancedPayRules)
                    ? AppColors.success.withValues(alpha: 0.16)
                    : theme.colorScheme.primaryContainer,
              ),
            ],
          ),
          if (!entitlement.canAccess(AppFeature.advancedPayRules)) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onUpgrade,
              icon: const Icon(Icons.workspace_premium_outlined),
              label: const Text('Unlock advanced pay rules'),
            ),
          ],
        ],
      ),
    );
  }
}

class _SimpleDefaultsCard extends StatelessWidget {
  const _SimpleDefaultsCard({required this.view});

  final AdvancedPaySettingsViewData view;

  @override
  Widget build(BuildContext context) {
    final payRuleSet = view.payRuleSet;
    final holidayRuleSet = view.holidayRuleSet;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Simple pay defaults',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'These remain the fallback setup and do not get overwritten when you edit advanced rules.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _TagChip(
                label:
                    'Hourly ${MoneyFormatter.formatAmount(view.job.hourlyRate)}',
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              _TagChip(
                label:
                    'Daily OT ${_hoursLabel(payRuleSet?.overtimeThresholdDailyMinutes)}',
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              _TagChip(
                label:
                    'Weekly OT ${_hoursLabel(payRuleSet?.overtimeThresholdWeeklyMinutes)}',
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              _TagChip(
                label:
                    'OT rate ${_multiplierLabel(payRuleSet?.overtimeMultiplierBps)}',
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              _TagChip(
                label:
                    'Holiday ${_multiplierLabel(holidayRuleSet?.holidayMultiplierBps)}',
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GateMomentCard extends StatelessWidget {
  const _GateMomentCard({required this.onUpgrade});

  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Best time to gate Premium',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'This screen is the gate because it is a high-intent moment: the user already has a job and is asking for more accurate pay than the basic setup can provide.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onUpgrade,
            icon: const Icon(Icons.lock_open_outlined),
            label: const Text('See Premium options'),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyRulePreview extends StatelessWidget {
  const _ReadOnlyRulePreview({
    required this.overtimeCount,
    required this.nightEnabled,
    required this.weekendEnabled,
    required this.allowanceCount,
    required this.breakCount,
  });

  final int overtimeCount;
  final bool nightEnabled;
  final bool weekendEnabled;
  final int allowanceCount;
  final int breakCount;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What Premium unlocks here',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text('Overtime tiers ready to edit: $overtimeCount'),
          const SizedBox(height: 6),
          Text(
            'Night differential: ${nightEnabled ? 'Configured' : 'Not configured'}',
          ),
          const SizedBox(height: 6),
          Text(
            'Weekend differential: ${weekendEnabled ? 'Configured' : 'Not configured'}',
          ),
          const SizedBox(height: 6),
          Text('Allowance rules ready to edit: $allowanceCount'),
          const SizedBox(height: 6),
          Text('Advanced break overrides ready to edit: $breakCount'),
        ],
      ),
    );
  }
}

class _EditingSummaryCard extends StatelessWidget {
  const _EditingSummaryCard({
    required this.hasExistingRuleSet,
    required this.onAddTier,
  });

  final bool hasExistingRuleSet;
  final VoidCallback onAddTier;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Complete advanced pay flow',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            hasExistingRuleSet
                ? 'You can update saved overtime tiers, differentials, allowances, and break overrides here without changing the basic job setup.'
                : 'Start with the Premium rules that most often affect real shift-worker pay, then use the summaries below to confirm the setup makes sense before saving.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onAddTier,
            icon: const Icon(Icons.add),
            label: const Text('Add overtime tier'),
          ),
        ],
      ),
    );
  }
}

class _RuleSummaryCard extends StatelessWidget {
  const _RuleSummaryCard({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Readable rule summary',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'This turns the current setup into plain language so you can catch surprises before saving.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          for (final line in lines) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Icon(Icons.circle, size: 8),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(line)),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _PreviewImpactCard extends StatelessWidget {
  const _PreviewImpactCard({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pay impact preview',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'These examples use the current hourly rate for this job and explain how each active rule would change pay.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          for (final line in lines) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: AppRadius.brMd,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Text(line),
            ),
          ],
        ],
      ),
    );
  }
}

class _OvertimeEditorCard extends StatelessWidget {
  const _OvertimeEditorCard({
    required this.rules,
    required this.onAddTier,
    required this.onRemoveTier,
    required this.onChanged,
    required this.crossValidationMessage,
  });

  final List<_EditableOvertimeRule> rules;
  final VoidCallback onAddTier;
  final ValueChanged<String> onRemoveTier;
  final void Function(String, _EditableOvertimeRule) onChanged;
  final String? crossValidationMessage;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Overtime tiers',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              OutlinedButton.icon(
                onPressed: onAddTier,
                icon: const Icon(Icons.add),
                label: const Text('Add tier'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Build daily and weekly tiers in the order you want them explained. The screen will keep your basic overtime defaults untouched.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          for (final rule in rules) ...[
            _OvertimeTierFormRow(
              key: ValueKey(rule.id),
              rule: rule,
              onChanged: (next) => onChanged(rule.id, next),
              onRemove: rules.length > 1 ? () => onRemoveTier(rule.id) : null,
            ),
            const SizedBox(height: 12),
          ],
          if (crossValidationMessage != null)
            Text(
              crossValidationMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
    );
  }
}

class _OvertimeTierFormRow extends StatelessWidget {
  const _OvertimeTierFormRow({
    required this.rule,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final _EditableOvertimeRule rule;
  final ValueChanged<_EditableOvertimeRule> onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: AppRadius.brMd,
        color: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  dense: true,
                  value: rule.enabled,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Tier enabled'),
                  onChanged: (value) =>
                      onChanged(rule.copyWith(enabled: value)),
                ),
              ),
              if (onRemove != null)
                IconButton(
                  onPressed: onRemove,
                  tooltip: 'Remove tier',
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<OvertimePeriodType>(
            initialValue: rule.periodType,
            decoration: const InputDecoration(
              labelText: 'Tier type',
              border: OutlineInputBorder(),
              helperText:
                  'Choose whether this tier applies per day or per week.',
            ),
            items: const [
              DropdownMenuItem(
                value: OvertimePeriodType.daily,
                child: Text('Daily'),
              ),
              DropdownMenuItem(
                value: OvertimePeriodType.weekly,
                child: Text('Weekly'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                onChanged(rule.copyWith(periodType: value));
              }
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: ValueKey('overtime-threshold-${rule.id}'),
            initialValue: rule.thresholdHoursText,
            decoration: const InputDecoration(
              labelText: 'Threshold (hours)',
              border: OutlineInputBorder(),
              helperText: 'How many worked hours trigger this tier?',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) =>
                !rule.enabled ? null : _validatePositiveDecimal(value),
            onChanged: (value) =>
                onChanged(rule.copyWith(thresholdHoursText: value)),
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: ValueKey('overtime-multiplier-${rule.id}'),
            initialValue: rule.multiplierText,
            decoration: const InputDecoration(
              labelText: 'Multiplier',
              border: OutlineInputBorder(),
              helperText: 'Example: 1.5 means time-and-a-half.',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              final parsed = double.tryParse(value ?? '');
              if (parsed == null || parsed < 1) {
                return 'Enter a multiplier of at least 1.0';
              }
              return null;
            },
            onChanged: (value) =>
                onChanged(rule.copyWith(multiplierText: value)),
          ),
        ],
      ),
    );
  }
}

class _DifferentialEditorCard extends StatelessWidget {
  const _DifferentialEditorCard({
    required this.title,
    required this.description,
    required this.rule,
    required this.onChanged,
    required this.defaultDaysLabel,
    required this.sampleSummary,
  });

  final String title;
  final String description;
  final _EditableDifferentialRule rule;
  final ValueChanged<_EditableDifferentialRule> onChanged;
  final String defaultDaysLabel;
  final String sampleSummary;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: rule.enabled,
            contentPadding: EdgeInsets.zero,
            title: Text('Enable $title'),
            subtitle: Text(
              rule.enabled
                  ? 'This premium will affect pay after save.'
                  : 'This premium stays off until enabled.',
            ),
            onChanged: (value) => onChanged(rule.copyWith(enabled: value)),
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: ValueKey('${rule.type.name}-multiplier'),
            initialValue: rule.multiplierText,
            decoration: const InputDecoration(
              labelText: 'Multiplier',
              border: OutlineInputBorder(),
              helperText: 'How much should qualifying minutes pay?',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (!rule.enabled) {
                return null;
              }
              final parsed = double.tryParse(value ?? '');
              if (parsed == null || parsed < 1) {
                return 'Enter a multiplier of at least 1.0';
              }
              return null;
            },
            onChanged: (value) =>
                onChanged(rule.copyWith(multiplierText: value)),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<DifferentialCombinationMode>(
            initialValue: rule.combinationMode,
            decoration: const InputDecoration(
              labelText: 'Combination mode',
              border: OutlineInputBorder(),
              helperText:
                  'Choose whether this premium stacks or only keeps the highest uplift.',
            ),
            items: const [
              DropdownMenuItem(
                value: DifferentialCombinationMode.additivePremium,
                child: Text('Additive premium'),
              ),
              DropdownMenuItem(
                value: DifferentialCombinationMode.exclusiveHighestWins,
                child: Text('Highest premium wins'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                onChanged(rule.copyWith(combinationMode: value));
              }
            },
          ),
          if (rule.type == DifferentialRuleType.night) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: const ValueKey('night-start-time'),
                    initialValue: rule.startTimeText,
                    decoration: const InputDecoration(
                      labelText: 'Start time',
                      border: OutlineInputBorder(),
                      helperText: '24h format, e.g. 22:00',
                    ),
                    validator: (value) =>
                        !rule.enabled ? null : _validateTimeText(value),
                    onChanged: (value) =>
                        onChanged(rule.copyWith(startTimeText: value)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    key: const ValueKey('night-end-time'),
                    initialValue: rule.endTimeText,
                    decoration: const InputDecoration(
                      labelText: 'End time',
                      border: OutlineInputBorder(),
                      helperText: '24h format, e.g. 06:00',
                    ),
                    validator: (value) {
                      if (!rule.enabled) {
                        return null;
                      }
                      final base = _validateTimeText(value);
                      if (base != null) {
                        return base;
                      }
                      if (value == rule.startTimeText) {
                        return 'Start and end times must differ';
                      }
                      return null;
                    },
                    onChanged: (value) =>
                        onChanged(rule.copyWith(endTimeText: value)),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 12),
            Text(
              defaultDaysLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: rule.appliesOnSaturday,
              title: const Text('Saturday'),
              onChanged: (value) =>
                  onChanged(rule.copyWith(appliesOnSaturday: value ?? false)),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: rule.appliesOnSunday,
              title: const Text('Sunday'),
              subtitle:
                  rule.enabled &&
                      !rule.appliesOnSaturday &&
                      !rule.appliesOnSunday
                  ? Text(
                      'Choose at least one weekend day.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  : null,
              onChanged: (value) =>
                  onChanged(rule.copyWith(appliesOnSunday: value ?? false)),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: AppRadius.brMd,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Text(sampleSummary),
          ),
        ],
      ),
    );
  }
}

class _AllowanceEditorCard extends StatelessWidget {
  const _AllowanceEditorCard({
    required this.rules,
    required this.onAddRule,
    required this.onRemoveRule,
    required this.onChanged,
  });

  final List<_EditableAllowanceRule> rules;
  final VoidCallback onAddRule;
  final ValueChanged<String> onRemoveRule;
  final void Function(String, _EditableAllowanceRule) onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Allowances',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              OutlinedButton.icon(
                onPressed: onAddRule,
                icon: const Icon(Icons.add),
                label: const Text('Add allowance'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Use flat additions for things like meal allowances, travel support, or fixed premiums that do not depend on worked minutes.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          for (final rule in rules) ...[
            _AllowanceFormRow(
              key: ValueKey(rule.id),
              rule: rule,
              onChanged: (next) => onChanged(rule.id, next),
              onRemove: rules.length > 1 ? () => onRemoveRule(rule.id) : null,
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _AllowanceFormRow extends StatelessWidget {
  const _AllowanceFormRow({
    required this.rule,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final _EditableAllowanceRule rule;
  final ValueChanged<_EditableAllowanceRule> onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: AppRadius.brMd,
        color: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  dense: true,
                  value: rule.enabled,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Allowance enabled'),
                  onChanged: (value) =>
                      onChanged(rule.copyWith(enabled: value)),
                ),
              ),
              if (onRemove != null)
                IconButton(
                  onPressed: onRemove,
                  tooltip: 'Remove allowance',
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<AllowanceRuleType>(
            initialValue: rule.type,
            decoration: const InputDecoration(
              labelText: 'Trigger',
              border: OutlineInputBorder(),
              helperText: 'Apply this once per shift or once per pay period.',
            ),
            items: const [
              DropdownMenuItem(
                value: AllowanceRuleType.perShift,
                child: Text('Per shift'),
              ),
              DropdownMenuItem(
                value: AllowanceRuleType.perPeriod,
                child: Text('Per pay period'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                onChanged(rule.copyWith(type: value));
              }
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: ValueKey('allowance-amount-${rule.id}'),
            initialValue: rule.amountText,
            decoration: const InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
              helperText: 'Example: 18.00',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) =>
                !rule.enabled ? null : _validateMoneyAmount(value),
            onChanged: (value) => onChanged(rule.copyWith(amountText: value)),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: rule.appliesOnHoliday,
            title: const Text('Holiday-only trigger'),
            subtitle: const Text(
              'Turn this on when the allowance should only apply on holiday shifts or pay periods that include one.',
            ),
            onChanged: (value) =>
                onChanged(rule.copyWith(appliesOnHoliday: value ?? false)),
          ),
        ],
      ),
    );
  }
}

class _BreakEditorCard extends StatelessWidget {
  const _BreakEditorCard({
    required this.rules,
    required this.onAddRule,
    required this.onRemoveRule,
    required this.onChanged,
    required this.validationMessage,
  });

  final List<_EditableBreakRule> rules;
  final VoidCallback onAddRule;
  final ValueChanged<String> onRemoveRule;
  final void Function(String, _EditableBreakRule) onChanged;
  final String? validationMessage;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Break deductions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              OutlinedButton.icon(
                onPressed: onAddRule,
                icon: const Icon(Icons.add),
                label: const Text('Add break rule'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Override unpaid break deductions when some shift types should lose more or less time before pay is calculated.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          for (final rule in rules) ...[
            _BreakRuleFormRow(
              key: ValueKey(rule.id),
              rule: rule,
              onChanged: (next) => onChanged(rule.id, next),
              onRemove: rules.length > 1 ? () => onRemoveRule(rule.id) : null,
            ),
            const SizedBox(height: 12),
          ],
          if (validationMessage != null)
            Text(
              validationMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
    );
  }
}

class _BreakRuleFormRow extends StatelessWidget {
  const _BreakRuleFormRow({
    required this.rule,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final _EditableBreakRule rule;
  final ValueChanged<_EditableBreakRule> onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: AppRadius.brMd,
        color: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  dense: true,
                  value: rule.enabled,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Break override enabled'),
                  onChanged: (value) =>
                      onChanged(rule.copyWith(enabled: value)),
                ),
              ),
              if (onRemove != null)
                IconButton(
                  onPressed: onRemove,
                  tooltip: 'Remove break rule',
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            key: ValueKey('break-minutes-${rule.id}'),
            initialValue: rule.minutesText,
            decoration: const InputDecoration(
              labelText: 'Unpaid break minutes',
              border: OutlineInputBorder(),
              helperText: 'Example: 30 or 45.',
            ),
            keyboardType: TextInputType.number,
            validator: (value) =>
                !rule.enabled ? null : _validateBreakMinutes(value),
            onChanged: (value) => onChanged(rule.copyWith(minutesText: value)),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<ShiftCategory?>(
            initialValue: rule.shiftCategory,
            decoration: const InputDecoration(
              labelText: 'Scope',
              border: OutlineInputBorder(),
              helperText:
                  'Choose whether this applies to all shifts or only a shift category.',
            ),
            items: const [
              DropdownMenuItem<ShiftCategory?>(
                value: null,
                child: Text('All shifts'),
              ),
              DropdownMenuItem<ShiftCategory?>(
                value: ShiftCategory.day,
                child: Text('Day shifts'),
              ),
              DropdownMenuItem<ShiftCategory?>(
                value: ShiftCategory.evening,
                child: Text('Evening shifts'),
              ),
              DropdownMenuItem<ShiftCategory?>(
                value: ShiftCategory.night,
                child: Text('Night shifts'),
              ),
              DropdownMenuItem<ShiftCategory?>(
                value: ShiftCategory.custom,
                child: Text('Custom shifts'),
              ),
            ],
            onChanged: (value) => onChanged(
              rule.copyWith(shiftCategory: value, setShiftCategory: true),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineStatusCard extends StatelessWidget {
  const _InlineStatusCard({
    required this.title,
    required this.body,
    required this.isError,
  });

  final String title;
  final String body;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = isError
        ? scheme.errorContainer
        : scheme.surfaceContainerHighest;
    final foreground = isError ? scheme.onErrorContainer : scheme.onSurface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: AppRadius.brMd,
        color: background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: foreground),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color,
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

class _EditableOvertimeRule {
  const _EditableOvertimeRule({
    required this.id,
    required this.periodType,
    required this.thresholdHoursText,
    required this.multiplierText,
    required this.enabled,
  });

  final String id;
  final OvertimePeriodType periodType;
  final String thresholdHoursText;
  final String multiplierText;
  final bool enabled;

  _EditableOvertimeRule copyWith({
    OvertimePeriodType? periodType,
    String? thresholdHoursText,
    String? multiplierText,
    bool? enabled,
  }) {
    return _EditableOvertimeRule(
      id: id,
      periodType: periodType ?? this.periodType,
      thresholdHoursText: thresholdHoursText ?? this.thresholdHoursText,
      multiplierText: multiplierText ?? this.multiplierText,
      enabled: enabled ?? this.enabled,
    );
  }
}

class _EditableDifferentialRule {
  const _EditableDifferentialRule({
    required this.id,
    required this.type,
    required this.enabled,
    required this.multiplierText,
    required this.combinationMode,
    required this.startTimeText,
    required this.endTimeText,
    required this.appliesOnSaturday,
    required this.appliesOnSunday,
  });

  final String id;
  final DifferentialRuleType type;
  final bool enabled;
  final String multiplierText;
  final DifferentialCombinationMode combinationMode;
  final String startTimeText;
  final String endTimeText;
  final bool appliesOnSaturday;
  final bool appliesOnSunday;

  _EditableDifferentialRule copyWith({
    bool? enabled,
    String? multiplierText,
    DifferentialCombinationMode? combinationMode,
    String? startTimeText,
    String? endTimeText,
    bool? appliesOnSaturday,
    bool? appliesOnSunday,
  }) {
    return _EditableDifferentialRule(
      id: id,
      type: type,
      enabled: enabled ?? this.enabled,
      multiplierText: multiplierText ?? this.multiplierText,
      combinationMode: combinationMode ?? this.combinationMode,
      startTimeText: startTimeText ?? this.startTimeText,
      endTimeText: endTimeText ?? this.endTimeText,
      appliesOnSaturday: appliesOnSaturday ?? this.appliesOnSaturday,
      appliesOnSunday: appliesOnSunday ?? this.appliesOnSunday,
    );
  }
}

class _EditableAllowanceRule {
  const _EditableAllowanceRule({
    required this.id,
    required this.type,
    required this.amountText,
    required this.enabled,
    required this.appliesOnHoliday,
  });

  final String id;
  final AllowanceRuleType type;
  final String amountText;
  final bool enabled;
  final bool appliesOnHoliday;

  _EditableAllowanceRule copyWith({
    AllowanceRuleType? type,
    String? amountText,
    bool? enabled,
    bool? appliesOnHoliday,
  }) {
    return _EditableAllowanceRule(
      id: id,
      type: type ?? this.type,
      amountText: amountText ?? this.amountText,
      enabled: enabled ?? this.enabled,
      appliesOnHoliday: appliesOnHoliday ?? this.appliesOnHoliday,
    );
  }
}

class _EditableBreakRule {
  const _EditableBreakRule({
    required this.id,
    required this.minutesText,
    required this.enabled,
    required this.shiftCategory,
  });

  final String id;
  final String minutesText;
  final bool enabled;
  final ShiftCategory? shiftCategory;

  _EditableBreakRule copyWith({
    String? minutesText,
    bool? enabled,
    ShiftCategory? shiftCategory,
    bool setShiftCategory = false,
  }) {
    return _EditableBreakRule(
      id: id,
      minutesText: minutesText ?? this.minutesText,
      enabled: enabled ?? this.enabled,
      shiftCategory: setShiftCategory
          ? shiftCategory
          : shiftCategory ?? this.shiftCategory,
    );
  }
}

String _hoursLabel(int? minutes) {
  if (minutes == null || minutes <= 0) {
    return 'Not set';
  }

  final hours = minutes / 60;
  return hours == hours.roundToDouble()
      ? '${hours.toInt()}h'
      : '${hours.toStringAsFixed(1)}h';
}

String _multiplierLabel(int? multiplierBps) {
  if (multiplierBps == null || multiplierBps <= 0) {
    return 'Not set';
  }

  return '${(multiplierBps / 10000).toStringAsFixed(2)}x';
}

String _hoursTextFromMinutes(int minutes) {
  final hours = minutes / 60;
  return hours == hours.roundToDouble()
      ? '${hours.toInt()}'
      : hours.toStringAsFixed(2);
}

String _multiplierText(int multiplierBps) =>
    (multiplierBps / 10000).toStringAsFixed(2);

String _amountText(int amountMinor) => (amountMinor / 100).toStringAsFixed(2);

String _timeText(int totalMinutes) {
  final hours = (totalMinutes ~/ 60).toString().padLeft(2, '0');
  final minutes = (totalMinutes % 60).toString().padLeft(2, '0');
  return '$hours:$minutes';
}

String _combinationLabel(DifferentialCombinationMode mode) {
  return switch (mode) {
    DifferentialCombinationMode.additivePremium => 'stacking',
    DifferentialCombinationMode.exclusiveHighestWins => 'highest-wins',
  };
}

String _shiftCategoryLabel(ShiftCategory? category) {
  return switch (category) {
    ShiftCategory.day => 'Day',
    ShiftCategory.evening => 'Evening',
    ShiftCategory.night => 'Night',
    ShiftCategory.custom => 'Custom',
    null => 'All',
  };
}

String? _validatePositiveDecimal(String? value) {
  final parsed = double.tryParse(value ?? '');
  if (parsed == null || parsed <= 0) {
    return 'Enter a value greater than zero';
  }
  return null;
}

String? _validateMoneyAmount(String? value) {
  final parsed = double.tryParse(value ?? '');
  if (parsed == null || parsed <= 0) {
    return 'Enter an amount greater than zero';
  }
  return null;
}

String? _validateBreakMinutes(String? value) {
  final parsed = int.tryParse(value ?? '');
  if (parsed == null || parsed <= 0) {
    return 'Enter break minutes greater than zero';
  }
  if (parsed > 12 * 60) {
    return 'Break override looks too large';
  }
  return null;
}

String? _validateTimeText(String? value) {
  final raw = value?.trim() ?? '';
  final match = RegExp(r'^\d{2}:\d{2}$').firstMatch(raw);
  if (match == null) {
    return 'Use HH:MM format';
  }

  final hours = int.parse(raw.substring(0, 2));
  final minutes = int.parse(raw.substring(3, 5));
  if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
    return 'Enter a valid 24-hour time';
  }
  return null;
}

int _parseTimeText(String value) {
  final hours = int.parse(value.substring(0, 2));
  final minutes = int.parse(value.substring(3, 5));
  return (hours * 60) + minutes;
}

int _parseAmountText(String value) => (double.parse(value) * 100).round();

int _applyMultiplier(int baseMinor, double multiplier) =>
    (baseMinor * multiplier).round();

String _formatMinorUnits(int amountMinor, {String currencyCode = 'USD'}) {
  return MoneyFormatter.formatAmount(
    CurrencyAmount(minorUnits: amountMinor, currencyCode: currencyCode),
  );
}

extension IterableHelpers<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;

  Iterable<R> mapIndexed<R>(R Function(int index, T item) convert) sync* {
    var index = 0;
    for (final item in this) {
      yield convert(index, item);
      index++;
    }
  }
}
