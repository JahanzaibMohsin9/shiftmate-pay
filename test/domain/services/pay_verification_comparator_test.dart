import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/domain/entities/actual_payslip.dart';
import 'package:shiftmate_pay/domain/entities/pay_verification.dart';
import 'package:shiftmate_pay/domain/services/pay_verification_comparator.dart';
import 'package:shiftmate_pay/domain/usecases/usecases.dart';

void main() {
  const comparator = PayVerificationComparator();
  final range = AppDateRange(
    start: DateTime.utc(2026, 4, 1),
    end: DateTime.utc(2026, 4, 7),
  );

  test(
    'returns an exact high-confidence match when detailed fields line up',
    () {
      final summary = comparator.compare(
        expected: _expectedSummary(range: range),
        actual: _actualPayslip(
          grossPayMinor: 102000,
          overtimePayMinor: 12000,
          holidayPayMinor: 3000,
          allowancesMinor: 7000,
          workedMinutesReported: 2280,
        ),
      );

      expect(summary.totalVarianceMinor, 0);
      expect(summary.varianceDirection, PayVerificationVarianceDirection.match);
      expect(summary.confidence, PayVerificationConfidence.high);
      expect(summary.comparisonType, PayVerificationComparisonType.exact);
      expect(summary.comparisonWarnings, isEmpty);
    },
  );

  test('reports underpayment when actual gross is lower than expected', () {
    final summary = comparator.compare(
      expected: _expectedSummary(range: range),
      actual: _actualPayslip(grossPayMinor: 98000),
    );

    expect(summary.totalVarianceMinor, -4000);
    expect(
      summary.varianceDirection,
      PayVerificationVarianceDirection.uncertain,
    );
    expect(summary.confidence, PayVerificationConfidence.low);
    expect(summary.comparisonType, PayVerificationComparisonType.likely);
  });

  test('reports overpayment when actual gross is higher than expected', () {
    final summary = comparator.compare(
      expected: _expectedSummary(range: range),
      actual: _actualPayslip(
        grossPayMinor: 104500,
        overtimePayMinor: 14000,
        holidayPayMinor: 3000,
        allowancesMinor: 7000,
      ),
    );

    expect(summary.totalVarianceMinor, 2500);
    expect(
      summary.varianceDirection,
      PayVerificationVarianceDirection.overpaid,
    );
    expect(summary.categoryDeltas.first.deltaValue, 2500);
  });

  test(
    'keeps comparing when optional fields are missing and lowers confidence',
    () {
      final summary = comparator.compare(
        expected: _expectedSummary(range: range),
        actual: _actualPayslip(grossPayMinor: 102000, overtimePayMinor: 12000),
      );

      expect(summary.confidence, PayVerificationConfidence.low);
      expect(summary.comparisonType, PayVerificationComparisonType.likely);
      expect(
        summary.categoryDeltas
            .singleWhere(
              (item) => item.category == PayVerificationCategory.holiday,
            )
            .hasActualValue,
        isFalse,
      );
      expect(summary.comparisonWarnings, isNotEmpty);
    },
  );
}

PayPeriodSummary _expectedSummary({required AppDateRange range}) {
  return PayPeriodSummary(
    jobId: 'job-1',
    range: range,
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
  );
}

ActualPayslip _actualPayslip({
  required int grossPayMinor,
  int? workedMinutesReported,
  int? overtimePayMinor,
  int? holidayPayMinor,
  int? allowancesMinor,
}) {
  final now = DateTime.utc(2026, 4, 8);
  return ActualPayslip(
    id: 'payslip-1',
    jobId: 'job-1',
    periodStart: DateTime.utc(2026, 4, 1),
    periodEnd: DateTime.utc(2026, 4, 7),
    paidAt: now,
    grossPayMinor: grossPayMinor,
    workedMinutesReported: workedMinutesReported,
    overtimePayMinor: overtimePayMinor,
    holidayPayMinor: holidayPayMinor,
    allowancesMinor: allowancesMinor,
    notes: null,
    source: ActualPayslipSource.manual,
    createdAt: now,
    updatedAt: now,
  );
}
