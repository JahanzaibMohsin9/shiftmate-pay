import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shiftmate_pay/app/theme/app_theme.dart';
import 'package:shiftmate_pay/core/common/result.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/core/money/currency_amount.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/data/local/database/database_providers.dart';
import 'package:shiftmate_pay/data/local/preferences/app_preferences.dart';
import 'package:shiftmate_pay/domain/entities/income_forecast.dart';
import 'package:shiftmate_pay/domain/entities/job.dart';
import 'package:shiftmate_pay/domain/entities/shift_template.dart';
import 'package:shiftmate_pay/domain/usecases/usecases.dart';
import 'package:shiftmate_pay/features/jobs/application/jobs_providers.dart';
import 'package:shiftmate_pay/features/pay/presentation/screens/forecast_screen.dart';

void main() {
  final anchor = DateTime.utc(2026, 4, 1);
  final job = Job(
    id: 'job-1',
    name: 'Hospital nights',
    colorHex: '#4F46E5',
    currencyCode: 'USD',
    hourlyRate: const CurrencyAmount(minorUnits: 3000, currencyCode: 'USD'),
    payRuleSetId: 'pay-rules-1',
    holidayRuleSetId: 'holiday-rules-1',
    defaultSleepLeadMinutes: 480,
    isArchived: false,
    createdAt: DateTime.utc(2026, 4, 1),
    updatedAt: DateTime.utc(2026, 4, 1),
  );
  final template = const ShiftTemplate(
    id: 'template-night',
    jobId: 'job-1',
    name: 'Night shift',
    startMinutesLocal: 20 * 60,
    endMinutesLocal: 8 * 60,
    unpaidBreakMinutes: 0,
    category: ShiftCategory.night,
    defaultNote: null,
  );

  testWidgets('shows empty forecast state when no future coverage exists', (
    tester,
  ) async {
    await _pumpForecastScreen(
      tester,
      premiumUnlocked: false,
      anchor: anchor,
      job: job,
      template: template,
      summary: _summary(
        range: AppDateRange(
          start: anchor,
          end: anchor.add(const Duration(days: 29)),
        ),
        projectedGrossPayMinor: 0,
        projectedWorkedMinutes: 0,
        projectedShiftCount: 0,
        coverage: const ForecastCoverage(
          daysCovered: 0,
          daysTotal: 30,
          coverageRatio: 0,
          coveredShiftCount: 0,
          uncoveredDayCount: 30,
        ),
        confidence: ForecastConfidenceLevel.low,
        confidenceWarnings: const [
          'No future shifts are currently scheduled for much of this range yet.',
        ],
      ),
    );

    expect(find.text('No future shifts in this window'), findsOneWidget);
    expect(
      find.textContaining('Once this window has some future coverage'),
      findsOneWidget,
    );
  });

  testWidgets(
    'shows partial-coverage scenario card and premium teaser for free users',
    (tester) async {
      await _pumpForecastScreen(
        tester,
        premiumUnlocked: false,
        anchor: anchor,
        job: job,
        template: template,
        summary: _summary(
          range: AppDateRange(
            start: anchor,
            end: anchor.add(const Duration(days: 29)),
          ),
          projectedGrossPayMinor: 180000,
          projectedWorkedMinutes: 3600,
          projectedShiftCount: 10,
          coverage: const ForecastCoverage(
            daysCovered: 15,
            daysTotal: 30,
            coverageRatio: 0.5,
            coveredShiftCount: 10,
            uncoveredDayCount: 15,
          ),
          confidence: ForecastConfidenceLevel.medium,
          confidenceWarnings: const [
            'Only part of this window has scheduled shifts, so this total may be lower than what you actually earn.',
          ],
        ),
      );

      expect(find.text('Best-case pace scenario'), findsOneWidget);
      expect(find.text('Unlock full forecast insights'), findsOneWidget);
      expect(find.text('Confidence notes'), findsOneWidget);
    },
  );

  testWidgets('shows high-confidence forecast insights for premium users', (
    tester,
  ) async {
    await _pumpForecastScreen(
      tester,
      premiumUnlocked: true,
      anchor: anchor,
      job: job,
      template: template,
      summary: _summary(
        range: AppDateRange(
          start: anchor,
          end: anchor.add(const Duration(days: 89)),
        ),
        projectedGrossPayMinor: 540000,
        projectedWorkedMinutes: 10800,
        projectedShiftCount: 30,
        coverage: const ForecastCoverage(
          daysCovered: 90,
          daysTotal: 90,
          coverageRatio: 1,
          coveredShiftCount: 30,
          uncoveredDayCount: 0,
        ),
        confidence: ForecastConfidenceLevel.high,
        confidenceWarnings: const [],
        nudges: const [
          ForecastNudge(
            id: 'goal_on_track',
            severity: ForecastNudgeSeverity.info,
            message:
                'You are currently on pace for this earnings goal based on the scheduled shifts in view.',
          ),
        ],
      ),
    );

    expect(find.text('Current schedule forecast'), findsOneWidget);
    expect(find.text('Extra-shift simulation'), findsOneWidget);
    expect(find.text('Added pay'), findsOneWidget);
    expect(find.text('Planning targets'), findsOneWidget);
    expect(find.text('Planning nudges'), findsOneWidget);
    expect(
      find.textContaining('on pace for this earnings goal'),
      findsOneWidget,
    );
  });
}

Future<void> _pumpForecastScreen(
  WidgetTester tester, {
  required bool premiumUnlocked,
  required DateTime anchor,
  required Job job,
  required ShiftTemplate template,
  required IncomeForecastSummary summary,
}) async {
  SharedPreferences.setMockInitialValues({'premium_unlocked': premiumUnlocked});
  final preferences = AppPreferences(await SharedPreferences.getInstance());

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appPreferencesProvider.overrideWithValue(preferences),
        jobsProvider.overrideWith((ref) async => [job]),
        shiftTemplatesForJobProvider(
          job.id,
        ).overrideWith((ref) async => [template]),
        getIncomeForecastUseCaseProvider.overrideWithValue(
          _FakeGetIncomeForecastUseCase(summary),
        ),
        simulateExtraShiftForecastUseCaseProvider.overrideWithValue(
          _FakeSimulateExtraShiftForecastUseCase(
            ForecastShiftSimulationResult(
              jobId: job.id,
              range: summary.range,
              simulatedDate: summary.range.start,
              templateId: template.id,
              templateName: template.name,
              currencyCode: summary.currencyCode,
              baselineGrossPayMinor: summary.projectedGrossPayMinor,
              updatedGrossPayMinor: summary.projectedGrossPayMinor + 32000,
              additionalGrossPayMinor: 32000,
              additionalBasePayMinor: 20000,
              additionalOvertimePayMinor: 8000,
              additionalHolidayPayMinor: 0,
              additionalAllowancePayMinor: 1000,
              additionalDifferentialPayMinor: 3000,
              additionalWorkedMinutes: 720,
              updatedShiftCount: summary.projectedShiftCount + 1,
              baselineCoverage: summary.coverage,
              updatedCoverage: ForecastCoverage(
                daysCovered: summary.coverage.daysCovered + 1,
                daysTotal: summary.coverage.daysTotal,
                coverageRatio:
                    (summary.coverage.daysCovered + 1) /
                    summary.coverage.daysTotal,
                coveredShiftCount: summary.coverage.coveredShiftCount + 1,
                uncoveredDayCount: summary.coverage.uncoveredDayCount - 1,
              ),
              baselineConfidence: summary.confidence,
              updatedConfidence: summary.confidence,
              triggeredChanges: const [
                ForecastShiftSimulationTrigger.overtime,
                ForecastShiftSimulationTrigger.differential,
              ],
              goalStatusBefore: null,
              goalStatusAfter: null,
              overtimeStatusBefore: null,
              overtimeStatusAfter: null,
            ),
          ),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: ForecastScreen(initialJobId: job.id, initialAnchorDate: anchor),
      ),
    ),
  );

  await tester.pump();
  await tester.pumpAndSettle();
}

IncomeForecastSummary _summary({
  required AppDateRange range,
  required int projectedGrossPayMinor,
  required int projectedWorkedMinutes,
  required int projectedShiftCount,
  required ForecastCoverage coverage,
  required ForecastConfidenceLevel confidence,
  required List<String> confidenceWarnings,
  List<ForecastNudge> nudges = const [],
}) {
  return IncomeForecastSummary(
    jobId: 'job-1',
    range: range,
    windowPreset: ForecastWindowPreset.days30,
    currencyCode: 'USD',
    projectedGrossPayMinor: projectedGrossPayMinor,
    projectedBasePayMinor: projectedGrossPayMinor,
    projectedOvertimePayMinor: 0,
    projectedHolidayPayMinor: 0,
    projectedAllowancePayMinor: 0,
    projectedDifferentialPayMinor: 0,
    projectedWorkedMinutes: projectedWorkedMinutes,
    projectedShiftCount: projectedShiftCount,
    coverage: coverage,
    confidence: confidence,
    confidenceWarnings: confidenceWarnings,
    goalProgress: null,
    overtimeProgress: null,
    nudges: nudges,
  );
}

class _FakeGetIncomeForecastUseCase implements GetIncomeForecastUseCase {
  _FakeGetIncomeForecastUseCase(this.summary);

  final IncomeForecastSummary summary;

  @override
  Future<Result<IncomeForecastSummary>> call({
    required String jobId,
    required AppDateRange range,
    required ForecastWindowPreset windowPreset,
    int? monthlyGoalMinor,
    int? monthlyOvertimeTargetMinutes,
    DateTime? goalMonthAnchor,
  }) async => Success(summary);
}

class _FakeSimulateExtraShiftForecastUseCase
    implements SimulateExtraShiftForecastUseCase {
  _FakeSimulateExtraShiftForecastUseCase(this.simulation);

  final ForecastShiftSimulationResult simulation;

  @override
  Future<Result<ForecastShiftSimulationResult>> call({
    required String jobId,
    required AppDateRange range,
    required String shiftTemplateId,
    required DateTime simulatedDate,
    int? monthlyGoalMinor,
    int? monthlyOvertimeTargetMinutes,
    DateTime? goalMonthAnchor,
  }) async => Success(simulation);
}
