import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';

class PayRuleSet {
  const PayRuleSet({
    required this.id,
    required this.jobId,
    required this.overtimeThresholdDailyMinutes,
    required this.overtimeThresholdWeeklyMinutes,
    required this.overtimeMultiplierBps,
    required this.doubleTimeThresholdMinutes,
    required this.doubleTimeMultiplierBps,
    required this.roundRule,
  });

  final EntityId id;
  final EntityId jobId;
  final Minutes? overtimeThresholdDailyMinutes;
  final Minutes? overtimeThresholdWeeklyMinutes;
  final int overtimeMultiplierBps;
  final Minutes? doubleTimeThresholdMinutes;
  final int? doubleTimeMultiplierBps;
  final RoundRule roundRule;
}
