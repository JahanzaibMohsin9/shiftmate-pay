import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';

class ShiftTemplate {
  const ShiftTemplate({
    required this.id,
    required this.jobId,
    required this.name,
    required this.startMinutesLocal,
    required this.endMinutesLocal,
    required this.unpaidBreakMinutes,
    required this.category,
    required this.defaultNote,
  });

  final EntityId id;
  final EntityId jobId;
  final String name;
  final Minutes startMinutesLocal;
  final Minutes endMinutesLocal;
  final Minutes unpaidBreakMinutes;
  final ShiftCategory category;
  final String? defaultNote;

  bool get crossesMidnight => endMinutesLocal <= startMinutesLocal;
}
