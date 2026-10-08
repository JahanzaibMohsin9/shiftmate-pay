import '../../core/common/shared_types.dart';

enum PayLineItemType {
  base,
  overtime,
  holidayPremium,
  differential,
  allowance,
}

class PayLineItem {
  const PayLineItem({
    required this.type,
    required this.label,
    required this.minutes,
    required this.rateMinorPerHour,
    required this.multiplierBps,
    required this.amountMinor,
  });

  final PayLineItemType type;
  final String label;
  final Minutes minutes;
  final MinorUnits rateMinorPerHour;
  final int multiplierBps;
  final MinorUnits amountMinor;
}

class PayBreakdown {
  const PayBreakdown({
    required this.totalWorkedMinutes,
    required this.baseMinutes,
    required this.overtimeMinutes,
    required this.holidayMinutes,
    required this.differentialMinutes,
    required this.basePayMinor,
    required this.overtimePayMinor,
    required this.holidayPayMinor,
    required this.differentialPayMinor,
    required this.allowancePayMinor,
    required this.grossPayMinor,
    required this.lineItems,
  });

  final Minutes totalWorkedMinutes;
  final Minutes baseMinutes;
  final Minutes overtimeMinutes;
  final Minutes holidayMinutes;
  final Minutes differentialMinutes;
  final MinorUnits basePayMinor;
  final MinorUnits overtimePayMinor;
  final MinorUnits holidayPayMinor;
  final MinorUnits differentialPayMinor;
  final MinorUnits allowancePayMinor;
  final MinorUnits grossPayMinor;
  final List<PayLineItem> lineItems;
}

class OvertimeAllocation {
  const OvertimeAllocation({
    required this.totalMinutes,
    required this.baseMinutes,
    required this.dailyOvertimeMinutes,
    required this.weeklyOvertimeMinutes,
  });

  final Minutes totalMinutes;
  final Minutes baseMinutes;
  final Minutes dailyOvertimeMinutes;
  final Minutes weeklyOvertimeMinutes;

  Minutes get overtimeMinutes => dailyOvertimeMinutes + weeklyOvertimeMinutes;
}

class OvertimeTierAllocation {
  const OvertimeTierAllocation({
    required this.ruleId,
    required this.periodType,
    required this.multiplierBps,
    required this.minutes,
    required this.priority,
  });

  final String ruleId;
  final OvertimePeriodType periodType;
  final int multiplierBps;
  final Minutes minutes;
  final int priority;
}

class AdvancedOvertimeAllocation {
  const AdvancedOvertimeAllocation({
    required this.totalMinutes,
    required this.baseMinutes,
    required this.tierAllocations,
  });

  final Minutes totalMinutes;
  final Minutes baseMinutes;
  final List<OvertimeTierAllocation> tierAllocations;

  Minutes get overtimeMinutes =>
      tierAllocations.fold<Minutes>(0, (sum, item) => sum + item.minutes);
}

class DifferentialPayItem {
  const DifferentialPayItem({
    required this.ruleId,
    required this.type,
    required this.minutes,
    required this.amountMinor,
  });

  final String ruleId;
  final DifferentialRuleType type;
  final Minutes minutes;
  final MinorUnits amountMinor;
}

class AllowancePayItem {
  const AllowancePayItem({
    required this.ruleId,
    required this.type,
    required this.amountMinor,
    required this.appliedCount,
  });

  final String ruleId;
  final AllowanceRuleType type;
  final MinorUnits amountMinor;
  final int appliedCount;
}

class ShiftPayInput {
  const ShiftPayInput({
    required this.instance,
    required this.paidMinutes,
  });

  final dynamic instance;
  final Minutes paidMinutes;
}
