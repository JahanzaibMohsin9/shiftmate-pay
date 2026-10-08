import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/domain/entities/pay_verification.dart';
import 'package:shiftmate_pay/domain/services/pay_discrepancy_detector.dart';

void main() {
  const detector = PayDiscrepancyDetector();
  final range = AppDateRange(
    start: DateTime.utc(2026, 4, 1),
    end: DateTime.utc(2026, 4, 7),
  );

  test('classifies missing overtime and missing allowance issues', () {
    final summary = _summary(
      range: range,
      confidence: PayVerificationConfidence.high,
      totalVarianceMinor: -8000,
      categoryDeltas: const [
        PayVerificationCategoryDelta(
          category: PayVerificationCategory.gross,
          expectedValue: 102000,
          actualValue: 94000,
          deltaValue: -8000,
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
          actualValue: 4000,
          deltaValue: -3000,
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
    );

    final discrepancies = detector.detect(summary);

    expect(
      discrepancies.map((item) => item.type),
      contains(PayVerificationDiscrepancyType.missingOvertime),
    );
    expect(
      discrepancies.map((item) => item.type),
      contains(PayVerificationDiscrepancyType.missingAllowance),
    );
  });

  test('classifies missing shift from worked-minute mismatch', () {
    final summary = _summary(
      range: range,
      confidence: PayVerificationConfidence.high,
      totalVarianceMinor: -9000,
      categoryDeltas: const [
        PayVerificationCategoryDelta(
          category: PayVerificationCategory.gross,
          expectedValue: 102000,
          actualValue: 93000,
          deltaValue: -9000,
          hasActualValue: true,
        ),
        PayVerificationCategoryDelta(
          category: PayVerificationCategory.overtime,
          expectedValue: 12000,
          actualValue: 12000,
          deltaValue: 0,
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
          actualValue: 1800,
          deltaValue: -480,
          hasActualValue: true,
        ),
      ],
    );

    final discrepancies = detector.detect(summary);

    expect(
      discrepancies.map((item) => item.type),
      contains(PayVerificationDiscrepancyType.missingOrExtraShift),
    );
  });

  test(
    'adds incomplete-data and complex-rule guidance when confidence is low',
    () {
      final summary = _summary(
        range: range,
        confidence: PayVerificationConfidence.low,
        comparisonType: PayVerificationComparisonType.likely,
        totalVarianceMinor: -2000,
        comparisonWarnings: const [
          'Expected pay includes allowances or differentials, but the payslip detail breakdown does not include them yet.',
        ],
        categoryDeltas: const [
          PayVerificationCategoryDelta(
            category: PayVerificationCategory.gross,
            expectedValue: 102000,
            actualValue: 100000,
            deltaValue: -2000,
            hasActualValue: true,
          ),
          PayVerificationCategoryDelta(
            category: PayVerificationCategory.overtime,
            expectedValue: 12000,
            actualValue: null,
            deltaValue: null,
            hasActualValue: false,
          ),
          PayVerificationCategoryDelta(
            category: PayVerificationCategory.holiday,
            expectedValue: 3000,
            actualValue: null,
            deltaValue: null,
            hasActualValue: false,
          ),
          PayVerificationCategoryDelta(
            category: PayVerificationCategory.allowances,
            expectedValue: 7000,
            actualValue: null,
            deltaValue: null,
            hasActualValue: false,
          ),
          PayVerificationCategoryDelta(
            category: PayVerificationCategory.workedMinutes,
            expectedValue: 2280,
            actualValue: null,
            deltaValue: null,
            hasActualValue: false,
          ),
        ],
      );

      final discrepancies = detector.detect(summary);

      expect(
        discrepancies.map((item) => item.type),
        contains(PayVerificationDiscrepancyType.incompletePayslipData),
      );
      expect(
        discrepancies.map((item) => item.type),
        contains(PayVerificationDiscrepancyType.unsupportedRuleComplexity),
      );
    },
  );
}

PayVerificationSummary _summary({
  required AppDateRange range,
  required int totalVarianceMinor,
  required PayVerificationConfidence confidence,
  required List<PayVerificationCategoryDelta> categoryDeltas,
  PayVerificationComparisonType comparisonType =
      PayVerificationComparisonType.exact,
  List<String> comparisonWarnings = const [],
}) {
  return PayVerificationSummary(
    jobId: 'job-1',
    range: range,
    currencyCode: 'USD',
    expectedGrossPayMinor: 102000,
    actualGrossPayMinor: 100000,
    totalVarianceMinor: totalVarianceMinor,
    varianceDirection: totalVarianceMinor == 0
        ? PayVerificationVarianceDirection.match
        : PayVerificationVarianceDirection.underpaid,
    confidence: confidence,
    comparisonType: comparisonType,
    categoryDeltas: categoryDeltas,
    comparisonWarnings: comparisonWarnings,
    discrepancies: const [],
  );
}
