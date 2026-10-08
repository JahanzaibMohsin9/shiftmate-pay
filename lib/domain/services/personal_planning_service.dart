import '../../core/common/shared_types.dart';
import '../../core/time/app_date_range.dart';
import '../entities/availability_rule.dart';
import '../entities/pay_rule_set.dart';
import '../entities/planning_alert.dart';
import '../entities/planning_settings.dart';
import '../entities/shift_instance.dart';
import 'overtime_allocator.dart';
import 'shift_duration_calculator.dart';

class PersonalPlanningService {
  const PersonalPlanningService({
    this.durationCalculator = const ShiftDurationCalculator(),
    this.overtimeAllocator = const OvertimeAllocator(),
  });

  final ShiftDurationCalculator durationCalculator;
  final OvertimeAllocator overtimeAllocator;

  List<PlanningAlert> evaluate({
    required String jobId,
    required AppDateRange range,
    required List<ShiftInstance> shifts,
    required PlanningSettings? settings,
    required List<AvailabilityRule> availabilityRules,
    required PayRuleSet? payRuleSet,
  }) {
    if (settings != null && !settings.planningAlertsEnabled) {
      return const <PlanningAlert>[];
    }

    final alerts = <PlanningAlert>[];
    final workedShifts =
        shifts
            .where((shift) => shift.endDateTime.isAfter(shift.startDateTime))
            .toList(growable: false)
          ..sort(
            (left, right) => left.startDateTime.compareTo(right.startDateTime),
          );
    final activeAvailability = availabilityRules
        .where((rule) => rule.isEnabled)
        .toList(growable: false);

    alerts.addAll(_buildOverlapAlerts(jobId: jobId, shifts: workedShifts));
    alerts.addAll(
      _buildAvailabilityAlerts(
        jobId: jobId,
        shifts: workedShifts,
        rules: activeAvailability,
      ),
    );

    final minimumRestMinutes = settings?.minimumRestMinutes;
    if (minimumRestMinutes != null && minimumRestMinutes > 0) {
      alerts.addAll(
        _buildRestGapAlerts(
          jobId: jobId,
          shifts: workedShifts,
          minimumRestMinutes: minimumRestMinutes,
        ),
      );
    }

    final maxConsecutiveWorkDays = settings?.maxConsecutiveWorkDays;
    if (maxConsecutiveWorkDays != null && maxConsecutiveWorkDays > 0) {
      alerts.addAll(
        _buildConsecutiveDayAlerts(
          jobId: jobId,
          shifts: workedShifts,
          maxConsecutiveWorkDays: maxConsecutiveWorkDays,
        ),
      );
    }

    alerts.addAll(
      _buildOvertimeCapAlerts(
        jobId: jobId,
        range: range,
        shifts: workedShifts,
        settings: settings,
        payRuleSet: payRuleSet,
      ),
    );

    alerts.sort((left, right) {
      final dateCompare = left.date.compareTo(right.date);
      if (dateCompare != 0) {
        return dateCompare;
      }
      final severityCompare = right.severity.index.compareTo(
        left.severity.index,
      );
      if (severityCompare != 0) {
        return severityCompare;
      }
      return left.title.compareTo(right.title);
    });

    return alerts;
  }

  List<PlanningAlert> _buildOverlapAlerts({
    required String jobId,
    required List<ShiftInstance> shifts,
  }) {
    final alerts = <PlanningAlert>[];
    for (var index = 0; index < shifts.length; index++) {
      final current = shifts[index];
      for (var inner = index + 1; inner < shifts.length; inner++) {
        final next = shifts[inner];
        if (!next.startDateTime.isBefore(current.endDateTime)) {
          break;
        }
        if (_overlaps(current, next)) {
          alerts.add(
            PlanningAlert(
              id: 'overlap:${current.id}:${next.id}',
              jobId: jobId,
              shiftInstanceId: next.id,
              date: next.date,
              type: PlanningAlertType.overlapConflict,
              severity: PlanningAlertSeverity.risk,
              title: 'Overlapping shifts',
              message:
                  'This shift overlaps another scheduled shift. Check the day before saving more changes.',
            ),
          );
        }
      }
    }
    return alerts;
  }

  List<PlanningAlert> _buildAvailabilityAlerts({
    required String jobId,
    required List<ShiftInstance> shifts,
    required List<AvailabilityRule> rules,
  }) {
    final alerts = <PlanningAlert>[];
    for (final shift in shifts) {
      for (final rule in rules) {
        if (!_intersectsAvailabilityRule(shift: shift, rule: rule)) {
          continue;
        }

        final isHardConflict = rule.state == AvailabilityState.unavailable;
        alerts.add(
          PlanningAlert(
            id: 'availability:${rule.id}:${shift.id}',
            jobId: jobId,
            shiftInstanceId: shift.id,
            date: shift.date,
            type: isHardConflict
                ? PlanningAlertType.availabilityConflict
                : PlanningAlertType.availabilityPreference,
            severity: isHardConflict
                ? PlanningAlertSeverity.risk
                : PlanningAlertSeverity.attention,
            title: isHardConflict
                ? 'Unavailable time conflict'
                : 'Prefer-off time conflict',
            message: isHardConflict
                ? 'This shift lands inside a time you marked as unavailable.'
                : 'This shift lands inside a time you would prefer to keep free.',
          ),
        );
      }
    }
    return alerts;
  }

  List<PlanningAlert> _buildRestGapAlerts({
    required String jobId,
    required List<ShiftInstance> shifts,
    required Minutes minimumRestMinutes,
  }) {
    final alerts = <PlanningAlert>[];
    for (var index = 1; index < shifts.length; index++) {
      final previous = shifts[index - 1];
      final current = shifts[index];
      final gapMinutes = current.startDateTime
          .difference(previous.endDateTime)
          .inMinutes;
      if (gapMinutes >= minimumRestMinutes) {
        continue;
      }

      final shortfall = minimumRestMinutes - gapMinutes;
      alerts.add(
        PlanningAlert(
          id: 'rest:${previous.id}:${current.id}',
          jobId: jobId,
          shiftInstanceId: current.id,
          date: current.date,
          type: PlanningAlertType.restGapRisk,
          severity: shortfall >= 180
              ? PlanningAlertSeverity.risk
              : PlanningAlertSeverity.attention,
          title: 'Short rest before next shift',
          message:
              'Only ${_formatMinutes(gapMinutes)} of rest separates this shift from the previous one.',
        ),
      );
    }
    return alerts;
  }

  List<PlanningAlert> _buildConsecutiveDayAlerts({
    required String jobId,
    required List<ShiftInstance> shifts,
    required int maxConsecutiveWorkDays,
  }) {
    final alerts = <PlanningAlert>[];
    final shiftsByDate = <DateTime, List<ShiftInstance>>{};
    for (final shift in shifts) {
      shiftsByDate.putIfAbsent(shift.date, () => <ShiftInstance>[]).add(shift);
    }
    final workedDates = shiftsByDate.keys.toList(growable: false)..sort();

    var streak = 0;
    DateTime? previousDate;
    for (final date in workedDates) {
      if (previousDate != null && date.difference(previousDate).inDays == 1) {
        streak += 1;
      } else {
        streak = 1;
      }
      previousDate = date;

      if (streak <= maxConsecutiveWorkDays) {
        continue;
      }

      final dayShifts = shiftsByDate[date]!;
      alerts.add(
        PlanningAlert(
          id: 'consecutive:${date.toIso8601String()}:$streak',
          jobId: jobId,
          shiftInstanceId: dayShifts.first.id,
          date: date,
          type: PlanningAlertType.consecutiveDaysRisk,
          severity: streak > maxConsecutiveWorkDays + 1
              ? PlanningAlertSeverity.risk
              : PlanningAlertSeverity.attention,
          title: 'Consecutive workday streak',
          message:
              'This is day $streak in a row with worked shifts, above your target of $maxConsecutiveWorkDays.',
        ),
      );
    }
    return alerts;
  }

  List<PlanningAlert> _buildOvertimeCapAlerts({
    required String jobId,
    required AppDateRange range,
    required List<ShiftInstance> shifts,
    required PlanningSettings? settings,
    required PayRuleSet? payRuleSet,
  }) {
    if (settings == null || payRuleSet == null) {
      return const <PlanningAlert>[];
    }

    final alerts = <PlanningAlert>[];
    final weeklyCap = settings.weeklyOvertimeCapMinutes;
    final monthlyCap = settings.monthlyOvertimeCapMinutes;
    if (weeklyCap != null && weeklyCap > 0) {
      final overtimeByWeek = _calculateWeeklyOvertimeMinutes(
        shifts: shifts,
        payRuleSet: payRuleSet,
      );
      for (final entry in overtimeByWeek.entries) {
        if (entry.value <= weeklyCap) {
          continue;
        }
        alerts.add(
          PlanningAlert(
            id: 'weekly-cap:${entry.key.toIso8601String()}',
            jobId: jobId,
            shiftInstanceId: null,
            date: entry.key,
            type: PlanningAlertType.weeklyOvertimeCapRisk,
            severity: PlanningAlertSeverity.attention,
            title: 'Weekly overtime cap exceeded',
            message:
                'Planned overtime reaches ${_formatMinutes(entry.value)}, above your weekly cap of ${_formatMinutes(weeklyCap)}.',
          ),
        );
      }
    }

    if (monthlyCap != null && monthlyCap > 0) {
      final overtimeMinutes = _calculateWeeklyOvertimeMinutes(
        shifts: shifts,
        payRuleSet: payRuleSet,
      ).values.fold<Minutes>(0, (sum, value) => sum + value);
      if (overtimeMinutes > monthlyCap) {
        alerts.add(
          PlanningAlert(
            id: 'monthly-cap:${range.start.year}-${range.start.month}',
            jobId: jobId,
            shiftInstanceId: null,
            date: range.start,
            type: PlanningAlertType.monthlyOvertimeCapRisk,
            severity: PlanningAlertSeverity.attention,
            title: 'Monthly overtime cap exceeded',
            message:
                'Planned overtime reaches ${_formatMinutes(overtimeMinutes)} in this period, above your monthly cap of ${_formatMinutes(monthlyCap)}.',
          ),
        );
      }
    }

    return alerts;
  }

  Map<DateTime, Minutes> _calculateWeeklyOvertimeMinutes({
    required List<ShiftInstance> shifts,
    required PayRuleSet payRuleSet,
  }) {
    final shiftsByWeek = <DateTime, List<ShiftInstance>>{};
    for (final shift in shifts) {
      final weekStart = _weekStart(shift.startDateTime);
      shiftsByWeek.putIfAbsent(weekStart, () => <ShiftInstance>[]).add(shift);
    }

    final overtimeByWeek = <DateTime, Minutes>{};
    for (final entry in shiftsByWeek.entries) {
      final paidMinutesByShift = entry.value
          .map(durationCalculator.calculatePaidMinutes)
          .toList(growable: false);
      final allocation = overtimeAllocator.allocate(
        paidMinutesByShift: paidMinutesByShift,
        dailyThresholdMinutes: payRuleSet.overtimeThresholdDailyMinutes,
        weeklyThresholdMinutes: payRuleSet.overtimeThresholdWeeklyMinutes,
      );
      overtimeByWeek[entry.key] = allocation.overtimeMinutes;
    }
    return overtimeByWeek;
  }

  bool _overlaps(ShiftInstance left, ShiftInstance right) {
    return left.startDateTime.isBefore(right.endDateTime) &&
        right.startDateTime.isBefore(left.endDateTime);
  }

  bool _intersectsAvailabilityRule({
    required ShiftInstance shift,
    required AvailabilityRule rule,
  }) {
    return switch (rule.type) {
      AvailabilityRuleType.oneOff => _intersectsOneOffRule(
        shift: shift,
        rule: rule,
      ),
      AvailabilityRuleType.recurring => _intersectsRecurringRule(
        shift: shift,
        rule: rule,
      ),
    };
  }

  bool _intersectsOneOffRule({
    required ShiftInstance shift,
    required AvailabilityRule rule,
  }) {
    final start = rule.startDateTime;
    final end = rule.endDateTime;
    if (start == null || end == null) {
      return false;
    }
    return shift.startDateTime.isBefore(end) &&
        shift.endDateTime.isAfter(start);
  }

  bool _intersectsRecurringRule({
    required ShiftInstance shift,
    required AvailabilityRule rule,
  }) {
    final weekday = rule.weekday;
    final startMinuteOfDay = rule.startMinuteOfDay;
    final endMinuteOfDay = rule.endMinuteOfDay;
    if (weekday == null || startMinuteOfDay == null || endMinuteOfDay == null) {
      return false;
    }

    final candidateDays = <DateTime>{
      DateTime(
        shift.startDateTime.year,
        shift.startDateTime.month,
        shift.startDateTime.day,
      ),
      DateTime(
        shift.startDateTime.year,
        shift.startDateTime.month,
        shift.startDateTime.day,
      ).subtract(const Duration(days: 1)),
    };

    for (final day in candidateDays) {
      if (day.weekday != weekday) {
        continue;
      }
      final ruleStart = day.add(Duration(minutes: startMinuteOfDay));
      final normalizedEndMinutes = endMinuteOfDay <= startMinuteOfDay
          ? endMinuteOfDay + (24 * 60)
          : endMinuteOfDay;
      final ruleEnd = day.add(Duration(minutes: normalizedEndMinutes));
      if (shift.startDateTime.isBefore(ruleEnd) &&
          shift.endDateTime.isAfter(ruleStart)) {
        return true;
      }
    }
    return false;
  }

  DateTime _weekStart(DateTime value) {
    final normalized = DateTime(value.year, value.month, value.day);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  String _formatMinutes(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours == 0) {
      return '${minutes}m';
    }
    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${minutes}m';
  }
}
