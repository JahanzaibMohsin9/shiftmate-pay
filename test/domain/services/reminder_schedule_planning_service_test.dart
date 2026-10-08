import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/core/money/currency_amount.dart';
import 'package:shiftmate_pay/domain/entities/job.dart';
import 'package:shiftmate_pay/domain/entities/planning_settings.dart';
import 'package:shiftmate_pay/domain/entities/reminder_rule.dart';
import 'package:shiftmate_pay/domain/entities/shift_instance.dart';
import 'package:shiftmate_pay/domain/services/reminder_schedule_planning_service.dart';

void main() {
  const service = ReminderSchedulePlanningService();

  group('ReminderSchedulePlanningService', () {
    test('filters premium prep reminders for free users', () {
      final shift = ShiftInstance(
        id: 'shift-1',
        jobId: 'job-1',
        date: DateTime(2026, 4, 5),
        templateSnapshot: const ShiftTemplateSnapshot(
          templateId: 'template-1',
          name: 'Night shift',
          category: ShiftCategory.night,
          startMinutesLocal: 1200,
          endMinutesLocal: 360,
          unpaidBreakMinutes: 30,
          defaultNote: null,
        ),
        startDateTime: DateTime(2026, 4, 5, 20),
        endDateTime: DateTime(2026, 4, 6, 6),
        unpaidBreakMinutes: 30,
        source: ShiftSource.pattern,
        note: null,
        isHoliday: false,
        overrideType: null,
      );

      final rules = const [
        ReminderRule(
          id: 'shift-start',
          jobId: 'job-1',
          type: ReminderType.shiftStart,
          leadMinutes: 60,
          enabled: true,
        ),
        ReminderRule(
          id: 'prep',
          jobId: 'job-1',
          type: ReminderType.prep,
          leadMinutes: 180,
          enabled: true,
        ),
      ];

      final freePlan = service.buildPlan(
        job: _buildJob(),
        rules: rules,
        schedule: [shift],
        premiumUnlocked: false,
        now: DateTime(2026, 4, 5, 8),
      );

      final premiumPlan = service.buildPlan(
        job: _buildJob(),
        rules: rules,
        schedule: [shift],
        premiumUnlocked: true,
        now: DateTime(2026, 4, 5, 8),
      );

      expect(freePlan.recommendations, hasLength(1));
      expect(freePlan.recommendations.single.type, ReminderType.shiftStart);
      expect(premiumPlan.recommendations, hasLength(2));
      expect(
        premiumPlan.recommendations.map((entry) => entry.type),
        contains(ReminderType.prep),
      );
    });

    test('suggests longer prep defaults for night shifts', () {
      expect(
        service.suggestedLeadMinutesFor(
          type: ReminderType.prep,
          shiftCategory: ShiftCategory.night,
        ),
        180,
      );
      expect(
        service.suggestedLeadMinutesFor(
          type: ReminderType.prep,
          shiftCategory: ShiftCategory.day,
        ),
        75,
      );
    });

    test('personalizes prep reminder title by shift category', () {
      expect(
        service.recommendationTitleFor(
          type: ReminderType.prep,
          shiftCategory: ShiftCategory.night,
        ),
        'Night shift prep reminder',
      );
      expect(
        service.recommendationTitleFor(
          type: ReminderType.prep,
          shiftCategory: ShiftCategory.evening,
        ),
        'Evening shift prep reminder',
      );
    });

    test(
      'adds short-rest context when planning settings detect a tight gap',
      () {
        final shifts = [
          ShiftInstance(
            id: 'shift-1',
            jobId: 'job-1',
            date: DateTime(2026, 4, 5),
            templateSnapshot: const ShiftTemplateSnapshot(
              templateId: 'template-1',
              name: 'Late',
              category: ShiftCategory.evening,
              startMinutesLocal: 14 * 60,
              endMinutesLocal: 22 * 60,
              unpaidBreakMinutes: 30,
              defaultNote: null,
            ),
            startDateTime: DateTime(2026, 4, 5, 14),
            endDateTime: DateTime(2026, 4, 5, 22),
            unpaidBreakMinutes: 30,
            source: ShiftSource.pattern,
            note: null,
            isHoliday: false,
            overrideType: null,
          ),
          ShiftInstance(
            id: 'shift-2',
            jobId: 'job-1',
            date: DateTime(2026, 4, 6),
            templateSnapshot: const ShiftTemplateSnapshot(
              templateId: 'template-2',
              name: 'Day',
              category: ShiftCategory.day,
              startMinutesLocal: 6 * 60,
              endMinutesLocal: 14 * 60,
              unpaidBreakMinutes: 30,
              defaultNote: null,
            ),
            startDateTime: DateTime(2026, 4, 6, 6),
            endDateTime: DateTime(2026, 4, 6, 14),
            unpaidBreakMinutes: 30,
            source: ShiftSource.pattern,
            note: null,
            isHoliday: false,
            overrideType: null,
          ),
        ];
        final rules = const [
          ReminderRule(
            id: 'sleep',
            jobId: 'job-1',
            type: ReminderType.sleep,
            leadMinutes: 480,
            enabled: true,
          ),
        ];

        final plan = service.buildPlan(
          job: _buildJob(),
          rules: rules,
          schedule: shifts,
          planningSettings: PlanningSettings(
            id: 'planning-1',
            jobId: 'job-1',
            planningAlertsEnabled: true,
            minimumRestMinutes: 11 * 60,
            maxConsecutiveWorkDays: null,
            weeklyOvertimeCapMinutes: null,
            monthlyOvertimeCapMinutes: null,
            createdAt: DateTime.utc(2026, 4, 1),
            updatedAt: DateTime.utc(2026, 4, 1),
          ),
          premiumUnlocked: false,
          now: DateTime(2026, 4, 5, 21),
        );

        expect(plan.shortRestContext, isNotNull);
        expect(plan.recommendations.single.shortRestRisk, isTrue);
        expect(plan.recommendations.single.title, 'Short-rest sleep reminder');
        expect(
          plan.recommendations.single.message,
          contains('Rest is tighter than your target'),
        );
      },
    );
  });
}

Job _buildJob() {
  final createdAt = DateTime.utc(2026, 4, 1);
  return Job(
    id: 'job-1',
    name: 'Clinic nights',
    colorHex: '#4F46E5',
    currencyCode: 'PKR',
    hourlyRate: const CurrencyAmount(minorUnits: 25000, currencyCode: 'PKR'),
    payRuleSetId: null,
    holidayRuleSetId: null,
    defaultSleepLeadMinutes: 480,
    isArchived: false,
    createdAt: createdAt,
    updatedAt: createdAt,
  );
}
