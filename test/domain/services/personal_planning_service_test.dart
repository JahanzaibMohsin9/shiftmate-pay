import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/domain/entities/availability_rule.dart';
import 'package:shiftmate_pay/domain/entities/pay_rule_set.dart';
import 'package:shiftmate_pay/domain/entities/planning_alert.dart';
import 'package:shiftmate_pay/domain/entities/planning_settings.dart';
import 'package:shiftmate_pay/domain/entities/shift_instance.dart';
import 'package:shiftmate_pay/domain/services/personal_planning_service.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';

void main() {
  group('PersonalPlanningService', () {
    const service = PersonalPlanningService();
    const jobId = 'job-1';
    final range = AppDateRange(
      start: DateTime(2026, 4, 1),
      end: DateTime(2026, 4, 7),
    );
    final settings = PlanningSettings(
      id: 'planning-1',
      jobId: jobId,
      planningAlertsEnabled: true,
      minimumRestMinutes: 11 * 60,
      maxConsecutiveWorkDays: 2,
      weeklyOvertimeCapMinutes: 2 * 60,
      monthlyOvertimeCapMinutes: 4 * 60,
      createdAt: DateTime(2026, 4, 1),
      updatedAt: DateTime(2026, 4, 1),
    );
    final payRuleSet = PayRuleSet(
      id: 'pay-1',
      jobId: jobId,
      overtimeThresholdDailyMinutes: 8 * 60,
      overtimeThresholdWeeklyMinutes: 40 * 60,
      overtimeMultiplierBps: 15000,
      doubleTimeThresholdMinutes: null,
      doubleTimeMultiplierBps: null,
      roundRule: RoundRule.nearestMinute,
    );

    test('builds overlap, rest, availability, and overtime alerts', () {
      final shifts = [
        _shift(
          id: 'a',
          start: DateTime(2026, 4, 1, 8),
          end: DateTime(2026, 4, 1, 18),
        ),
        _shift(
          id: 'b',
          start: DateTime(2026, 4, 1, 17),
          end: DateTime(2026, 4, 1, 22),
        ),
        _shift(
          id: 'c',
          start: DateTime(2026, 4, 2, 6),
          end: DateTime(2026, 4, 2, 14),
        ),
        _shift(
          id: 'd',
          start: DateTime(2026, 4, 3, 8),
          end: DateTime(2026, 4, 3, 20),
        ),
      ];
      final rules = [
        AvailabilityRule(
          id: 'rule-1',
          jobId: jobId,
          type: AvailabilityRuleType.oneOff,
          state: AvailabilityState.unavailable,
          startDateTime: DateTime(2026, 4, 2, 5),
          endDateTime: DateTime(2026, 4, 2, 9),
          weekday: null,
          startMinuteOfDay: null,
          endMinuteOfDay: null,
          note: null,
          isEnabled: true,
          createdAt: DateTime(2026, 4, 1),
          updatedAt: DateTime(2026, 4, 1),
        ),
      ];

      final alerts = service.evaluate(
        jobId: jobId,
        range: range,
        shifts: shifts,
        settings: settings,
        availabilityRules: rules,
        payRuleSet: payRuleSet,
      );

      expect(
        alerts.any((alert) => alert.type == PlanningAlertType.overlapConflict),
        isTrue,
      );
      expect(
        alerts.any((alert) => alert.type == PlanningAlertType.restGapRisk),
        isTrue,
      );
      expect(
        alerts.any(
          (alert) => alert.type == PlanningAlertType.availabilityConflict,
        ),
        isTrue,
      );
      expect(
        alerts.any(
          (alert) => alert.type == PlanningAlertType.weeklyOvertimeCapRisk,
        ),
        isTrue,
      );
      expect(
        alerts.any(
          (alert) => alert.type == PlanningAlertType.monthlyOvertimeCapRisk,
        ),
        isTrue,
      );
      expect(
        alerts.any(
          (alert) => alert.type == PlanningAlertType.consecutiveDaysRisk,
        ),
        isTrue,
      );
    });

    test('matches recurring weekly availability windows', () {
      final shifts = [
        _shift(
          id: 'recurring-shift',
          start: DateTime(2026, 4, 6, 22),
          end: DateTime(2026, 4, 7, 6),
        ),
      ];
      final rules = [
        AvailabilityRule(
          id: 'recurring-rule',
          jobId: jobId,
          type: AvailabilityRuleType.recurring,
          state: AvailabilityState.preferOff,
          startDateTime: null,
          endDateTime: null,
          weekday: DateTime.monday,
          startMinuteOfDay: 21 * 60,
          endMinuteOfDay: 6 * 60,
          note: null,
          isEnabled: true,
          createdAt: DateTime(2026, 4, 1),
          updatedAt: DateTime(2026, 4, 1),
        ),
      ];

      final alerts = service.evaluate(
        jobId: jobId,
        range: range,
        shifts: shifts,
        settings: settings,
        availabilityRules: rules,
        payRuleSet: payRuleSet,
      );

      expect(
        alerts.any(
          (alert) => alert.type == PlanningAlertType.availabilityPreference,
        ),
        isTrue,
      );
    });
  });
}

ShiftInstance _shift({
  required String id,
  required DateTime start,
  required DateTime end,
}) {
  return ShiftInstance(
    id: id,
    jobId: 'job-1',
    date: DateTime(start.year, start.month, start.day),
    templateSnapshot: const ShiftTemplateSnapshot(
      templateId: 'template-1',
      name: 'Day',
      category: ShiftCategory.day,
      startMinutesLocal: 8 * 60,
      endMinutesLocal: 16 * 60,
      unpaidBreakMinutes: 0,
      defaultNote: null,
    ),
    startDateTime: start,
    endDateTime: end,
    unpaidBreakMinutes: 0,
    source: ShiftSource.pattern,
    note: null,
    isHoliday: false,
    overrideType: null,
  );
}
