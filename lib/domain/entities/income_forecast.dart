import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';
import '../../core/time/app_date_range.dart';

enum ForecastWindowPreset { days30, days60, days90 }

enum ForecastConfidenceLevel { high, medium, low }

enum ForecastGoalStatus { onTrack, atRisk, offTrack, notEnoughData }

enum ForecastOvertimeTargetStatus { onTrack, atRisk, offTrack, notEnoughData }

enum ForecastNudgeSeverity { info, warning }

enum ForecastShiftSimulationTrigger { overtime, differential, allowance }

class ForecastCoverage {
  const ForecastCoverage({
    required this.daysCovered,
    required this.daysTotal,
    required this.coverageRatio,
    required this.coveredShiftCount,
    required this.uncoveredDayCount,
  });

  final int daysCovered;
  final int daysTotal;
  final double coverageRatio;
  final int coveredShiftCount;
  final int uncoveredDayCount;
}

class ForecastGoalProgress {
  const ForecastGoalProgress({
    required this.monthRange,
    required this.goalMinor,
    required this.projectedGrossPayMinor,
    required this.deltaToGoalMinor,
    required this.progressBps,
    required this.status,
    required this.confidence,
  });

  final AppDateRange monthRange;
  final MinorUnits goalMinor;
  final MinorUnits projectedGrossPayMinor;
  final int deltaToGoalMinor;
  final int progressBps;
  final ForecastGoalStatus status;
  final ForecastConfidenceLevel confidence;
}

class ForecastOvertimeProgress {
  const ForecastOvertimeProgress({
    required this.monthRange,
    required this.targetMinutes,
    required this.projectedOvertimeMinutes,
    required this.deltaToTargetMinutes,
    required this.progressBps,
    required this.status,
    required this.confidence,
  });

  final AppDateRange monthRange;
  final Minutes targetMinutes;
  final Minutes projectedOvertimeMinutes;
  final int deltaToTargetMinutes;
  final int progressBps;
  final ForecastOvertimeTargetStatus status;
  final ForecastConfidenceLevel confidence;
}

class ForecastNudge {
  const ForecastNudge({
    required this.id,
    required this.severity,
    required this.message,
  });

  final String id;
  final ForecastNudgeSeverity severity;
  final String message;
}

class IncomeForecastSummary {
  const IncomeForecastSummary({
    required this.jobId,
    required this.range,
    required this.windowPreset,
    required this.currencyCode,
    required this.projectedGrossPayMinor,
    required this.projectedBasePayMinor,
    required this.projectedOvertimePayMinor,
    required this.projectedHolidayPayMinor,
    required this.projectedAllowancePayMinor,
    required this.projectedDifferentialPayMinor,
    required this.projectedWorkedMinutes,
    required this.projectedShiftCount,
    required this.coverage,
    required this.confidence,
    required this.confidenceWarnings,
    required this.goalProgress,
    required this.overtimeProgress,
    required this.nudges,
  });

  final EntityId jobId;
  final AppDateRange range;
  final ForecastWindowPreset windowPreset;
  final String currencyCode;
  final MinorUnits projectedGrossPayMinor;
  final MinorUnits projectedBasePayMinor;
  final MinorUnits projectedOvertimePayMinor;
  final MinorUnits projectedHolidayPayMinor;
  final MinorUnits projectedAllowancePayMinor;
  final MinorUnits projectedDifferentialPayMinor;
  final Minutes projectedWorkedMinutes;
  final int projectedShiftCount;
  final ForecastCoverage coverage;
  final ForecastConfidenceLevel confidence;
  final List<String> confidenceWarnings;
  final ForecastGoalProgress? goalProgress;
  final ForecastOvertimeProgress? overtimeProgress;
  final List<ForecastNudge> nudges;
}

class ForecastShiftSimulationResult {
  const ForecastShiftSimulationResult({
    required this.jobId,
    required this.range,
    required this.simulatedDate,
    required this.templateId,
    required this.templateName,
    required this.currencyCode,
    required this.baselineGrossPayMinor,
    required this.updatedGrossPayMinor,
    required this.additionalGrossPayMinor,
    required this.additionalBasePayMinor,
    required this.additionalOvertimePayMinor,
    required this.additionalHolidayPayMinor,
    required this.additionalAllowancePayMinor,
    required this.additionalDifferentialPayMinor,
    required this.additionalWorkedMinutes,
    required this.updatedShiftCount,
    required this.baselineCoverage,
    required this.updatedCoverage,
    required this.baselineConfidence,
    required this.updatedConfidence,
    required this.triggeredChanges,
    required this.goalStatusBefore,
    required this.goalStatusAfter,
    required this.overtimeStatusBefore,
    required this.overtimeStatusAfter,
  });

  final EntityId jobId;
  final AppDateRange range;
  final DateTime simulatedDate;
  final EntityId templateId;
  final String templateName;
  final String currencyCode;
  final MinorUnits baselineGrossPayMinor;
  final MinorUnits updatedGrossPayMinor;
  final MinorUnits additionalGrossPayMinor;
  final MinorUnits additionalBasePayMinor;
  final MinorUnits additionalOvertimePayMinor;
  final MinorUnits additionalHolidayPayMinor;
  final MinorUnits additionalAllowancePayMinor;
  final MinorUnits additionalDifferentialPayMinor;
  final Minutes additionalWorkedMinutes;
  final int updatedShiftCount;
  final ForecastCoverage baselineCoverage;
  final ForecastCoverage updatedCoverage;
  final ForecastConfidenceLevel baselineConfidence;
  final ForecastConfidenceLevel updatedConfidence;
  final List<ForecastShiftSimulationTrigger> triggeredChanges;
  final ForecastGoalStatus? goalStatusBefore;
  final ForecastGoalStatus? goalStatusAfter;
  final ForecastOvertimeTargetStatus? overtimeStatusBefore;
  final ForecastOvertimeTargetStatus? overtimeStatusAfter;
}
