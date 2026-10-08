import '../../core/common/shared_types.dart';
import '../entities/advanced_pay_rule_set.dart';
import 'pay_calculation_models.dart';

class OvertimeAllocator {
  const OvertimeAllocator();

  OvertimeAllocation allocate({
    required List<Minutes> paidMinutesByShift,
    required Minutes? dailyThresholdMinutes,
    required Minutes? weeklyThresholdMinutes,
    List<DateTime>? shiftStartDateTimes,
  }) {
    final sanitizedMinutes = paidMinutesByShift
        .map((minutes) => minutes < 0 ? 0 : minutes)
        .toList(growable: false);

    final totalMinutes = sanitizedMinutes.fold<Minutes>(
      0,
      (sum, minutes) => sum + minutes,
    );

    var dailyOvertimeMinutes = 0;
    var weeklyOvertimeMinutes = 0;
    final groupedIndexes = _groupIndexesByWeek(
      sanitizedMinutes.length,
      shiftStartDateTimes,
    );

    for (final indexes in groupedIndexes.values) {
      final weekTotal = indexes.fold<Minutes>(
        0,
        (sum, index) => sum + sanitizedMinutes[index],
      );
      final weekDailyOvertime = dailyThresholdMinutes == null
          ? 0
          : indexes.fold<Minutes>(
              0,
              (sum, index) =>
                  sum +
                  _positive(sanitizedMinutes[index] - dailyThresholdMinutes),
            );
      final weeklyOvertimeCap = weeklyThresholdMinutes == null
          ? 0
          : _positive(weekTotal - weeklyThresholdMinutes);

      dailyOvertimeMinutes += weekDailyOvertime;
      weeklyOvertimeMinutes += _positive(weeklyOvertimeCap - weekDailyOvertime);
    }

    final overtimeMinutes = dailyOvertimeMinutes + weeklyOvertimeMinutes;
    final baseMinutes = _positive(totalMinutes - overtimeMinutes);

    return OvertimeAllocation(
      totalMinutes: totalMinutes,
      baseMinutes: baseMinutes,
      dailyOvertimeMinutes: dailyOvertimeMinutes,
      weeklyOvertimeMinutes: weeklyOvertimeMinutes,
    );
  }

  Minutes _positive(Minutes value) => value < 0 ? 0 : value;

  AdvancedOvertimeAllocation allocateAdvanced({
    required List<Minutes> paidMinutesByShift,
    required List<OvertimeTierRule> rules,
    List<DateTime>? shiftStartDateTimes,
  }) {
    final sanitizedMinutes = paidMinutesByShift
        .map((minutes) => minutes < 0 ? 0 : minutes)
        .toList(growable: false);
    final enabledRules =
        rules.where((rule) => rule.enabled).toList(growable: false)
          ..sort((a, b) {
            final priorityCompare = a.priority.compareTo(b.priority);
            if (priorityCompare != 0) {
              return priorityCompare;
            }
            final thresholdCompare = a.thresholdMinutes.compareTo(
              b.thresholdMinutes,
            );
            if (thresholdCompare != 0) {
              return thresholdCompare;
            }
            return a.id.compareTo(b.id);
          });

    final totalMinutes = sanitizedMinutes.fold<Minutes>(
      0,
      (sum, minutes) => sum + minutes,
    );
    if (enabledRules.isEmpty || totalMinutes == 0) {
      return AdvancedOvertimeAllocation(
        totalMinutes: totalMinutes,
        baseMinutes: totalMinutes,
        tierAllocations: const [],
      );
    }

    final dailyRules =
        enabledRules
            .where((rule) => rule.periodType == OvertimePeriodType.daily)
            .toList(growable: false)
          ..sort((a, b) => a.thresholdMinutes.compareTo(b.thresholdMinutes));
    final weeklyRules =
        enabledRules
            .where((rule) => rule.periodType == OvertimePeriodType.weekly)
            .toList(growable: false)
          ..sort((a, b) => a.thresholdMinutes.compareTo(b.thresholdMinutes));

    final tierAllocations = <OvertimeTierAllocation>[];
    for (final shiftMinutes in sanitizedMinutes) {
      _allocateTieredMinutes(
        totalMinutes: shiftMinutes,
        rules: dailyRules,
        sink: tierAllocations,
      );
    }

    if (weeklyRules.isNotEmpty) {
      final groupedIndexes = _groupIndexesByWeek(
        sanitizedMinutes.length,
        shiftStartDateTimes,
      );

      for (final indexes in groupedIndexes.values) {
        final weekTotal = indexes.fold<Minutes>(
          0,
          (sum, index) => sum + sanitizedMinutes[index],
        );
        final weekDailyOvertime = indexes.fold<Minutes>(
          0,
          (sum, index) =>
              sum +
              _allocateTieredMinutes(
                totalMinutes: sanitizedMinutes[index],
                rules: dailyRules,
                sink: <OvertimeTierAllocation>[],
              ),
        );
        final weeklyTierAllocations = <OvertimeTierAllocation>[];
        final weeklyOvertimeCap = _allocateTieredMinutes(
          totalMinutes: weekTotal,
          rules: weeklyRules,
          sink: weeklyTierAllocations,
        );
        final remainingWeeklyOvertime = _positive(
          weeklyOvertimeCap - weekDailyOvertime,
        );
        if (remainingWeeklyOvertime > 0) {
          tierAllocations.addAll(
            _trimWeeklyAllocations(
              allocations: weeklyTierAllocations,
              minutesToKeep: remainingWeeklyOvertime,
            ),
          );
        }
      }
    }

    final totalOvertime = tierAllocations.fold<Minutes>(
      0,
      (sum, item) => sum + item.minutes,
    );
    return AdvancedOvertimeAllocation(
      totalMinutes: totalMinutes,
      baseMinutes: _positive(totalMinutes - totalOvertime),
      tierAllocations: tierAllocations,
    );
  }

  int _allocateTieredMinutes({
    required int totalMinutes,
    required List<OvertimeTierRule> rules,
    required List<OvertimeTierAllocation> sink,
  }) {
    if (rules.isEmpty || totalMinutes <= 0) {
      return 0;
    }

    var overtimeMinutes = 0;
    for (var index = 0; index < rules.length; index++) {
      final current = rules[index];
      final nextThreshold = index + 1 < rules.length
          ? rules[index + 1].thresholdMinutes
          : null;
      final cappedTop = nextThreshold == null || totalMinutes < nextThreshold
          ? totalMinutes
          : nextThreshold;
      final minutesInTier = _positive(cappedTop - current.thresholdMinutes);
      if (minutesInTier <= 0) {
        continue;
      }

      sink.add(
        OvertimeTierAllocation(
          ruleId: current.id,
          periodType: current.periodType,
          multiplierBps: current.multiplierBps,
          minutes: minutesInTier,
          priority: current.priority,
        ),
      );
      overtimeMinutes += minutesInTier;
    }

    return overtimeMinutes;
  }

  List<OvertimeTierAllocation> _trimWeeklyAllocations({
    required List<OvertimeTierAllocation> allocations,
    required int minutesToKeep,
  }) {
    var remaining = minutesToKeep;
    final trimmed = <OvertimeTierAllocation>[];

    for (final allocation in allocations) {
      if (remaining <= 0) {
        break;
      }

      final minutes = allocation.minutes <= remaining
          ? allocation.minutes
          : remaining;
      trimmed.add(
        OvertimeTierAllocation(
          ruleId: allocation.ruleId,
          periodType: allocation.periodType,
          multiplierBps: allocation.multiplierBps,
          minutes: minutes,
          priority: allocation.priority,
        ),
      );
      remaining -= minutes;
    }

    return trimmed;
  }

  Map<String, List<int>> _groupIndexesByWeek(
    int itemCount,
    List<DateTime>? shiftStartDateTimes,
  ) {
    if (shiftStartDateTimes == null ||
        shiftStartDateTimes.length != itemCount) {
      return {
        'all': [for (var index = 0; index < itemCount; index++) index],
      };
    }

    final grouped = <String, List<int>>{};
    for (var index = 0; index < itemCount; index++) {
      final weekStart = _startOfWeek(shiftStartDateTimes[index]);
      final key =
          '${weekStart.year.toString().padLeft(4, '0')}-'
          '${weekStart.month.toString().padLeft(2, '0')}-'
          '${weekStart.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => <int>[]).add(index);
    }
    return grouped;
  }

  DateTime _startOfWeek(DateTime value) {
    final date = value.isUtc
        ? DateTime.utc(value.year, value.month, value.day)
        : DateTime(value.year, value.month, value.day);
    return date.subtract(Duration(days: date.weekday - DateTime.monday));
  }
}
