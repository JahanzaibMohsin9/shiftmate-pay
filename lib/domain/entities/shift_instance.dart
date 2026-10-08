import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';

class ShiftTemplateSnapshot {
  const ShiftTemplateSnapshot({
    required this.templateId,
    required this.name,
    required this.category,
    required this.startMinutesLocal,
    required this.endMinutesLocal,
    required this.unpaidBreakMinutes,
    required this.defaultNote,
  });

  final EntityId? templateId;
  final String name;
  final ShiftCategory category;
  final Minutes startMinutesLocal;
  final Minutes endMinutesLocal;
  final Minutes unpaidBreakMinutes;
  final String? defaultNote;
}

class ShiftInstance {
  const ShiftInstance({
    required this.id,
    required this.jobId,
    required this.date,
    required this.templateSnapshot,
    required this.startDateTime,
    required this.endDateTime,
    required this.unpaidBreakMinutes,
    required this.source,
    required this.note,
    required this.isHoliday,
    required this.overrideType,
  });

  final EntityId id;
  final EntityId jobId;
  final DateTime date;
  final ShiftTemplateSnapshot? templateSnapshot;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final Minutes unpaidBreakMinutes;
  final ShiftSource source;
  final String? note;
  final bool isHoliday;
  final ShiftOverrideType? overrideType;
}
