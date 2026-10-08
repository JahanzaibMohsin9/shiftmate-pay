import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/domain/entities/advanced_pay_rule_set.dart';
import 'package:shiftmate_pay/domain/entities/shift_instance.dart';
import 'package:shiftmate_pay/domain/services/gross_pay_calculator.dart';
import 'package:shiftmate_pay/domain/services/differential_pay_calculator.dart';
import 'package:shiftmate_pay/domain/services/holiday_multiplier_calculator.dart';
import 'package:shiftmate_pay/domain/services/overtime_allocator.dart';
import 'package:shiftmate_pay/domain/services/pay_calculation_models.dart';
import 'package:shiftmate_pay/domain/services/shift_duration_calculator.dart';

void main() {
  group('ShiftDurationCalculator', () {
    const calculator = ShiftDurationCalculator();

    test('calculates overnight paid minutes with break deduction', () {
      final shift = _buildShift(
        start: DateTime(2026, 1, 1, 22),
        end: DateTime(2026, 1, 2, 6),
        unpaidBreakMinutes: 30,
      );

      expect(calculator.calculateTotalMinutes(shift), 480);
      expect(calculator.calculatePaidMinutes(shift), 450);
    });

    test('never returns negative paid minutes when break exceeds duration', () {
      final shift = _buildShift(
        start: DateTime(2026, 1, 1, 9),
        end: DateTime(2026, 1, 1, 10),
        unpaidBreakMinutes: 90,
      );

      expect(calculator.calculatePaidMinutes(shift), 0);
    });
  });

  group('OvertimeAllocator', () {
    const allocator = OvertimeAllocator();

    test(
      'allocates daily overtime before weekly overtime without double counting',
      () {
        final allocation = allocator.allocate(
          paidMinutesByShift: const [600, 480, 480],
          dailyThresholdMinutes: 480,
          weeklyThresholdMinutes: 1500,
        );

        expect(allocation.totalMinutes, 1560);
        expect(allocation.dailyOvertimeMinutes, 120);
        expect(allocation.weeklyOvertimeMinutes, 0);
        expect(allocation.overtimeMinutes, 120);
        expect(allocation.baseMinutes, 1440);
      },
    );

    test(
      'adds remaining weekly overtime after daily overtime is accounted for',
      () {
        final allocation = allocator.allocate(
          paidMinutesByShift: const [480, 480, 480, 300],
          dailyThresholdMinutes: 480,
          weeklyThresholdMinutes: 1600,
        );

        expect(allocation.totalMinutes, 1740);
        expect(allocation.dailyOvertimeMinutes, 0);
        expect(allocation.weeklyOvertimeMinutes, 140);
        expect(allocation.baseMinutes, 1600);
      },
    );

    test('resets weekly overtime for each calendar week', () {
      final allocation = allocator.allocate(
        paidMinutesByShift: const [
          450,
          450,
          450,
          450,
          450,
          450,
          450,
          450,
          450,
          450,
          450,
          450,
          450,
          450,
          450,
          450,
        ],
        shiftStartDateTimes: [
          for (var day = 13; day <= 18; day++) DateTime(2026, 4, day, 9),
          for (var day = 20; day <= 25; day++) DateTime(2026, 4, day, 9),
          for (var day = 27; day <= 30; day++) DateTime(2026, 4, day, 9),
        ],
        dailyThresholdMinutes: 480,
        weeklyThresholdMinutes: 2400,
      );

      expect(allocation.totalMinutes, 7200);
      expect(allocation.dailyOvertimeMinutes, 0);
      expect(allocation.weeklyOvertimeMinutes, 600);
      expect(allocation.baseMinutes, 6600);
    });

    test('treats minutes exactly at thresholds as non-overtime', () {
      final allocation = allocator.allocate(
        paidMinutesByShift: const [480, 480, 480, 480, 480],
        dailyThresholdMinutes: 480,
        weeklyThresholdMinutes: 2400,
      );

      expect(allocation.totalMinutes, 2400);
      expect(allocation.dailyOvertimeMinutes, 0);
      expect(allocation.weeklyOvertimeMinutes, 0);
      expect(allocation.overtimeMinutes, 0);
      expect(allocation.baseMinutes, 2400);
    });

    test(
      'handles overtime edge cases with both daily and weekly thresholds',
      () {
        final allocation = allocator.allocate(
          paidMinutesByShift: const [720, 600, 480, 480, 480],
          dailyThresholdMinutes: 480,
          weeklyThresholdMinutes: 2280,
        );

        expect(allocation.totalMinutes, 2760);
        expect(allocation.dailyOvertimeMinutes, 360);
        expect(allocation.weeklyOvertimeMinutes, 120);
        expect(allocation.overtimeMinutes, 480);
        expect(allocation.baseMinutes, 2280);
      },
    );

    test('allocates advanced daily overtime across multiple tiers', () {
      final allocation = allocator.allocateAdvanced(
        paidMinutesByShift: const [780],
        rules: const [
          OvertimeTierRule(
            id: 'daily_ot',
            periodType: OvertimePeriodType.daily,
            thresholdMinutes: 480,
            multiplierBps: 15000,
            priority: 1,
            enabled: true,
          ),
          OvertimeTierRule(
            id: 'daily_dt',
            periodType: OvertimePeriodType.daily,
            thresholdMinutes: 720,
            multiplierBps: 20000,
            priority: 2,
            enabled: true,
          ),
        ],
      );

      expect(allocation.totalMinutes, 780);
      expect(allocation.baseMinutes, 480);
      expect(allocation.overtimeMinutes, 300);
      expect(allocation.tierAllocations, hasLength(2));
      expect(allocation.tierAllocations[0].ruleId, 'daily_ot');
      expect(allocation.tierAllocations[0].minutes, 240);
      expect(allocation.tierAllocations[1].ruleId, 'daily_dt');
      expect(allocation.tierAllocations[1].minutes, 60);
    });

    test(
      'allocates weekly tiers after subtracting daily overtime without double counting',
      () {
        final allocation = allocator.allocateAdvanced(
          paidMinutesByShift: const [600, 600, 600, 600, 600],
          rules: const [
            OvertimeTierRule(
              id: 'daily_ot',
              periodType: OvertimePeriodType.daily,
              thresholdMinutes: 480,
              multiplierBps: 15000,
              priority: 1,
              enabled: true,
            ),
            OvertimeTierRule(
              id: 'weekly_ot',
              periodType: OvertimePeriodType.weekly,
              thresholdMinutes: 2400,
              multiplierBps: 15000,
              priority: 2,
              enabled: true,
            ),
            OvertimeTierRule(
              id: 'weekly_dt',
              periodType: OvertimePeriodType.weekly,
              thresholdMinutes: 2880,
              multiplierBps: 20000,
              priority: 3,
              enabled: true,
            ),
          ],
        );

        expect(allocation.totalMinutes, 3000);
        expect(allocation.overtimeMinutes, 600);
        expect(allocation.baseMinutes, 2400);

        final daily = allocation.tierAllocations
            .where((item) => item.periodType == OvertimePeriodType.daily)
            .toList(growable: false);
        final weekly = allocation.tierAllocations
            .where((item) => item.periodType == OvertimePeriodType.weekly)
            .toList(growable: false);

        expect(daily.fold<int>(0, (sum, item) => sum + item.minutes), 600);
        expect(weekly, isEmpty);
      },
    );

    test(
      'preserves lower and higher weekly tiers when no daily overtime applies',
      () {
        final allocation = allocator.allocateAdvanced(
          paidMinutesByShift: const [660, 660, 660, 660, 660],
          rules: const [
            OvertimeTierRule(
              id: 'weekly_ot',
              periodType: OvertimePeriodType.weekly,
              thresholdMinutes: 2400,
              multiplierBps: 15000,
              priority: 1,
              enabled: true,
            ),
            OvertimeTierRule(
              id: 'weekly_dt',
              periodType: OvertimePeriodType.weekly,
              thresholdMinutes: 3000,
              multiplierBps: 20000,
              priority: 2,
              enabled: true,
            ),
          ],
        );

        expect(allocation.totalMinutes, 3300);
        expect(allocation.baseMinutes, 2400);
        expect(allocation.overtimeMinutes, 900);
        expect(allocation.tierAllocations, hasLength(2));
        expect(allocation.tierAllocations[0].ruleId, 'weekly_ot');
        expect(allocation.tierAllocations[0].minutes, 600);
        expect(allocation.tierAllocations[1].ruleId, 'weekly_dt');
        expect(allocation.tierAllocations[1].minutes, 300);
      },
    );
  });

  group('HolidayMultiplierCalculator', () {
    const calculator = HolidayMultiplierCalculator();

    test('calculates holiday premium as extra pay above base pay', () {
      final premium = calculator.calculatePremium(
        holidayMinutes: 480,
        hourlyRateMinor: 2400,
        holidayMultiplierBps: 20000,
      );

      expect(premium, 19200);
    });
  });

  group('DifferentialPayCalculator', () {
    const calculator = DifferentialPayCalculator();

    test('calculates night differential minutes across an overnight shift', () {
      final items = calculator.calculate(
        shifts: [
          _buildShift(
            start: DateTime(2026, 1, 1, 20),
            end: DateTime(2026, 1, 2, 6),
            unpaidBreakMinutes: 30,
          ),
        ],
        paidMinutesByShift: const [570],
        hourlyRateMinor: 2400,
        rules: const [
          DifferentialPayRule(
            id: 'night_rule',
            type: DifferentialRuleType.night,
            combinationMode: DifferentialCombinationMode.additivePremium,
            enabled: true,
            multiplierBps: 12500,
            startMinutesLocal: 22 * 60,
            endMinutesLocal: 6 * 60,
          ),
        ],
      );

      expect(items, hasLength(1));
      expect(items.single.minutes, 450);
      expect(items.single.amountMinor, 4500);
    });

    test(
      'calculates weekend differential minutes when shift crosses into saturday',
      () {
        final items = calculator.calculate(
          shifts: [
            _buildShift(
              start: DateTime(2026, 1, 2, 22),
              end: DateTime(2026, 1, 3, 6),
              unpaidBreakMinutes: 0,
            ),
          ],
          paidMinutesByShift: const [480],
          hourlyRateMinor: 3000,
          rules: const [
            DifferentialPayRule(
              id: 'weekend_rule',
              type: DifferentialRuleType.weekend,
              combinationMode: DifferentialCombinationMode.additivePremium,
              enabled: true,
              multiplierBps: 15000,
              appliesOnSaturday: true,
            ),
          ],
        );

        expect(items, hasLength(1));
        expect(items.single.minutes, 360);
        expect(items.single.amountMinor, 9000);
      },
    );

    test('keeps only the highest exclusive differential for a shift', () {
      final items = calculator.calculate(
        shifts: [
          _buildShift(
            start: DateTime(2026, 1, 3, 22),
            end: DateTime(2026, 1, 4, 6),
            unpaidBreakMinutes: 0,
            isHoliday: true,
          ),
        ],
        paidMinutesByShift: const [480],
        hourlyRateMinor: 2400,
        rules: const [
          DifferentialPayRule(
            id: 'weekend_exclusive',
            type: DifferentialRuleType.weekend,
            combinationMode: DifferentialCombinationMode.exclusiveHighestWins,
            enabled: true,
            multiplierBps: 15000,
            appliesOnSaturday: true,
            appliesOnSunday: true,
          ),
          DifferentialPayRule(
            id: 'holiday_exclusive',
            type: DifferentialRuleType.holiday,
            combinationMode: DifferentialCombinationMode.exclusiveHighestWins,
            enabled: true,
            multiplierBps: 20000,
          ),
        ],
      );

      expect(items, hasLength(1));
      expect(items.single.ruleId, 'holiday_exclusive');
      expect(items.single.minutes, 480);
      expect(items.single.amountMinor, 19200);
    });
  });

  group('GrossPayCalculator', () {
    const calculator = GrossPayCalculator();

    test('builds pay breakdown for base pay only', () {
      final breakdown = calculator.calculate(
        shifts: [
          _buildShift(
            start: DateTime(2026, 1, 1, 8),
            end: DateTime(2026, 1, 1, 16),
            unpaidBreakMinutes: 30,
          ),
        ],
        hourlyRateMinor: 2400,
        dailyOvertimeThresholdMinutes: 480,
        weeklyOvertimeThresholdMinutes: 2400,
        overtimeMultiplierBps: 15000,
        holidayMultiplierBps: 20000,
      );

      expect(breakdown.totalWorkedMinutes, 450);
      expect(breakdown.baseMinutes, 450);
      expect(breakdown.overtimeMinutes, 0);
      expect(breakdown.holidayMinutes, 0);
      expect(breakdown.basePayMinor, 18000);
      expect(breakdown.overtimePayMinor, 0);
      expect(breakdown.holidayPayMinor, 0);
      expect(breakdown.differentialPayMinor, 0);
      expect(breakdown.allowancePayMinor, 0);
      expect(breakdown.grossPayMinor, 18000);
      expect(breakdown.lineItems.map((item) => item.type), [
        PayLineItemType.base,
      ]);
    });

    test('covers overtime, holiday premium, and break deduction together', () {
      final breakdown = calculator.calculate(
        shifts: [
          _buildShift(
            start: DateTime(2026, 1, 1, 8),
            end: DateTime(2026, 1, 1, 19),
            unpaidBreakMinutes: 60,
            isHoliday: true,
          ),
          _buildShift(
            start: DateTime(2026, 1, 2, 8),
            end: DateTime(2026, 1, 2, 16),
            unpaidBreakMinutes: 30,
          ),
        ],
        hourlyRateMinor: 2400,
        dailyOvertimeThresholdMinutes: 480,
        weeklyOvertimeThresholdMinutes: 900,
        overtimeMultiplierBps: 15000,
        holidayMultiplierBps: 20000,
      );

      expect(breakdown.totalWorkedMinutes, 1050);
      expect(breakdown.baseMinutes, 900);
      expect(breakdown.overtimeMinutes, 150);
      expect(breakdown.holidayMinutes, 600);
      expect(breakdown.basePayMinor, 36000);
      expect(breakdown.overtimePayMinor, 9000);
      expect(breakdown.holidayPayMinor, 24000);
      expect(breakdown.differentialPayMinor, 0);
      expect(breakdown.allowancePayMinor, 0);
      expect(breakdown.grossPayMinor, 69000);
      expect(breakdown.lineItems.map((item) => item.type), [
        PayLineItemType.base,
        PayLineItemType.overtime,
        PayLineItemType.holidayPremium,
      ]);
    });

    test('handles overnight holiday shifts that cross month boundaries', () {
      final breakdown = calculator.calculate(
        shifts: [
          _buildShift(
            start: DateTime(2024, 2, 29, 22),
            end: DateTime(2024, 3, 1, 6),
            unpaidBreakMinutes: 30,
            isHoliday: true,
          ),
        ],
        hourlyRateMinor: 3000,
        dailyOvertimeThresholdMinutes: 480,
        weeklyOvertimeThresholdMinutes: 2400,
        overtimeMultiplierBps: 15000,
        holidayMultiplierBps: 20000,
      );

      expect(breakdown.totalWorkedMinutes, 450);
      expect(breakdown.baseMinutes, 450);
      expect(breakdown.overtimeMinutes, 0);
      expect(breakdown.holidayMinutes, 450);
      expect(breakdown.basePayMinor, 22500);
      expect(breakdown.holidayPayMinor, 22500);
      expect(breakdown.differentialPayMinor, 0);
      expect(breakdown.allowancePayMinor, 0);
      expect(breakdown.grossPayMinor, 45000);
    });

    test('calculates weekly overtime per week for multi-week forecasts', () {
      final shifts = [
        for (var day = 13; day <= 18; day++)
          _buildShift(
            start: DateTime(2026, 4, day, 9),
            end: DateTime(2026, 4, day, 17),
            unpaidBreakMinutes: 30,
          ),
        for (var day = 20; day <= 25; day++)
          _buildShift(
            start: DateTime(2026, 4, day, 9),
            end: DateTime(2026, 4, day, 17),
            unpaidBreakMinutes: 30,
          ),
        for (var day = 27; day <= 30; day++)
          _buildShift(
            start: DateTime(2026, 4, day, 9),
            end: DateTime(2026, 4, day, 17),
            unpaidBreakMinutes: 30,
          ),
      ];

      final breakdown = calculator.calculate(
        shifts: shifts,
        hourlyRateMinor: 2500,
        dailyOvertimeThresholdMinutes: 480,
        weeklyOvertimeThresholdMinutes: 2400,
        overtimeMultiplierBps: 15000,
        holidayMultiplierBps: 20000,
      );

      expect(breakdown.totalWorkedMinutes, 7200);
      expect(breakdown.baseMinutes, 6600);
      expect(breakdown.overtimeMinutes, 600);
      expect(breakdown.basePayMinor, 275000);
      expect(breakdown.overtimePayMinor, 37500);
      expect(breakdown.grossPayMinor, 312500);
    });

    test('adds differential premiums when advanced rules are enabled', () {
      final breakdown = calculator.calculate(
        shifts: [
          _buildShift(
            start: DateTime(2026, 1, 3, 22),
            end: DateTime(2026, 1, 4, 6),
            unpaidBreakMinutes: 30,
          ),
        ],
        hourlyRateMinor: 2400,
        dailyOvertimeThresholdMinutes: 480,
        weeklyOvertimeThresholdMinutes: 2400,
        overtimeMultiplierBps: 15000,
        holidayMultiplierBps: 20000,
        advancedPayRuleSet: AdvancedPayRuleSet(
          id: 'advanced_1',
          jobId: 'job-1',
          enabled: true,
          overtimeRules: const [],
          differentialRules: const [
            DifferentialPayRule(
              id: 'night_rule',
              type: DifferentialRuleType.night,
              combinationMode: DifferentialCombinationMode.additivePremium,
              enabled: true,
              multiplierBps: 12500,
              startMinutesLocal: 22 * 60,
              endMinutesLocal: 6 * 60,
            ),
            DifferentialPayRule(
              id: 'weekend_rule',
              type: DifferentialRuleType.weekend,
              combinationMode: DifferentialCombinationMode.additivePremium,
              enabled: true,
              multiplierBps: 15000,
              appliesOnSunday: true,
            ),
          ],
          allowanceRules: const [],
          breakRules: const [],
          version: 1,
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
      );

      expect(breakdown.totalWorkedMinutes, 450);
      expect(breakdown.differentialMinutes, 780);
      expect(breakdown.differentialPayMinor, 11100);
      expect(breakdown.allowancePayMinor, 0);
      expect(breakdown.grossPayMinor, 29100);
      expect(
        breakdown.lineItems.where(
          (item) => item.type == PayLineItemType.differential,
        ),
        hasLength(2),
      );
      expect(
        breakdown.lineItems
            .where((item) => item.type == PayLineItemType.differential)
            .map((item) => item.label),
        ['Night differential', 'Weekend differential'],
      );
    });

    test(
      'applies advanced break overrides and allowance totals when rules match',
      () {
        final templateSnapshot = ShiftTemplateSnapshot(
          templateId: 'template-night',
          name: 'Night',
          category: ShiftCategory.night,
          startMinutesLocal: 22 * 60,
          endMinutesLocal: 6 * 60,
          unpaidBreakMinutes: 30,
          defaultNote: null,
        );

        final breakdown = calculator.calculate(
          shifts: [
            ShiftInstance(
              id: 'shift-1',
              jobId: 'job-1',
              date: DateTime(2026, 1, 4),
              templateSnapshot: templateSnapshot,
              startDateTime: DateTime(2026, 1, 4, 22),
              endDateTime: DateTime(2026, 1, 5, 6),
              unpaidBreakMinutes: 30,
              source: ShiftSource.pattern,
              note: null,
              isHoliday: true,
              overrideType: null,
            ),
          ],
          hourlyRateMinor: 2400,
          dailyOvertimeThresholdMinutes: 480,
          weeklyOvertimeThresholdMinutes: 2400,
          overtimeMultiplierBps: 15000,
          holidayMultiplierBps: 20000,
          advancedPayRuleSet: AdvancedPayRuleSet(
            id: 'advanced-2',
            jobId: 'job-1',
            enabled: true,
            overtimeRules: const [],
            differentialRules: const [],
            allowanceRules: const [
              AllowancePayRule(
                id: 'allow-shift',
                type: AllowanceRuleType.perShift,
                amountMinor: 1200,
                enabled: true,
                shiftTemplateId: 'template-night',
              ),
              AllowancePayRule(
                id: 'allow-period',
                type: AllowanceRuleType.perPeriod,
                amountMinor: 800,
                enabled: true,
                appliesOnHoliday: true,
              ),
            ],
            breakRules: const [
              AdvancedBreakRule(
                id: 'night-break',
                minutes: 45,
                enabled: true,
                shiftTemplateId: 'template-night',
              ),
            ],
            version: 1,
            createdAt: DateTime.utc(2026, 1, 1),
            updatedAt: DateTime.utc(2026, 1, 1),
          ),
        );

        expect(breakdown.totalWorkedMinutes, 435);
        expect(breakdown.baseMinutes, 435);
        expect(breakdown.basePayMinor, 17400);
        expect(breakdown.holidayPayMinor, 17400);
        expect(breakdown.allowancePayMinor, 2000);
        expect(breakdown.grossPayMinor, 36800);
        expect(
          breakdown.lineItems.where(
            (item) => item.type == PayLineItemType.allowance,
          ),
          hasLength(2),
        );
        expect(
          breakdown.lineItems
              .where((item) => item.type == PayLineItemType.allowance)
              .map((item) => item.label),
          ['Per-shift allowance', 'Per-period allowance'],
        );
      },
    );
  });
}

ShiftInstance _buildShift({
  required DateTime start,
  required DateTime end,
  required Minutes unpaidBreakMinutes,
  bool isHoliday = false,
}) {
  return ShiftInstance(
    id: 'shift-${start.toIso8601String()}',
    jobId: 'job-1',
    date: DateTime(start.year, start.month, start.day),
    templateSnapshot: null,
    startDateTime: start,
    endDateTime: end,
    unpaidBreakMinutes: unpaidBreakMinutes,
    source: ShiftSource.pattern,
    note: null,
    isHoliday: isHoliday,
    overrideType: null,
  );
}
