import '../../core/common/shared_types.dart';
import '../entities/advanced_pay_rule_set.dart';
import '../entities/shift_instance.dart';
import 'advanced_break_resolver.dart';
import 'allowance_pay_calculator.dart';
import 'differential_pay_calculator.dart';
import 'holiday_multiplier_calculator.dart';
import 'overtime_allocator.dart';
import 'pay_calculation_models.dart';
import 'shift_duration_calculator.dart';

class GrossPayCalculator {
  const GrossPayCalculator({
    this.durationCalculator = const ShiftDurationCalculator(),
    this.overtimeAllocator = const OvertimeAllocator(),
    this.holidayMultiplierCalculator = const HolidayMultiplierCalculator(),
    this.differentialPayCalculator = const DifferentialPayCalculator(),
    this.allowancePayCalculator = const AllowancePayCalculator(),
    this.advancedBreakResolver = const AdvancedBreakResolver(),
  });

  final ShiftDurationCalculator durationCalculator;
  final OvertimeAllocator overtimeAllocator;
  final HolidayMultiplierCalculator holidayMultiplierCalculator;
  final DifferentialPayCalculator differentialPayCalculator;
  final AllowancePayCalculator allowancePayCalculator;
  final AdvancedBreakResolver advancedBreakResolver;

  PayBreakdown calculate({
    required List<ShiftInstance> shifts,
    required MinorUnits hourlyRateMinor,
    required Minutes? dailyOvertimeThresholdMinutes,
    required Minutes? weeklyOvertimeThresholdMinutes,
    required int overtimeMultiplierBps,
    required int holidayMultiplierBps,
    AdvancedPayRuleSet? advancedPayRuleSet,
  }) {
    final workedShifts =
        shifts
            .where((shift) => shift.endDateTime.isAfter(shift.startDateTime))
            .toList(growable: false)
          ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

    final paidMinutesByShift = workedShifts
        .map(
          (shift) => durationCalculator.calculatePaidMinutesWithBreak(
            instance: shift,
            unpaidBreakMinutes:
                advancedPayRuleSet == null || !advancedPayRuleSet.enabled
                ? shift.unpaidBreakMinutes
                : advancedBreakResolver.resolve(
                    shift: shift,
                    rules: advancedPayRuleSet.breakRules,
                  ),
          ),
        )
        .toList(growable: false);

    final overtimeAllocation = overtimeAllocator.allocate(
      paidMinutesByShift: paidMinutesByShift,
      shiftStartDateTimes: workedShifts
          .map((shift) => shift.startDateTime)
          .toList(growable: false),
      dailyThresholdMinutes: dailyOvertimeThresholdMinutes,
      weeklyThresholdMinutes: weeklyOvertimeThresholdMinutes,
    );

    final holidayMinutes = <Minutes>[];
    for (var index = 0; index < workedShifts.length; index++) {
      holidayMinutes.add(
        workedShifts[index].isHoliday ? paidMinutesByShift[index] : 0,
      );
    }

    final totalHolidayMinutes = holidayMinutes.fold<Minutes>(
      0,
      (sum, minutes) => sum + minutes,
    );
    final basePayMinor = _calculateAmount(
      minutes: overtimeAllocation.baseMinutes,
      hourlyRateMinor: hourlyRateMinor,
      multiplierBps: 10000,
    );
    final overtimePayMinor = _calculateAmount(
      minutes: overtimeAllocation.overtimeMinutes,
      hourlyRateMinor: hourlyRateMinor,
      multiplierBps: overtimeMultiplierBps,
    );
    final holidayPayMinor = holidayMultiplierCalculator.calculatePremium(
      holidayMinutes: totalHolidayMinutes,
      hourlyRateMinor: hourlyRateMinor,
      holidayMultiplierBps: holidayMultiplierBps,
    );
    final differentialItems =
        advancedPayRuleSet == null || !advancedPayRuleSet.enabled
        ? const <DifferentialPayItem>[]
        : differentialPayCalculator.calculate(
            shifts: workedShifts,
            paidMinutesByShift: paidMinutesByShift,
            hourlyRateMinor: hourlyRateMinor,
            rules: advancedPayRuleSet.differentialRules,
          );
    final allowanceItems =
        advancedPayRuleSet == null || !advancedPayRuleSet.enabled
        ? const <AllowancePayItem>[]
        : allowancePayCalculator.calculate(
            shifts: workedShifts,
            rules: advancedPayRuleSet.allowanceRules,
          );
    final differentialPayMinor = differentialItems.fold<MinorUnits>(
      0,
      (sum, item) => sum + item.amountMinor,
    );
    final allowancePayMinor = allowanceItems.fold<MinorUnits>(
      0,
      (sum, item) => sum + item.amountMinor,
    );
    final differentialMinutes = differentialItems.fold<Minutes>(
      0,
      (sum, item) => sum + item.minutes,
    );
    final grossPayMinor =
        basePayMinor +
        overtimePayMinor +
        holidayPayMinor +
        differentialPayMinor +
        allowancePayMinor;

    final lineItems = <PayLineItem>[];
    if (overtimeAllocation.baseMinutes > 0) {
      lineItems.add(
        PayLineItem(
          type: PayLineItemType.base,
          label: 'Base pay',
          minutes: overtimeAllocation.baseMinutes,
          rateMinorPerHour: hourlyRateMinor,
          multiplierBps: 10000,
          amountMinor: basePayMinor,
        ),
      );
    }
    if (overtimeAllocation.overtimeMinutes > 0) {
      lineItems.add(
        PayLineItem(
          type: PayLineItemType.overtime,
          label: 'Overtime pay',
          minutes: overtimeAllocation.overtimeMinutes,
          rateMinorPerHour: hourlyRateMinor,
          multiplierBps: overtimeMultiplierBps,
          amountMinor: overtimePayMinor,
        ),
      );
    }
    if (totalHolidayMinutes > 0 && holidayPayMinor > 0) {
      lineItems.add(
        PayLineItem(
          type: PayLineItemType.holidayPremium,
          label: 'Holiday premium',
          minutes: totalHolidayMinutes,
          rateMinorPerHour: hourlyRateMinor,
          multiplierBps: holidayMultiplierBps,
          amountMinor: holidayPayMinor,
        ),
      );
    }
    for (final item in differentialItems) {
      lineItems.add(
        PayLineItem(
          type: PayLineItemType.differential,
          label: _differentialLabel(item.type),
          minutes: item.minutes,
          rateMinorPerHour: hourlyRateMinor,
          multiplierBps: 10000,
          amountMinor: item.amountMinor,
        ),
      );
    }
    for (final item in allowanceItems) {
      lineItems.add(
        PayLineItem(
          type: PayLineItemType.allowance,
          label: _allowanceLabel(item.type),
          minutes: 0,
          rateMinorPerHour: 0,
          multiplierBps: 10000,
          amountMinor: item.amountMinor,
        ),
      );
    }

    return PayBreakdown(
      totalWorkedMinutes: overtimeAllocation.totalMinutes,
      baseMinutes: overtimeAllocation.baseMinutes,
      overtimeMinutes: overtimeAllocation.overtimeMinutes,
      holidayMinutes: totalHolidayMinutes,
      differentialMinutes: differentialMinutes,
      basePayMinor: basePayMinor,
      overtimePayMinor: overtimePayMinor,
      holidayPayMinor: holidayPayMinor,
      differentialPayMinor: differentialPayMinor,
      allowancePayMinor: allowancePayMinor,
      grossPayMinor: grossPayMinor,
      lineItems: lineItems,
    );
  }

  MinorUnits _calculateAmount({
    required Minutes minutes,
    required MinorUnits hourlyRateMinor,
    required int multiplierBps,
  }) {
    final numerator = minutes * hourlyRateMinor * multiplierBps;
    return numerator ~/ 600000;
  }

  String _differentialLabel(DifferentialRuleType type) {
    return switch (type) {
      DifferentialRuleType.night => 'Night differential',
      DifferentialRuleType.weekend => 'Weekend differential',
      DifferentialRuleType.holiday => 'Holiday differential',
    };
  }

  String _allowanceLabel(AllowanceRuleType type) {
    return switch (type) {
      AllowanceRuleType.perShift => 'Per-shift allowance',
      AllowanceRuleType.perPeriod => 'Per-period allowance',
    };
  }
}
