import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';

enum AvailabilityRuleType { recurring, oneOff }

enum AvailabilityState { unavailable, preferOff }

class AvailabilityRule {
  const AvailabilityRule({
    required this.id,
    required this.jobId,
    required this.type,
    required this.state,
    required this.startDateTime,
    required this.endDateTime,
    required this.weekday,
    required this.startMinuteOfDay,
    required this.endMinuteOfDay,
    required this.note,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  final EntityId id;
  final EntityId jobId;
  final AvailabilityRuleType type;
  final AvailabilityState state;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final int? weekday;
  final Minutes? startMinuteOfDay;
  final Minutes? endMinuteOfDay;
  final String? note;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
}
