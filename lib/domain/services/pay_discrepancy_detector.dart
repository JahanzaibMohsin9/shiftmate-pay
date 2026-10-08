import '../../core/common/app_constants.dart';
import '../entities/pay_verification.dart';

class PayDiscrepancyDetector {
  const PayDiscrepancyDetector();

  List<PayVerificationDiscrepancy> detect(PayVerificationSummary summary) {
    final discrepancies = <PayVerificationDiscrepancy>[];

    final overtimeDelta = _deltaFor(summary, PayVerificationCategory.overtime);
    final holidayDelta = _deltaFor(summary, PayVerificationCategory.holiday);
    final allowancesDelta = _deltaFor(
      summary,
      PayVerificationCategory.allowances,
    );
    final workedMinutesDelta = _deltaFor(
      summary,
      PayVerificationCategory.workedMinutes,
    );

    if (overtimeDelta != null && overtimeDelta.hasActualValue) {
      final delta = overtimeDelta.deltaValue ?? 0;
      if (delta < 0) {
        discrepancies.add(
          PayVerificationDiscrepancy(
            type: PayVerificationDiscrepancyType.missingOvertime,
            title: 'Possible missing overtime pay',
            explanation:
                'Expected overtime pay for this period looks higher than the overtime amount currently entered from your payslip.',
            suggestedNextStep:
                'Check whether overtime hours were paid at the correct rate, or add more payslip detail before treating this as a payroll issue.',
            severity: _severityForMoneyDelta(summary, delta.abs()),
            confidence: summary.confidence,
            expectedValue: overtimeDelta.expectedValue,
            actualValue: overtimeDelta.actualValue,
          ),
        );
      }
    }

    if (holidayDelta != null && holidayDelta.hasActualValue) {
      final delta = holidayDelta.deltaValue ?? 0;
      if (delta < 0) {
        discrepancies.add(
          PayVerificationDiscrepancy(
            type: PayVerificationDiscrepancyType.missingHolidayUplift,
            title: 'Possible missing holiday uplift',
            explanation:
                'Holiday pay on the payslip looks lower than the holiday uplift expected from the saved shifts and rules.',
            suggestedNextStep:
                'Review whether holiday hours were paid with the expected uplift or premium multiplier, especially if this payslip combines categories together.',
            severity: _severityForMoneyDelta(summary, delta.abs()),
            confidence: summary.confidence,
            expectedValue: holidayDelta.expectedValue,
            actualValue: holidayDelta.actualValue,
          ),
        );
      }
    }

    if (allowancesDelta != null && allowancesDelta.hasActualValue) {
      final delta = allowancesDelta.deltaValue ?? 0;
      if (delta < 0) {
        discrepancies.add(
          PayVerificationDiscrepancy(
            type: PayVerificationDiscrepancyType.missingAllowance,
            title: 'Possible missing allowance or differential',
            explanation:
                'Expected allowances or differentials look higher than what is currently entered from the payslip.',
            suggestedNextStep:
                'Check whether shift allowances, night premiums, or weekend uplifts were listed separately on the payslip.',
            severity: _severityForMoneyDelta(summary, delta.abs()),
            confidence: summary.confidence,
            expectedValue: allowancesDelta.expectedValue,
            actualValue: allowancesDelta.actualValue,
          ),
        );
      }
    }

    if (workedMinutesDelta != null && workedMinutesDelta.hasActualValue) {
      final minuteDelta = workedMinutesDelta.deltaValue ?? 0;
      if (minuteDelta.abs() >= AppConstants.minutesPerHour) {
        final fewerHours = minuteDelta < 0;
        discrepancies.add(
          PayVerificationDiscrepancy(
            type: PayVerificationDiscrepancyType.missingOrExtraShift,
            title: fewerHours
                ? 'Possible missing shift or unpaid hours'
                : 'Possible extra shift or extra paid hours',
            explanation: fewerHours
                ? 'The payslip reports fewer worked hours than the schedule used for this estimate.'
                : 'The payslip reports more worked hours than the schedule used for this estimate.',
            suggestedNextStep: fewerHours
                ? 'Check for a missed shift entry, unpaid training time, or a schedule change that was not saved yet.'
                : 'Check whether an extra shift, callback, or manual payroll adjustment was paid in this period.',
            severity: summary.confidence == PayVerificationConfidence.high
                ? PayVerificationDiscrepancySeverity.high
                : PayVerificationDiscrepancySeverity.warning,
            confidence: summary.confidence,
            expectedValue: workedMinutesDelta.expectedValue,
            actualValue: workedMinutesDelta.actualValue,
          ),
        );
      }
    }

    final smallWorkedTimeGap =
        workedMinutesDelta != null &&
        workedMinutesDelta.hasActualValue &&
        (workedMinutesDelta.deltaValue ?? 0).abs() <
            AppConstants.minutesPerHour;
    if (summary.totalVarianceMinor != 0 &&
        summary.confidence != PayVerificationConfidence.low &&
        smallWorkedTimeGap &&
        discrepancies.every(
          (item) =>
              item.type != PayVerificationDiscrepancyType.missingOvertime &&
              item.type !=
                  PayVerificationDiscrepancyType.missingHolidayUplift &&
              item.type != PayVerificationDiscrepancyType.missingAllowance,
        )) {
      discrepancies.add(
        PayVerificationDiscrepancy(
          type: PayVerificationDiscrepancyType.rateMismatch,
          title: 'Possible rate mismatch',
          explanation:
              'Worked time looks close, but the gross pay still differs enough to suggest a rate or multiplier mismatch.',
          suggestedNextStep:
              'Check the hourly rate, overtime multiplier, and holiday rules used for this period before assuming the payslip is wrong.',
          severity: _severityForMoneyDelta(
            summary,
            summary.totalVarianceMinor.abs(),
          ),
          confidence: summary.confidence,
          expectedValue: summary.expectedGrossPayMinor,
          actualValue: summary.actualGrossPayMinor,
        ),
      );
    }

    if (summary.comparisonWarnings.isNotEmpty) {
      discrepancies.add(
        PayVerificationDiscrepancy(
          type: PayVerificationDiscrepancyType.incompletePayslipData,
          title: 'Comparison detail is incomplete',
          explanation: summary.comparisonWarnings.first,
          suggestedNextStep:
              'Add overtime, holiday, allowance, or worked-time values if your payslip shows them for a stronger review.',
          severity: PayVerificationDiscrepancySeverity.info,
          confidence: summary.confidence,
          expectedValue: summary.expectedGrossPayMinor,
          actualValue: summary.actualGrossPayMinor,
        ),
      );
    }

    final missingAllowanceBreakdown =
        allowancesDelta != null &&
        allowancesDelta.expectedValue > 0 &&
        !allowancesDelta.hasActualValue;
    if (summary.comparisonType == PayVerificationComparisonType.likely &&
        summary.confidence == PayVerificationConfidence.low &&
        missingAllowanceBreakdown) {
      discrepancies.add(
        PayVerificationDiscrepancy(
          type: PayVerificationDiscrepancyType.unsupportedRuleComplexity,
          title: 'Complex pay setup needs more detail',
          explanation:
              'This period includes allowances or differential pay, but the payslip breakdown is not detailed enough for a stronger explanation yet.',
          suggestedNextStep:
              'Add the allowance field from the payslip, or review advanced pay rules before relying too heavily on this result.',
          severity: PayVerificationDiscrepancySeverity.info,
          confidence: summary.confidence,
          expectedValue: allowancesDelta.expectedValue,
          actualValue: allowancesDelta.actualValue,
        ),
      );
    }

    return discrepancies;
  }

  PayVerificationCategoryDelta? _deltaFor(
    PayVerificationSummary summary,
    PayVerificationCategory category,
  ) {
    for (final delta in summary.categoryDeltas) {
      if (delta.category == category) {
        return delta;
      }
    }
    return null;
  }

  PayVerificationDiscrepancySeverity _severityForMoneyDelta(
    PayVerificationSummary summary,
    int absoluteDeltaMinor,
  ) {
    if (absoluteDeltaMinor >= 5000 &&
        summary.confidence == PayVerificationConfidence.high) {
      return PayVerificationDiscrepancySeverity.high;
    }
    if (absoluteDeltaMinor >= 1000) {
      return PayVerificationDiscrepancySeverity.warning;
    }
    return PayVerificationDiscrepancySeverity.info;
  }
}
