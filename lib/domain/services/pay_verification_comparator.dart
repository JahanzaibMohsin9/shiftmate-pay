import '../entities/actual_payslip.dart';
import '../entities/pay_verification.dart';
import '../usecases/usecases.dart';

class PayVerificationComparator {
  const PayVerificationComparator();

  PayVerificationSummary compare({
    required PayPeriodSummary expected,
    required ActualPayslip actual,
  }) {
    final totalVarianceMinor = actual.grossPayMinor - expected.grossPay;
    final categoryDeltas = <PayVerificationCategoryDelta>[
      PayVerificationCategoryDelta(
        category: PayVerificationCategory.gross,
        expectedValue: expected.grossPay,
        actualValue: actual.grossPayMinor,
        deltaValue: totalVarianceMinor,
        hasActualValue: true,
      ),
      _optionalMoneyDelta(
        category: PayVerificationCategory.overtime,
        expectedValue: expected.overtimePay,
        actualValue: actual.overtimePayMinor,
      ),
      _optionalMoneyDelta(
        category: PayVerificationCategory.holiday,
        expectedValue: expected.holidayPay,
        actualValue: actual.holidayPayMinor,
      ),
      _optionalMoneyDelta(
        category: PayVerificationCategory.allowances,
        expectedValue: expected.allowancePay + expected.differentialPay,
        actualValue: actual.allowancesMinor,
      ),
      _optionalMinutesDelta(
        category: PayVerificationCategory.workedMinutes,
        expectedValue: expected.totalWorkedMinutes,
        actualValue: actual.workedMinutesReported,
      ),
    ];

    final warnings = <String>[];
    final detailedFieldsProvided =
        actual.overtimePayMinor != null ||
        actual.holidayPayMinor != null ||
        actual.allowancesMinor != null ||
        actual.workedMinutesReported != null;
    final missingOptionalFields = [
      actual.overtimePayMinor,
      actual.holidayPayMinor,
      actual.allowancesMinor,
      actual.workedMinutesReported,
    ].where((value) => value == null).length;
    final advancedExpectedAmounts =
        expected.allowancePay > 0 || expected.differentialPay > 0;

    if (!detailedFieldsProvided) {
      warnings.add(
        'Compared using gross pay only. Add more payslip detail if you want clearer review notes.',
      );
    }
    if (missingOptionalFields > 0 && detailedFieldsProvided) {
      warnings.add(
        'Some payslip detail fields are still missing, so category-level review notes may be incomplete.',
      );
    }
    if (advancedExpectedAmounts && actual.allowancesMinor == null) {
      warnings.add(
        'Expected pay includes allowances or differentials, but the payslip detail breakdown does not include them yet.',
      );
    }

    final confidence = _confidence(
      detailedFieldsProvided: detailedFieldsProvided,
      missingOptionalFields: missingOptionalFields,
      advancedExpectedAmounts: advancedExpectedAmounts,
      totalVarianceMinor: totalVarianceMinor,
    );
    final comparisonType =
        detailedFieldsProvided &&
            (actual.overtimePayMinor != null || expected.overtimePay == 0) &&
            (actual.holidayPayMinor != null || expected.holidayPay == 0) &&
            (actual.allowancesMinor != null ||
                (expected.allowancePay + expected.differentialPay) == 0)
        ? PayVerificationComparisonType.exact
        : PayVerificationComparisonType.likely;

    return PayVerificationSummary(
      jobId: expected.jobId,
      range: expected.range,
      currencyCode: expected.currencyCode,
      expectedGrossPayMinor: expected.grossPay,
      actualGrossPayMinor: actual.grossPayMinor,
      totalVarianceMinor: totalVarianceMinor,
      varianceDirection: _direction(totalVarianceMinor, confidence),
      confidence: confidence,
      comparisonType: comparisonType,
      categoryDeltas: categoryDeltas,
      comparisonWarnings: warnings,
      discrepancies: const [],
    );
  }

  PayVerificationCategoryDelta _optionalMoneyDelta({
    required PayVerificationCategory category,
    required int expectedValue,
    required int? actualValue,
  }) {
    return PayVerificationCategoryDelta(
      category: category,
      expectedValue: expectedValue,
      actualValue: actualValue,
      deltaValue: actualValue == null ? null : actualValue - expectedValue,
      hasActualValue: actualValue != null,
    );
  }

  PayVerificationCategoryDelta _optionalMinutesDelta({
    required PayVerificationCategory category,
    required int expectedValue,
    required int? actualValue,
  }) {
    return PayVerificationCategoryDelta(
      category: category,
      expectedValue: expectedValue,
      actualValue: actualValue,
      deltaValue: actualValue == null ? null : actualValue - expectedValue,
      hasActualValue: actualValue != null,
    );
  }

  PayVerificationConfidence _confidence({
    required bool detailedFieldsProvided,
    required int missingOptionalFields,
    required bool advancedExpectedAmounts,
    required int totalVarianceMinor,
  }) {
    if (!detailedFieldsProvided) {
      return totalVarianceMinor == 0
          ? PayVerificationConfidence.medium
          : PayVerificationConfidence.low;
    }
    if (advancedExpectedAmounts && missingOptionalFields >= 2) {
      return PayVerificationConfidence.low;
    }
    if (missingOptionalFields > 1) {
      return PayVerificationConfidence.medium;
    }
    return PayVerificationConfidence.high;
  }

  PayVerificationVarianceDirection _direction(
    int totalVarianceMinor,
    PayVerificationConfidence confidence,
  ) {
    if (confidence == PayVerificationConfidence.low &&
        totalVarianceMinor != 0) {
      return PayVerificationVarianceDirection.uncertain;
    }
    if (totalVarianceMinor == 0) {
      return PayVerificationVarianceDirection.match;
    }
    if (totalVarianceMinor < 0) {
      return PayVerificationVarianceDirection.underpaid;
    }
    return PayVerificationVarianceDirection.overpaid;
  }
}
