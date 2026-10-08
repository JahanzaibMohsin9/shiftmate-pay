import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';

class AdvancedPayRuleSet {
  const AdvancedPayRuleSet({
    required this.id,
    required this.jobId,
    required this.enabled,
    required this.overtimeRules,
    required this.differentialRules,
    required this.allowanceRules,
    required this.breakRules,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  final EntityId id;
  final EntityId jobId;
  final bool enabled;
  final List<OvertimeTierRule> overtimeRules;
  final List<DifferentialPayRule> differentialRules;
  final List<AllowancePayRule> allowanceRules;
  final List<AdvancedBreakRule> breakRules;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdvancedPayRuleSet copyWith({
    EntityId? id,
    EntityId? jobId,
    bool? enabled,
    List<OvertimeTierRule>? overtimeRules,
    List<DifferentialPayRule>? differentialRules,
    List<AllowancePayRule>? allowanceRules,
    List<AdvancedBreakRule>? breakRules,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdvancedPayRuleSet(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      enabled: enabled ?? this.enabled,
      overtimeRules: overtimeRules ?? this.overtimeRules,
      differentialRules: differentialRules ?? this.differentialRules,
      allowanceRules: allowanceRules ?? this.allowanceRules,
      breakRules: breakRules ?? this.breakRules,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class OvertimeTierRule {
  const OvertimeTierRule({
    required this.id,
    required this.periodType,
    required this.thresholdMinutes,
    required this.multiplierBps,
    required this.priority,
    required this.enabled,
  });

  final EntityId id;
  final OvertimePeriodType periodType;
  final Minutes thresholdMinutes;
  final int multiplierBps;
  final int priority;
  final bool enabled;
}

class DifferentialPayRule {
  const DifferentialPayRule({
    required this.id,
    required this.type,
    required this.combinationMode,
    required this.enabled,
    this.multiplierBps,
    this.flatAmountMinor,
    this.startMinutesLocal,
    this.endMinutesLocal,
    this.appliesOnSaturday = false,
    this.appliesOnSunday = false,
    this.shiftTemplateId,
  });

  final EntityId id;
  final DifferentialRuleType type;
  final DifferentialCombinationMode combinationMode;
  final bool enabled;
  final int? multiplierBps;
  final MinorUnits? flatAmountMinor;
  final Minutes? startMinutesLocal;
  final Minutes? endMinutesLocal;
  final bool appliesOnSaturday;
  final bool appliesOnSunday;
  final EntityId? shiftTemplateId;
}

class AllowancePayRule {
  const AllowancePayRule({
    required this.id,
    required this.type,
    required this.amountMinor,
    required this.enabled,
    this.appliesOnHoliday = false,
    this.shiftTemplateId,
  });

  final EntityId id;
  final AllowanceRuleType type;
  final MinorUnits amountMinor;
  final bool enabled;
  final bool appliesOnHoliday;
  final EntityId? shiftTemplateId;
}

class AdvancedBreakRule {
  const AdvancedBreakRule({
    required this.id,
    required this.minutes,
    required this.enabled,
    this.shiftTemplateId,
    this.shiftCategory,
  });

  final EntityId id;
  final Minutes minutes;
  final bool enabled;
  final EntityId? shiftTemplateId;
  final ShiftCategory? shiftCategory;
}
