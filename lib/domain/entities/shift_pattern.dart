import '../../core/common/identifiers.dart';

class ShiftPattern {
  const ShiftPattern({
    required this.id,
    required this.jobId,
    required this.name,
    required this.cycleLengthDays,
    required this.startDate,
    required this.timezone,
    required this.isActive,
  });

  final EntityId id;
  final EntityId jobId;
  final String name;
  final int cycleLengthDays;
  final DateTime startDate;
  final String timezone;
  final bool isActive;
}
