import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/identifiers.dart';
import '../../../core/common/shared_types.dart';
import '../../../domain/entities/advanced_pay_rule_set.dart';
import '../../../data/local/database/database_providers.dart';
import 'advanced_pay_settings_providers.dart';
import 'pay_providers.dart';

class AdvancedPaySettingsState {
  const AdvancedPaySettingsState({
    this.isSaving = false,
    this.errorMessage,
    this.savedAt,
  });

  final bool isSaving;
  final String? errorMessage;
  final DateTime? savedAt;

  AdvancedPaySettingsState copyWith({
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
    DateTime? savedAt,
  }) {
    return AdvancedPaySettingsState(
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}

class AdvancedPaySettingsController
    extends StateNotifier<AdvancedPaySettingsState> {
  AdvancedPaySettingsController(this._ref)
    : super(const AdvancedPaySettingsState());

  final Ref _ref;

  Future<void> saveRules({
    required String jobId,
    required AdvancedPayRuleSet? existingRuleSet,
    required List<OvertimeTierRule> overtimeRules,
    required List<DifferentialPayRule> editableDifferentialRules,
    required List<AllowancePayRule> allowanceRules,
    required List<AdvancedBreakRule> breakRules,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final repository = _ref.read(advancedPayRuleSetRepositoryProvider);
      final preservedDifferentials =
          existingRuleSet?.differentialRules
              .where(
                (rule) =>
                    rule.type != DifferentialRuleType.night &&
                    rule.type != DifferentialRuleType.weekend,
              )
              .toList(growable: false) ??
          const <DifferentialPayRule>[];

      final allDifferentials = [
        ...editableDifferentialRules,
        ...preservedDifferentials,
      ];
      final now = DateTime.now().toUtc();
      final nextRuleSet =
          (existingRuleSet ??
                  AdvancedPayRuleSet(
                    id: AppId.generate(),
                    jobId: jobId,
                    enabled: false,
                    overtimeRules: const [],
                    differentialRules: const [],
                    allowanceRules: const [],
                    breakRules: const [],
                    version: 1,
                    createdAt: now,
                    updatedAt: now,
                  ))
              .copyWith(
                enabled:
                    overtimeRules.isNotEmpty ||
                    allDifferentials.isNotEmpty ||
                    allowanceRules.isNotEmpty ||
                    breakRules.isNotEmpty,
                overtimeRules: overtimeRules,
                differentialRules: allDifferentials,
                allowanceRules: allowanceRules,
                breakRules: breakRules,
                version: (existingRuleSet?.version ?? 0) + 1,
                updatedAt: now,
              );

      final result = await repository.save(nextRuleSet);
      result.when(success: (_) {}, failure: (error) => throw error);

      _ref.invalidate(advancedPaySettingsViewProvider(jobId));
      _ref.invalidate(paySummaryProvider);
      state = AdvancedPaySettingsState(
        isSaving: false,
        savedAt: DateTime.now(),
      );
    } catch (error) {
      state = state.copyWith(isSaving: false, errorMessage: error.toString());
    }
  }
}

final advancedPaySettingsControllerProvider =
    StateNotifierProvider<
      AdvancedPaySettingsController,
      AdvancedPaySettingsState
    >(AdvancedPaySettingsController.new);
