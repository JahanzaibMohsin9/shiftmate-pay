import '../../core/common/shared_types.dart';
import '../entities/advanced_pay_rule_set.dart';
import '../entities/shift_instance.dart';

class AdvancedBreakResolver {
  const AdvancedBreakResolver();

  Minutes resolve({
    required ShiftInstance shift,
    required List<AdvancedBreakRule> rules,
  }) {
    final enabledRules = rules.where((rule) => rule.enabled).toList(growable: false);
    if (enabledRules.isEmpty) {
      return _sanitize(shift.unpaidBreakMinutes);
    }

    final templateId = shift.templateSnapshot?.templateId;
    final category = shift.templateSnapshot?.category;

    for (final rule in enabledRules) {
      if (rule.shiftTemplateId != null && rule.shiftTemplateId == templateId) {
        return _sanitize(rule.minutes);
      }
    }
    for (final rule in enabledRules) {
      if (rule.shiftTemplateId == null &&
          rule.shiftCategory != null &&
          rule.shiftCategory == category) {
        return _sanitize(rule.minutes);
      }
    }

    return _sanitize(shift.unpaidBreakMinutes);
  }

  Minutes _sanitize(Minutes value) => value < 0 ? 0 : value;
}
