import '../../core/common/shared_types.dart';
import '../../core/time/app_date_range.dart';
import '../entities/income_forecast.dart';

class ForecastTargetTrackingResult {
  const ForecastTargetTrackingResult({
    required this.goalProgress,
    required this.overtimeProgress,
    required this.nudges,
  });

  final ForecastGoalProgress? goalProgress;
  final ForecastOvertimeProgress? overtimeProgress;
  final List<ForecastNudge> nudges;
}

class ForecastTargetTracker {
  const ForecastTargetTracker();

  ForecastTargetTrackingResult track({
    required AppDateRange monthRange,
    required ForecastCoverage coverage,
    required ForecastConfidenceLevel confidence,
    required MinorUnits projectedGrossPayMinor,
    required Minutes projectedOvertimeMinutes,
    MinorUnits? monthlyGoalMinor,
    Minutes? monthlyOvertimeTargetMinutes,
  }) {
    ForecastGoalProgress? goalProgress;
    ForecastOvertimeProgress? overtimeProgress;
    final nudges = <ForecastNudge>[];

    if (monthlyGoalMinor != null) {
      goalProgress = _buildGoalProgress(
        monthRange: monthRange,
        goalMinor: monthlyGoalMinor,
        projectedGrossPayMinor: projectedGrossPayMinor,
        confidence: confidence,
        coverage: coverage,
      );
      nudges.addAll(_goalNudges(goalProgress));
    }

    if (monthlyOvertimeTargetMinutes != null) {
      overtimeProgress = _buildOvertimeProgress(
        monthRange: monthRange,
        targetMinutes: monthlyOvertimeTargetMinutes,
        projectedOvertimeMinutes: projectedOvertimeMinutes,
        confidence: confidence,
        coverage: coverage,
      );
      nudges.addAll(_overtimeNudges(overtimeProgress));
    }

    return ForecastTargetTrackingResult(
      goalProgress: goalProgress,
      overtimeProgress: overtimeProgress,
      nudges: List.unmodifiable(nudges),
    );
  }

  ForecastGoalProgress _buildGoalProgress({
    required AppDateRange monthRange,
    required int goalMinor,
    required int projectedGrossPayMinor,
    required ForecastConfidenceLevel confidence,
    required ForecastCoverage coverage,
  }) {
    final deltaToGoalMinor = projectedGrossPayMinor - goalMinor;
    final progressBps = goalMinor <= 0
        ? 0
        : ((projectedGrossPayMinor * 10000) ~/ goalMinor);
    final status = _goalStatus(
      projectedGrossPayMinor: projectedGrossPayMinor,
      goalMinor: goalMinor,
      confidence: confidence,
      coverage: coverage,
    );

    return ForecastGoalProgress(
      monthRange: monthRange,
      goalMinor: goalMinor,
      projectedGrossPayMinor: projectedGrossPayMinor,
      deltaToGoalMinor: deltaToGoalMinor,
      progressBps: progressBps,
      status: status,
      confidence: confidence,
    );
  }

  ForecastOvertimeProgress _buildOvertimeProgress({
    required AppDateRange monthRange,
    required int targetMinutes,
    required int projectedOvertimeMinutes,
    required ForecastConfidenceLevel confidence,
    required ForecastCoverage coverage,
  }) {
    final deltaToTargetMinutes = projectedOvertimeMinutes - targetMinutes;
    final progressBps = targetMinutes <= 0
        ? 0
        : ((projectedOvertimeMinutes * 10000) ~/ targetMinutes);
    final status = _overtimeStatus(
      projectedOvertimeMinutes: projectedOvertimeMinutes,
      targetMinutes: targetMinutes,
      confidence: confidence,
      coverage: coverage,
    );

    return ForecastOvertimeProgress(
      monthRange: monthRange,
      targetMinutes: targetMinutes,
      projectedOvertimeMinutes: projectedOvertimeMinutes,
      deltaToTargetMinutes: deltaToTargetMinutes,
      progressBps: progressBps,
      status: status,
      confidence: confidence,
    );
  }

  ForecastGoalStatus _goalStatus({
    required int projectedGrossPayMinor,
    required int goalMinor,
    required ForecastConfidenceLevel confidence,
    required ForecastCoverage coverage,
  }) {
    if (coverage.coverageRatio < 0.4) {
      return ForecastGoalStatus.notEnoughData;
    }
    if (projectedGrossPayMinor >= goalMinor &&
        confidence != ForecastConfidenceLevel.low) {
      return ForecastGoalStatus.onTrack;
    }
    if (confidence == ForecastConfidenceLevel.low ||
        projectedGrossPayMinor >= (goalMinor * 0.9).round()) {
      return ForecastGoalStatus.atRisk;
    }
    return ForecastGoalStatus.offTrack;
  }

  ForecastOvertimeTargetStatus _overtimeStatus({
    required int projectedOvertimeMinutes,
    required int targetMinutes,
    required ForecastConfidenceLevel confidence,
    required ForecastCoverage coverage,
  }) {
    if (coverage.coverageRatio < 0.4) {
      return ForecastOvertimeTargetStatus.notEnoughData;
    }
    if (projectedOvertimeMinutes >= targetMinutes &&
        confidence != ForecastConfidenceLevel.low) {
      return ForecastOvertimeTargetStatus.onTrack;
    }
    if (confidence == ForecastConfidenceLevel.low ||
        projectedOvertimeMinutes >= (targetMinutes * 0.75).round()) {
      return ForecastOvertimeTargetStatus.atRisk;
    }
    return ForecastOvertimeTargetStatus.offTrack;
  }

  List<ForecastNudge> _goalNudges(ForecastGoalProgress progress) {
    return switch (progress.status) {
      ForecastGoalStatus.onTrack => const [
        ForecastNudge(
          id: 'goal_on_track',
          severity: ForecastNudgeSeverity.info,
          message:
              'You are currently on pace for this earnings goal based on the scheduled shifts in view.',
        ),
      ],
      ForecastGoalStatus.atRisk => const [
        ForecastNudge(
          id: 'goal_at_risk',
          severity: ForecastNudgeSeverity.warning,
          message:
              'Your earnings goal is getting close. More scheduled coverage or one extra shift could change the picture.',
        ),
      ],
      ForecastGoalStatus.offTrack => const [
        ForecastNudge(
          id: 'goal_off_track',
          severity: ForecastNudgeSeverity.warning,
          message:
              'This forecast is currently below your earnings goal for the month.',
        ),
      ],
      ForecastGoalStatus.notEnoughData => const [
        ForecastNudge(
          id: 'goal_not_enough_data',
          severity: ForecastNudgeSeverity.info,
          message:
              'There is not enough future schedule coverage yet to judge this earnings goal confidently.',
        ),
      ],
    };
  }

  List<ForecastNudge> _overtimeNudges(ForecastOvertimeProgress progress) {
    return switch (progress.status) {
      ForecastOvertimeTargetStatus.onTrack => const [
        ForecastNudge(
          id: 'overtime_on_track',
          severity: ForecastNudgeSeverity.info,
          message:
              'You are on pace to reach your overtime target from the currently scheduled work.',
        ),
      ],
      ForecastOvertimeTargetStatus.atRisk => const [
        ForecastNudge(
          id: 'overtime_at_risk',
          severity: ForecastNudgeSeverity.warning,
          message:
              'Your overtime target is within reach, but the current forecast could still change with more schedule data.',
        ),
      ],
      ForecastOvertimeTargetStatus.offTrack => const [
        ForecastNudge(
          id: 'overtime_off_track',
          severity: ForecastNudgeSeverity.warning,
          message:
              'The current schedule is below your overtime target for the month.',
        ),
      ],
      ForecastOvertimeTargetStatus.notEnoughData => const [
        ForecastNudge(
          id: 'overtime_not_enough_data',
          severity: ForecastNudgeSeverity.info,
          message:
              'There is not enough future schedule coverage yet to judge your overtime target confidently.',
        ),
      ],
    };
  }
}
