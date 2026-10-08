import '../../core/common/identifiers.dart';

class ShiftPatternEntry {
  const ShiftPatternEntry({
    required this.id,
    required this.patternId,
    required this.dayOffset,
    required this.shiftTemplateId,
    required this.isOffDay,
  });

  final EntityId id;
  final EntityId patternId;
  final int dayOffset;
  final EntityId? shiftTemplateId;
  final bool isOffDay;
}
