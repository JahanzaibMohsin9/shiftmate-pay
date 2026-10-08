import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shiftmate_pay/app/theme/app_theme.dart';
import 'package:shiftmate_pay/core/money/currency_amount.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/data/local/preferences/app_preferences.dart';
import 'package:shiftmate_pay/data/local/database/database_providers.dart';
import 'package:shiftmate_pay/domain/entities/actual_payslip.dart';
import 'package:shiftmate_pay/domain/entities/job.dart';
import 'package:shiftmate_pay/domain/entities/pay_verification.dart';
import 'package:shiftmate_pay/domain/usecases/usecases.dart';
import 'package:shiftmate_pay/features/pay/application/pay_verification_providers.dart';
import 'package:shiftmate_pay/features/pay/presentation/screens/pay_verification_screen.dart';

void main() {
  final args = PayVerificationRouteArgs(
    jobId: 'job-1',
    periodStart: DateTime.utc(2026, 4, 1),
    periodEnd: DateTime.utc(2026, 4, 7),
  );

  testWidgets('premium users see review notes', (tester) async {
    await _pumpScreen(
      tester,
      args: args,
      premiumUnlocked: true,
      verificationSummary: _verificationSummary(args.range),
    );

    expect(find.text('Compare with payslip'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Expected vs actual'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Expected vs actual'), findsOneWidget);
    expect(find.text('Review notes'), findsOneWidget);
    expect(find.text('Possible missing overtime pay'), findsOneWidget);
  });

  testWidgets('free users see a premium gate for discrepancy details', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      args: args,
      premiumUnlocked: false,
      verificationSummary: _verificationSummary(args.range),
    );

    await tester.scrollUntilVisible(
      find.text('Expected vs actual'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Expected vs actual'), findsOneWidget);
    expect(find.text('Unlock detailed review notes'), findsOneWidget);
    expect(find.text('See Premium review tools'), findsOneWidget);
  });
}

Future<void> _pumpScreen(
  WidgetTester tester, {
  required PayVerificationRouteArgs args,
  required bool premiumUnlocked,
  required PayVerificationSummary verificationSummary,
}) async {
  SharedPreferences.setMockInitialValues({'premium_unlocked': premiumUnlocked});
  final preferences = AppPreferences(await SharedPreferences.getInstance());
  final viewData = PayVerificationViewData(
    job: Job(
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
    ),
    expectedSummary: PayPeriodSummary(
      jobId: 'job-1',
      range: args.range,
      currencyCode: 'USD',
      periodLabel: '1-7 Apr 2026',
      totalWorkedMinutes: 2280,
      totalShifts: 5,
      holidayShifts: 1,
      basePay: 80000,
      overtimePay: 12000,
      doubleTimePay: 0,
      holidayPay: 3000,
      allowancePay: 2500,
      differentialPay: 4500,
      grossPay: 102000,
      doubleTimeEnabled: false,
      breakdownItems: const [],
    ),
    existingPayslip: ActualPayslip(
      id: 'payslip-1',
      jobId: 'job-1',
      periodStart: args.periodStart,
      periodEnd: args.periodEnd,
      paidAt: DateTime.utc(2026, 4, 8),
      grossPayMinor: 97000,
      workedMinutesReported: 2280,
      overtimePayMinor: 7000,
      holidayPayMinor: 3000,
      allowancesMinor: 7000,
      notes: null,
      source: ActualPayslipSource.manual,
      createdAt: DateTime.utc(2026, 4, 8),
      updatedAt: DateTime.utc(2026, 4, 8),
    ),
    verificationSummary: verificationSummary,
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appPreferencesProvider.overrideWithValue(preferences),
        payVerificationViewProvider(args).overrideWith((ref) async => viewData),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: PayVerificationScreen(
          jobId: args.jobId,
          periodStart: args.periodStart,
          periodEnd: args.periodEnd,
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

PayVerificationSummary _verificationSummary(AppDateRange range) {
  return PayVerificationSummary(
    jobId: 'job-1',
    range: range,
    currencyCode: 'USD',
    expectedGrossPayMinor: 102000,
    actualGrossPayMinor: 97000,
    totalVarianceMinor: -5000,
    varianceDirection: PayVerificationVarianceDirection.underpaid,
    confidence: PayVerificationConfidence.high,
    comparisonType: PayVerificationComparisonType.exact,
    categoryDeltas: const [
      PayVerificationCategoryDelta(
        category: PayVerificationCategory.gross,
        expectedValue: 102000,
        actualValue: 97000,
        deltaValue: -5000,
        hasActualValue: true,
      ),
      PayVerificationCategoryDelta(
        category: PayVerificationCategory.overtime,
        expectedValue: 12000,
        actualValue: 7000,
        deltaValue: -5000,
        hasActualValue: true,
      ),
      PayVerificationCategoryDelta(
        category: PayVerificationCategory.holiday,
        expectedValue: 3000,
        actualValue: 3000,
        deltaValue: 0,
        hasActualValue: true,
      ),
      PayVerificationCategoryDelta(
        category: PayVerificationCategory.allowances,
        expectedValue: 7000,
        actualValue: 7000,
        deltaValue: 0,
        hasActualValue: true,
      ),
      PayVerificationCategoryDelta(
        category: PayVerificationCategory.workedMinutes,
        expectedValue: 2280,
        actualValue: 2280,
        deltaValue: 0,
        hasActualValue: true,
      ),
    ],
    comparisonWarnings: const [],
    discrepancies: const [
      PayVerificationDiscrepancy(
        type: PayVerificationDiscrepancyType.missingOvertime,
        title: 'Possible missing overtime pay',
        explanation:
            'Expected overtime pay for this period looks higher than the overtime amount currently entered from your payslip.',
        suggestedNextStep:
            'Check whether overtime hours were paid at the correct rate, or add more payslip detail before treating this as a payroll issue.',
        severity: PayVerificationDiscrepancySeverity.high,
        confidence: PayVerificationConfidence.high,
        expectedValue: 12000,
        actualValue: 7000,
      ),
    ],
  );
}
