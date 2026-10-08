import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/domain/entities/income_forecast.dart';
import 'package:shiftmate_pay/domain/services/forecast_target_tracker.dart';

void main() {
  const tracker = ForecastTargetTracker();
  final monthRange = AppDateRange(
    start: DateTime.utc(2026, 4, 1),
    end: DateTime.utc(2026, 4, 30),
  );

  test('marks earnings goals at risk when they are close but not yet met', () {
    final result = tracker.track(
      monthRange: monthRange,
      coverage: const ForecastCoverage(
        daysCovered: 24,
        daysTotal: 30,
        coverageRatio: 0.8,
        coveredShiftCount: 12,
        uncoveredDayCount: 6,
      ),
      confidence: ForecastConfidenceLevel.medium,
      projectedGrossPayMinor: 285000,
      projectedOvertimeMinutes: 1200,
      monthlyGoalMinor: 300000,
    );

    expect(result.goalProgress, isNotNull);
    expect(result.goalProgress!.status, ForecastGoalStatus.atRisk);
    expect(result.nudges.map((item) => item.id), contains('goal_at_risk'));
  });

  test('marks earnings goals off track when they are materially behind', () {
    final result = tracker.track(
      monthRange: monthRange,
      coverage: const ForecastCoverage(
        daysCovered: 28,
        daysTotal: 30,
        coverageRatio: 0.93,
        coveredShiftCount: 18,
        uncoveredDayCount: 2,
      ),
      confidence: ForecastConfidenceLevel.high,
      projectedGrossPayMinor: 210000,
      projectedOvertimeMinutes: 600,
      monthlyGoalMinor: 300000,
    );

    expect(result.goalProgress, isNotNull);
    expect(result.goalProgress!.status, ForecastGoalStatus.offTrack);
    expect(result.nudges.map((item) => item.id), contains('goal_off_track'));
  });

  test('marks overtime targets at risk when near target with enough data', () {
    final result = tracker.track(
      monthRange: monthRange,
      coverage: const ForecastCoverage(
        daysCovered: 25,
        daysTotal: 30,
        coverageRatio: 0.83,
        coveredShiftCount: 16,
        uncoveredDayCount: 5,
      ),
      confidence: ForecastConfidenceLevel.medium,
      projectedGrossPayMinor: 260000,
      projectedOvertimeMinutes: 900,
      monthlyOvertimeTargetMinutes: 1200,
    );

    expect(result.overtimeProgress, isNotNull);
    expect(
      result.overtimeProgress!.status,
      ForecastOvertimeTargetStatus.atRisk,
    );
    expect(result.nudges.map((item) => item.id), contains('overtime_at_risk'));
  });
}
