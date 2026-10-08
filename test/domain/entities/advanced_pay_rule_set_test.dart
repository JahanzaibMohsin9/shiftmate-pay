import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/common/identifiers.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/domain/entities/advanced_pay_rule_set.dart';

void main() {
  test('copyWith preserves lists and updates selected fields', () {
    final now = DateTime.utc(2026, 4, 4);
    final original = AdvancedPayRuleSet(
      id: AppId.generate(),
      jobId: AppId.generate(),
      enabled: true,
      overtimeRules: const [
        OvertimeTierRule(
          id: 'ot_1',
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
      createdAt: now,
      updatedAt: now,
    );

    final updated = original.copyWith(
      enabled: false,
      version: 2,
      updatedAt: now.add(const Duration(days: 1)),
    );

    expect(updated.id, original.id);
    expect(updated.jobId, original.jobId);
    expect(updated.enabled, isFalse);
    expect(updated.version, 2);
    expect(updated.overtimeRules, hasLength(1));
    expect(updated.updatedAt, now.add(const Duration(days: 1)));
  });
}
