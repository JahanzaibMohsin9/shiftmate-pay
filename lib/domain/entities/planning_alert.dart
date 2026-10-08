import '../../core/common/identifiers.dart';

enum PlanningAlertType {
  overlapConflict,
  availabilityConflict,
  availabilityPreference,
  restGapRisk,
  consecutiveDaysRisk,
  weeklyOvertimeCapRisk,
  monthlyOvertimeCapRisk,
}

enum PlanningAlertSeverity { info, attention, risk }

class PlanningAlert {
  const PlanningAlert({
    required this.id,
    required this.jobId,
    required this.shiftInstanceId,
    required this.date,
    required this.type,
    required this.severity,
    required this.title,
    required this.message,
  });

  final EntityId id;
  final EntityId jobId;
  final EntityId? shiftInstanceId;
  final DateTime date;
  final PlanningAlertType type;
  final PlanningAlertSeverity severity;
  final String title;
  final String message;
}
