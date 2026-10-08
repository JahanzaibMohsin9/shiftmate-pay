import '../entities/income_forecast.dart';

class ForecastConfidenceResult {
  const ForecastConfidenceResult({
    required this.confidence,
    required this.warnings,
  });

  final ForecastConfidenceLevel confidence;
  final List<String> warnings;
}

class ForecastConfidenceEvaluator {
  const ForecastConfidenceEvaluator();

  ForecastConfidenceResult evaluate(ForecastCoverage coverage) {
    final warnings = <String>[];
    if (coverage.daysCovered == 0) {
      warnings.add(
        'No future shifts are currently scheduled for much of this range yet.',
      );
    } else if (coverage.uncoveredDayCount > 0) {
      warnings.add(
        'Only part of this window has scheduled shifts, so this total may be lower than what you actually earn.',
      );
    }

    final confidence = _confidenceForRatio(coverage.coverageRatio);
    return ForecastConfidenceResult(
      confidence: confidence,
      warnings: List.unmodifiable(warnings),
    );
  }

  ForecastConfidenceLevel _confidenceForRatio(double ratio) {
    if (ratio >= 0.85) {
      return ForecastConfidenceLevel.high;
    }
    if (ratio >= 0.4) {
      return ForecastConfidenceLevel.medium;
    }
    return ForecastConfidenceLevel.low;
  }
}
