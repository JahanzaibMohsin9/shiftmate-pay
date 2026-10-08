import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';

class PlanningSettings {
  const PlanningSettings({
    required this.id,
    required this.jobId,
    required this.planningAlertsEnabled,
    required this.minimumRestMinutes,
    required this.maxConsecutiveWorkDays,
    required this.weeklyOvertimeCapMinutes,
    required this.monthlyOvertimeCapMinutes,
    required this.createdAt,
    required this.updatedAt,
  });

  final EntityId id;
  final EntityId jobId;
  final bool planningAlertsEnabled;
  final Minutes? minimumRestMinutes;
  final int? maxConsecutiveWorkDays;
  final Minutes? weeklyOvertimeCapMinutes;
  final Minutes? monthlyOvertimeCapMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
}
