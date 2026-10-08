import 'package:intl/intl.dart';

import '../../core/common/shared_types.dart';
import '../../core/time/app_date_range.dart';
import '../entities/job.dart';
import '../entities/shift_instance.dart';

class CalendarExportDocument {
  const CalendarExportDocument({
    required this.calendarName,
    required this.range,
    required this.rangeLabel,
    required this.eventCount,
    required this.offDayCount,
    required this.overnightEventCount,
    required this.content,
  });

  final String calendarName;
  final AppDateRange range;
  final String rangeLabel;
  final int eventCount;
  final int offDayCount;
  final int overnightEventCount;
  final String content;
}

class CalendarIcsBuilder {
  CalendarIcsBuilder({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  CalendarExportDocument build({
    required Job job,
    required AppDateRange range,
    required List<ShiftInstance> instances,
  }) {
    final sortedInstances = [
      ...instances,
    ]..sort((left, right) => left.startDateTime.compareTo(right.startDateTime));
    final nowUtc = _now().toUtc();
    final calendarName = '${job.name} schedule';
    final rangeLabel = _formatRange(range);
    final buffer = StringBuffer()
      ..write(_line('BEGIN:VCALENDAR'))
      ..write(_line('VERSION:2.0'))
      ..write(_line('PRODID:-//ShiftMate Pay//Calendar Export//EN'))
      ..write(_line('CALSCALE:GREGORIAN'))
      ..write(_line('METHOD:PUBLISH'))
      ..write(_line('X-WR-CALNAME:${_escapeText(calendarName)}'))
      ..write(
        _line(
          'X-WR-CALDESC:${_escapeText('ShiftMate Pay export for $rangeLabel. Refresh the file in the app after rota changes.')}',
        ),
      );

    var offDayCount = 0;
    var overnightEventCount = 0;

    for (final instance in sortedInstances) {
      final isOffDay = instance.overrideType == ShiftOverrideType.markOffDay;
      if (isOffDay) {
        offDayCount += 1;
      }
      if (!isOffDay && _isOvernight(instance)) {
        overnightEventCount += 1;
      }

      buffer
        ..write(_line('BEGIN:VEVENT'))
        ..write(_line('UID:${instance.id}@shiftmate-pay.local'))
        ..write(_line('DTSTAMP:${_formatUtc(nowUtc)}'))
        ..write(_buildDateLines(instance))
        ..write(
          _line('SUMMARY:${_escapeText(_summaryFor(job, instance, isOffDay))}'),
        )
        ..write(
          _line(
            'DESCRIPTION:${_escapeText(_descriptionFor(job, instance, isOffDay))}',
          ),
        )
        ..write(
          _line(
            'CATEGORIES:${_escapeText(isOffDay ? 'ShiftMate Pay,Off day' : 'ShiftMate Pay,Shift')}',
          ),
        )
        ..write(_line('STATUS:CONFIRMED'))
        ..write(_line(isOffDay ? 'TRANSP:TRANSPARENT' : 'TRANSP:OPAQUE'))
        ..write(_line('END:VEVENT'));
    }

    buffer.write(_line('END:VCALENDAR'));

    return CalendarExportDocument(
      calendarName: calendarName,
      range: range,
      rangeLabel: rangeLabel,
      eventCount: sortedInstances.length,
      offDayCount: offDayCount,
      overnightEventCount: overnightEventCount,
      content: buffer.toString(),
    );
  }

  String _buildDateLines(ShiftInstance instance) {
    if (instance.overrideType == ShiftOverrideType.markOffDay) {
      final start = _formatDateOnly(instance.date);
      final endExclusive = _formatDateOnly(
        instance.date.add(const Duration(days: 1)),
      );
      return '${_line('DTSTART;VALUE=DATE:$start')}${_line('DTEND;VALUE=DATE:$endExclusive')}';
    }

    return '${_line('DTSTART:${_formatFloatingLocal(instance.startDateTime)}')}${_line('DTEND:${_formatFloatingLocal(instance.endDateTime)}')}';
  }

  String _summaryFor(Job job, ShiftInstance instance, bool isOffDay) {
    if (isOffDay) {
      return '${job.name}: Off day';
    }

    return '${job.name}: ${instance.templateSnapshot?.name ?? 'Manual shift'}';
  }

  String _descriptionFor(Job job, ShiftInstance instance, bool isOffDay) {
    final parts = <String>[
      'Job: ${job.name}',
      if (isOffDay)
        'Marked as an off day in ShiftMate Pay.'
      else
        'Time: ${_timeLabel(instance.startDateTime)} to ${_timeLabel(instance.endDateTime)}',
      if (instance.isHoliday) 'Holiday flag: Yes',
      if (_isOvernight(instance)) 'Overnight shift: Yes',
      if (instance.unpaidBreakMinutes > 0)
        'Unpaid break: ${instance.unpaidBreakMinutes} minutes',
      if (instance.note?.trim().isNotEmpty ?? false)
        'Notes: ${instance.note!.trim()}',
    ];
    return parts.join('\n');
  }

  bool _isOvernight(ShiftInstance instance) {
    return instance.endDateTime.year != instance.startDateTime.year ||
        instance.endDateTime.month != instance.startDateTime.month ||
        instance.endDateTime.day != instance.startDateTime.day;
  }

  static String _formatRange(AppDateRange range) {
    final sameMonth =
        range.start.month == range.end.month &&
        range.start.year == range.end.year;
    final sameYear = range.start.year == range.end.year;

    if (sameMonth) {
      return '${DateFormat('d').format(range.start)}-${DateFormat('d MMMM yyyy').format(range.end)}';
    }
    if (sameYear) {
      return '${DateFormat('d MMM').format(range.start)} - ${DateFormat('d MMM yyyy').format(range.end)}';
    }
    return '${DateFormat('d MMM yyyy').format(range.start)} - ${DateFormat('d MMM yyyy').format(range.end)}';
  }

  static String _formatUtc(DateTime value) =>
      DateFormat("yyyyMMdd'T'HHmmss'Z'").format(value);

  static String _formatFloatingLocal(DateTime value) =>
      DateFormat("yyyyMMdd'T'HHmmss").format(value);

  static String _formatDateOnly(DateTime value) =>
      DateFormat('yyyyMMdd').format(value);

  static String _timeLabel(DateTime value) =>
      DateFormat('h:mm a').format(value);

  static String _line(String value) {
    final escaped = value.replaceAll('\r\n', r'\n').replaceAll('\n', r'\n');
    if (escaped.length <= 73) {
      return '$escaped\r\n';
    }

    final chunks = <String>[];
    for (var index = 0; index < escaped.length; index += 73) {
      chunks.add(
        escaped.substring(
          index,
          index + 73 > escaped.length ? escaped.length : index + 73,
        ),
      );
    }
    return '${chunks.first}\r\n${chunks.skip(1).map((chunk) => ' $chunk\r\n').join()}';
  }

  static String _escapeText(String input) {
    return input
        .replaceAll('\\', r'\\')
        .replaceAll(';', r'\;')
        .replaceAll(',', r'\,')
        .replaceAll('\r\n', r'\n')
        .replaceAll('\n', r'\n');
  }
}
