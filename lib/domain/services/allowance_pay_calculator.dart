import '../../core/common/shared_types.dart';
import '../entities/advanced_pay_rule_set.dart';
import '../entities/shift_instance.dart';
import 'pay_calculation_models.dart';

class AllowancePayCalculator {
  const AllowancePayCalculator();

  List<AllowancePayItem> calculate({
    required List<ShiftInstance> shifts,
    required List<AllowancePayRule> rules,
  }) {
    if (rules.isEmpty || shifts.isEmpty) {
      return const [];
    }

    final items = <AllowancePayItem>[];
    for (final rule in rules.where((rule) => rule.enabled)) {
      final qualifyingShifts = shifts.where((shift) => _matches(rule, shift)).toList(growable: false);
      if (qualifyingShifts.isEmpty) {
        continue;
      }

      final appliedCount = rule.type == AllowanceRuleType.perPeriod ? 1 : qualifyingShifts.length;
      items.add(
        AllowancePayItem(
          ruleId: rule.id,
          type: rule.type,
          amountMinor: rule.amountMinor * appliedCount,
          appliedCount: appliedCount,
        ),
      );
    }

    return items;
  }

  bool _matches(AllowancePayRule rule, ShiftInstance shift) {
    if (rule.appliesOnHoliday && !shift.isHoliday) {
      return false;
    }
    if (rule.shiftTemplateId != null && shift.templateSnapshot?.templateId != rule.shiftTemplateId) {
      return false;
    }
    return true;
  }
}
