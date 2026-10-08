import '../../core/common/shared_types.dart';
import '../../core/time/app_date_range.dart';
import '../../core/time/date_range_extensions.dart';
import '../entities/entities.dart';

class PatternExpansionService {
  const PatternExpansionService();

  List<ShiftInstance> expand({
    required ShiftPattern pattern,
    required List<ShiftPatternEntry> entries,
    required List<ShiftTemplate> templates,
    required List<ShiftInstance> overrides,
    required AppDateRange range,
  }) {
    final normalizedRange = AppDateRange(
      start: range.start.startOfDay,
      end: range.end.startOfDay,
    );

    final entriesByOffset = {
      for (final entry in entries)
        _normalizeOffset(entry.dayOffset, pattern.cycleLengthDays): entry,
    };
    final templatesById = {for (final template in templates) template.id: template};
    final overridesByDate = {
      for (final override in overrides) _dayKey(override.date.startOfDay): override,
    };
    final instances = <ShiftInstance>[];

    for (var date = normalizedRange.start;
        !date.isAfter(normalizedRange.end);
        date = date.add(const Duration(days: 1))) {
      final override = overridesByDate[_dayKey(date)];
      if (override != null) {
        if (override.overrideType != ShiftOverrideType.markOffDay) {
          instances.add(override);
        }
        continue;
      }

      if (date.isBefore(pattern.startDate.startOfDay)) {
        continue;
      }

      final cycleOffset = _cycleOffsetForDate(
        date: date,
        patternStartDate: pattern.startDate.startOfDay,
        cycleLengthDays: pattern.cycleLengthDays,
      );
      final entry = entriesByOffset[cycleOffset];
      if (entry == null || entry.isOffDay || entry.shiftTemplateId == null) {
        continue;
      }

      final template = templatesById[entry.shiftTemplateId];
      if (template == null) {
        continue;
      }

      instances.add(
        _buildGeneratedInstance(
          pattern: pattern,
          template: template,
          date: date,
        ),
      );
    }

    instances.sort((left, right) {
      final byStart = left.startDateTime.compareTo(right.startDateTime);
      if (byStart != 0) {
        return byStart;
      }

      return left.id.compareTo(right.id);
    });

    return List.unmodifiable(instances);
  }

  ShiftInstance _buildGeneratedInstance({
    required ShiftPattern pattern,
    required ShiftTemplate template,
    required DateTime date,
  }) {
    final startDateTime = _dateWithMinutes(date, template.startMinutesLocal);
    var endDateTime = _dateWithMinutes(date, template.endMinutesLocal);

    if (!endDateTime.isAfter(startDateTime)) {
      endDateTime = endDateTime.add(const Duration(days: 1));
    }

    return ShiftInstance(
      id: 'generated:${pattern.id}:${_dayKey(date)}',
      jobId: pattern.jobId,
      date: date,
      templateSnapshot: ShiftTemplateSnapshot(
        templateId: template.id,
        name: template.name,
        category: template.category,
        startMinutesLocal: template.startMinutesLocal,
        endMinutesLocal: template.endMinutesLocal,
        unpaidBreakMinutes: template.unpaidBreakMinutes,
        defaultNote: template.defaultNote,
      ),
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      unpaidBreakMinutes: template.unpaidBreakMinutes,
      source: ShiftSource.pattern,
      note: template.defaultNote,
      isHoliday: false,
      overrideType: null,
    );
  }

  int _cycleOffsetForDate({
    required DateTime date,
    required DateTime patternStartDate,
    required int cycleLengthDays,
  }) {
    final difference = date.startOfDay.difference(patternStartDate.startOfDay).inDays;
    return _normalizeOffset(difference, cycleLengthDays);
  }

  int _normalizeOffset(int rawOffset, int cycleLengthDays) {
    final remainder = rawOffset % cycleLengthDays;
    return remainder < 0 ? remainder + cycleLengthDays : remainder;
  }

  DateTime _dateWithMinutes(DateTime date, Minutes minutes) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      minutes ~/ 60,
      minutes % 60,
    );
  }

  String _dayKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
