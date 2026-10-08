import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shiftmate_pay/core/common/identifiers.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/data/local/database/app_database.dart';
import 'package:shiftmate_pay/data/local/database/database_providers.dart';
import 'package:shiftmate_pay/data/repositories/drift_advanced_pay_rule_set_repository.dart';
import 'package:shiftmate_pay/domain/entities/advanced_pay_rule_set.dart';
import 'package:shiftmate_pay/features/pay/application/advanced_pay_settings_controller.dart';

void main() {
  test(
    'controller saves overtime, differential, allowance, and break rules end to end',
    () async {
      final database = AppDatabase(executor: NativeDatabase.memory());
      final repository = DriftAdvancedPayRuleSetRepository(database);
      final jobId = AppId.generate();
      final existingRuleSet = AdvancedPayRuleSet(
        id: AppId.generate(),
        jobId: jobId,
        enabled: true,
        overtimeRules: const [
          OvertimeTierRule(
            id: 'daily_1',
            periodType: OvertimePeriodType.daily,
            thresholdMinutes: 480,
            multiplierBps: 15000,
            priority: 1,
            enabled: true,
          ),
        ],
        differentialRules: const [],
        allowanceRules: const [],
        breakRules: const [],
        version: 1,
        createdAt: DateTime.utc(2026, 4, 4),
        updatedAt: DateTime.utc(2026, 4, 4),
      );
      await repository.save(existingRuleSet);

      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
      );
      addTearDown(container.dispose);
      addTearDown(database.close);

      await container
          .read(advancedPaySettingsControllerProvider.notifier)
          .saveRules(
            jobId: jobId,
            existingRuleSet: existingRuleSet,
            overtimeRules: const [
              OvertimeTierRule(
                id: 'daily_1',
                periodType: OvertimePeriodType.daily,
                thresholdMinutes: 600,
                multiplierBps: 17500,
                priority: 1,
                enabled: true,
              ),
              OvertimeTierRule(
                id: 'weekly_1',
                periodType: OvertimePeriodType.weekly,
                thresholdMinutes: 2400,
                multiplierBps: 20000,
                priority: 2,
                enabled: true,
              ),
            ],
            editableDifferentialRules: const [
              DifferentialPayRule(
                id: 'night_1',
                type: DifferentialRuleType.night,
                combinationMode: DifferentialCombinationMode.additivePremium,
                enabled: true,
                multiplierBps: 12000,
                startMinutesLocal: 21 * 60,
                endMinutesLocal: 5 * 60,
              ),
              DifferentialPayRule(
                id: 'weekend_1',
                type: DifferentialRuleType.weekend,
                combinationMode: DifferentialCombinationMode.additivePremium,
                enabled: true,
                multiplierBps: 13000,
                appliesOnSaturday: true,
                appliesOnSunday: true,
              ),
            ],
            allowanceRules: const [
              AllowancePayRule(
                id: 'allowance_1',
                type: AllowanceRuleType.perShift,
                amountMinor: 1800,
                enabled: true,
                appliesOnHoliday: true,
              ),
            ],
            breakRules: const [
              AdvancedBreakRule(
                id: 'break_1',
                minutes: 45,
                enabled: true,
                shiftCategory: ShiftCategory.night,
              ),
            ],
          );

      final savedState = container.read(advancedPaySettingsControllerProvider);
      expect(savedState.isSaving, isFalse);
      expect(savedState.errorMessage, isNull);
      expect(savedState.savedAt, isNotNull);

      final loaded = await repository.getForJob(jobId);
      final ruleSet = loaded.when(
        success: (value) => value,
        failure: (error) => throw error,
      );

      expect(ruleSet, isNotNull);
      expect(ruleSet!.overtimeRules, hasLength(2));
      expect(ruleSet.overtimeRules.first.thresholdMinutes, 600);
      expect(ruleSet.overtimeRules.last.periodType, OvertimePeriodType.weekly);
      expect(
        ruleSet.differentialRules.where(
          (rule) => rule.type == DifferentialRuleType.night,
        ),
        hasLength(1),
      );
      expect(
        ruleSet.differentialRules.where(
          (rule) => rule.type == DifferentialRuleType.weekend,
        ),
        hasLength(1),
      );
      expect(ruleSet.allowanceRules, hasLength(1));
      expect(ruleSet.allowanceRules.single.amountMinor, 1800);
      expect(ruleSet.breakRules, hasLength(1));
      expect(ruleSet.breakRules.single.shiftCategory, ShiftCategory.night);
    },
  );
}
