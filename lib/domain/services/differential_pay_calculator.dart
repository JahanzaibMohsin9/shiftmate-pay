import '../../core/common/shared_types.dart';
import '../entities/advanced_pay_rule_set.dart';
import '../entities/shift_instance.dart';
import 'pay_calculation_models.dart';
import 'shift_duration_calculator.dart';

class DifferentialPayCalculator {
  const DifferentialPayCalculator({
    this.durationCalculator = const ShiftDurationCalculator(),
  });

  final ShiftDurationCalculator durationCalculator;

  List<DifferentialPayItem> calculate({
    required List<ShiftInstance> shifts,
    required List<Minutes> paidMinutesByShift,
    required MinorUnits hourlyRateMinor,
    required List<DifferentialPayRule> rules,
  }) {
    if (rules.isEmpty || shifts.isEmpty) {
      return const [];
    }

    final items = <DifferentialPayItem>[];
    final additiveRules = rules
        .where(
          (rule) =>
              rule.enabled &&
              rule.combinationMode == DifferentialCombinationMode.additivePremium,
        )
        .toList(growable: false);
    final exclusiveRules = rules
        .where(
          (rule) =>
              rule.enabled &&
              rule.combinationMode == DifferentialCombinationMode.exclusiveHighestWins,
        )
        .toList(growable: false);

    for (var index = 0; index < shifts.length; index++) {
      final shift = shifts[index];
      final effectiveEnd = shift.startDateTime.add(Duration(minutes: paidMinutesByShift[index]));
      if (!effectiveEnd.isAfter(shift.startDateTime)) {
        continue;
      }

      for (final rule in additiveRules) {
        final item = _buildItem(
          shift: shift,
          effectiveEnd: effectiveEnd,
          rule: rule,
          hourlyRateMinor: hourlyRateMinor,
        );
        if (item != null) {
          items.add(item);
        }
      }

      DifferentialPayItem? exclusiveWinner;
      for (final rule in exclusiveRules) {
        final item = _buildItem(
          shift: shift,
          effectiveEnd: effectiveEnd,
          rule: rule,
          hourlyRateMinor: hourlyRateMinor,
        );
        if (item == null) {
          continue;
        }
        if (exclusiveWinner == null || item.amountMinor > exclusiveWinner.amountMinor) {
          exclusiveWinner = item;
        }
      }

      if (exclusiveWinner != null) {
        items.add(exclusiveWinner);
      }
    }

    return _combineLikeItems(items);
  }

  DifferentialPayItem? _buildItem({
    required ShiftInstance shift,
    required DateTime effectiveEnd,
    required DifferentialPayRule rule,
    required MinorUnits hourlyRateMinor,
  }) {
    if (!_matchesShiftTemplate(rule, shift)) {
      return null;
    }

    final qualifyingMinutes = switch (rule.type) {
      DifferentialRuleType.night => _nightMinutes(
          start: shift.startDateTime,
          end: effectiveEnd,
          startMinutesLocal: rule.startMinutesLocal,
          endMinutesLocal: rule.endMinutesLocal,
        ),
      DifferentialRuleType.weekend => _weekendMinutes(
          start: shift.startDateTime,
          end: effectiveEnd,
          appliesOnSaturday: rule.appliesOnSaturday,
          appliesOnSunday: rule.appliesOnSunday,
        ),
      DifferentialRuleType.holiday => shift.isHoliday
          ? durationCalculator.calculatePaidMinutes(shift)
          : 0,
    };

    if (qualifyingMinutes <= 0) {
      return null;
    }

    final amountMinor = _calculateAmount(
      minutes: qualifyingMinutes,
      hourlyRateMinor: hourlyRateMinor,
      multiplierBps: rule.multiplierBps,
      flatAmountMinor: rule.flatAmountMinor,
    );
    if (amountMinor <= 0) {
      return null;
    }

    return DifferentialPayItem(
      ruleId: rule.id,
      type: rule.type,
      minutes: qualifyingMinutes,
      amountMinor: amountMinor,
    );
  }

  bool _matchesShiftTemplate(DifferentialPayRule rule, ShiftInstance shift) {
    if (rule.shiftTemplateId == null) {
      return true;
    }
    return shift.templateSnapshot?.templateId == rule.shiftTemplateId;
  }

  int _calculateAmount({
    required int minutes,
    required int hourlyRateMinor,
    required int? multiplierBps,
    required int? flatAmountMinor,
  }) {
    if (flatAmountMinor != null && flatAmountMinor > 0) {
      return flatAmountMinor;
    }

    final premiumMultiplierBps = (multiplierBps ?? 10000) - 10000;
    if (premiumMultiplierBps <= 0) {
      return 0;
    }
    final numerator = minutes * hourlyRateMinor * premiumMultiplierBps;
    return numerator ~/ 600000;
  }

  int _nightMinutes({
    required DateTime start,
    required DateTime end,
    required int? startMinutesLocal,
    required int? endMinutesLocal,
  }) {
    if (startMinutesLocal == null || endMinutesLocal == null) {
      return 0;
    }

    var total = 0;
    final anchorStart = DateTime(start.year, start.month, start.day).subtract(const Duration(days: 1));
    final anchorEnd = DateTime(end.year, end.month, end.day).add(const Duration(days: 1));

    for (
      var anchor = anchorStart;
      !anchor.isAfter(anchorEnd);
      anchor = anchor.add(const Duration(days: 1))
    ) {
      final windowStart = DateTime(
        anchor.year,
        anchor.month,
        anchor.day,
      ).add(Duration(minutes: startMinutesLocal));
      final windowEndBase = DateTime(
        anchor.year,
        anchor.month,
        anchor.day,
      ).add(Duration(minutes: endMinutesLocal));
      final windowEnd = endMinutesLocal <= startMinutesLocal
          ? windowEndBase.add(const Duration(days: 1))
          : windowEndBase;
      total += _overlapMinutes(start, end, windowStart, windowEnd);
    }

    return total;
  }

  int _weekendMinutes({
    required DateTime start,
    required DateTime end,
    required bool appliesOnSaturday,
    required bool appliesOnSunday,
  }) {
    var total = 0;
    var cursor = start;

    while (cursor.isBefore(end)) {
      final nextBoundary = DateTime(
        cursor.year,
        cursor.month,
        cursor.day + 1,
      );
      final segmentEnd = nextBoundary.isBefore(end) ? nextBoundary : end;
      final weekday = cursor.weekday;
      final matches = (weekday == DateTime.saturday && appliesOnSaturday) ||
          (weekday == DateTime.sunday && appliesOnSunday);
      if (matches) {
        total += segmentEnd.difference(cursor).inMinutes;
      }
      cursor = segmentEnd;
    }

    return total;
  }

  int _overlapMinutes(
    DateTime rangeStart,
    DateTime rangeEnd,
    DateTime windowStart,
    DateTime windowEnd,
  ) {
    final start = rangeStart.isAfter(windowStart) ? rangeStart : windowStart;
    final end = rangeEnd.isBefore(windowEnd) ? rangeEnd : windowEnd;
    if (!end.isAfter(start)) {
      return 0;
    }
    return end.difference(start).inMinutes;
  }

  List<DifferentialPayItem> _combineLikeItems(List<DifferentialPayItem> items) {
    final combined = <String, DifferentialPayItem>{};
    for (final item in items) {
      final existing = combined[item.ruleId];
      if (existing == null) {
        combined[item.ruleId] = item;
        continue;
      }
      combined[item.ruleId] = DifferentialPayItem(
        ruleId: item.ruleId,
        type: item.type,
        minutes: existing.minutes + item.minutes,
        amountMinor: existing.amountMinor + item.amountMinor,
      );
    }
    return combined.values.toList(growable: false);
  }
}
