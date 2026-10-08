import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';
import '../../core/time/app_date_range.dart';

enum PayVerificationVarianceDirection { match, underpaid, overpaid, uncertain }

enum PayVerificationConfidence { high, medium, low }

enum PayVerificationComparisonType { exact, likely }

enum PayVerificationCategory {
  gross,
  overtime,
  holiday,
  allowances,
  workedMinutes,
}

enum PayVerificationDiscrepancyType {
  missingOvertime,
  missingHolidayUplift,
  missingAllowance,
  rateMismatch,
  missingOrExtraShift,
  incompletePayslipData,
  unsupportedRuleComplexity,
}

enum PayVerificationDiscrepancySeverity { info, warning, high }

class PayVerificationDiscrepancy {
  const PayVerificationDiscrepancy({
    required this.type,
    required this.title,
    required this.explanation,
    required this.suggestedNextStep,
    required this.severity,
    required this.confidence,
    required this.expectedValue,
    required this.actualValue,
  });

  final PayVerificationDiscrepancyType type;
  final String title;
  final String explanation;
  final String suggestedNextStep;
  final PayVerificationDiscrepancySeverity severity;
  final PayVerificationConfidence confidence;
  final int expectedValue;
  final int? actualValue;
}

class PayVerificationCategoryDelta {
  const PayVerificationCategoryDelta({
    required this.category,
    required this.expectedValue,
    required this.actualValue,
    required this.deltaValue,
    required this.hasActualValue,
  });

  final PayVerificationCategory category;
  final int expectedValue;
  final int? actualValue;
  final int? deltaValue;
  final bool hasActualValue;
}

class PayVerificationSummary {
  const PayVerificationSummary({
    required this.jobId,
    required this.range,
    required this.currencyCode,
    required this.expectedGrossPayMinor,
    required this.actualGrossPayMinor,
    required this.totalVarianceMinor,
    required this.varianceDirection,
    required this.confidence,
    required this.comparisonType,
    required this.categoryDeltas,
    required this.comparisonWarnings,
    required this.discrepancies,
  });

  final EntityId jobId;
  final AppDateRange range;
  final String currencyCode;
  final MinorUnits expectedGrossPayMinor;
  final MinorUnits actualGrossPayMinor;
  final MinorUnits totalVarianceMinor;
  final PayVerificationVarianceDirection varianceDirection;
  final PayVerificationConfidence confidence;
  final PayVerificationComparisonType comparisonType;
  final List<PayVerificationCategoryDelta> categoryDeltas;
  final List<String> comparisonWarnings;
  final List<PayVerificationDiscrepancy> discrepancies;

  PayVerificationSummary copyWith({
    EntityId? jobId,
    AppDateRange? range,
    String? currencyCode,
    MinorUnits? expectedGrossPayMinor,
    MinorUnits? actualGrossPayMinor,
    MinorUnits? totalVarianceMinor,
    PayVerificationVarianceDirection? varianceDirection,
    PayVerificationConfidence? confidence,
    PayVerificationComparisonType? comparisonType,
    List<PayVerificationCategoryDelta>? categoryDeltas,
    List<String>? comparisonWarnings,
    List<PayVerificationDiscrepancy>? discrepancies,
  }) {
    return PayVerificationSummary(
      jobId: jobId ?? this.jobId,
      range: range ?? this.range,
      currencyCode: currencyCode ?? this.currencyCode,
      expectedGrossPayMinor:
          expectedGrossPayMinor ?? this.expectedGrossPayMinor,
      actualGrossPayMinor: actualGrossPayMinor ?? this.actualGrossPayMinor,
      totalVarianceMinor: totalVarianceMinor ?? this.totalVarianceMinor,
      varianceDirection: varianceDirection ?? this.varianceDirection,
      confidence: confidence ?? this.confidence,
      comparisonType: comparisonType ?? this.comparisonType,
      categoryDeltas: categoryDeltas ?? this.categoryDeltas,
      comparisonWarnings: comparisonWarnings ?? this.comparisonWarnings,
      discrepancies: discrepancies ?? this.discrepancies,
    );
  }
}
