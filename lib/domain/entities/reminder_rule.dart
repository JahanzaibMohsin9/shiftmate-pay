import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';

class ReminderRule {
  const ReminderRule({
    required this.id,
    required this.jobId,
    required this.type,
    required this.leadMinutes,
    required this.enabled,
  });

  final EntityId id;
  final EntityId jobId;
  final ReminderType type;
  final Minutes leadMinutes;
  final bool enabled;
}
