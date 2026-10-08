import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/core/money/currency_amount.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/domain/entities/job.dart';
import 'package:shiftmate_pay/domain/entities/shift_instance.dart';
import 'package:shiftmate_pay/domain/services/calendar_ics_builder.dart';

void main() {
  final job = Job(
    id: 'job-1',
    name: 'Ward rota',
    colorHex: '#4F46E5',
    currencyCode: 'USD',
    hourlyRate: const CurrencyAmount(minorUnits: 3200, currencyCode: 'USD'),
    payRuleSetId: 'pay-rules-1',
    holidayRuleSetId: 'holiday-rules-1',
    defaultSleepLeadMinutes: 480,
    isArchived: false,
    createdAt: DateTime.utc(2026, 4, 1),
    updatedAt: DateTime.utc(2026, 4, 1),
  );

  test('builds timed events for shifts and preserves overnight end dates', () {
    final builder = CalendarIcsBuilder(
      now: () => DateTime.utc(2026, 4, 4, 10, 15),
    );
    final document = builder.build(
      job: job,
      range: AppDateRange(
        start: DateTime(2026, 4, 10),
        end: DateTime(2026, 4, 12),
      ),
      instances: [
        _shift(
          id: 'shift-1',
          date: DateTime(2026, 4, 10),
          start: DateTime(2026, 4, 10, 22),
          end: DateTime(2026, 4, 11, 6),
          note: 'Night cover',
        ),
      ],
    );

    expect(document.eventCount, 1);
    expect(document.overnightEventCount, 1);
    expect(document.content, contains('BEGIN:VCALENDAR'));
    expect(document.content, contains('UID:shift-1@shiftmate-pay.local'));
    expect(document.content, contains('DTSTAMP:20260404T101500Z'));
    expect(document.content, contains('DTSTART:20260410T220000'));
    expect(document.content, contains('DTEND:20260411T060000'));
    expect(document.content, contains('SUMMARY:Ward rota: Early'));
    expect(
      document.content,
      contains(r'DESCRIPTION:Job: Ward rota\nTime: 10:00 PM to 6:00 AM'),
    );
    expect(document.content, contains(r'Overnight shift: Y'));
    expect(
      document.content,
      contains(r'es\nUnpaid break: 30 minutes\nNotes: Night cover'),
    );
    expect(document.content, contains('TRANSP:OPAQUE'));
  });

  test('builds all-day transparent events for off days', () {
    final builder = CalendarIcsBuilder(
      now: () => DateTime.utc(2026, 4, 4, 10, 15),
    );
    final document = builder.build(
      job: job,
      range: AppDateRange(
        start: DateTime(2026, 4, 10),
        end: DateTime(2026, 4, 12),
      ),
      instances: [_offDay(id: 'off-1', date: DateTime(2026, 4, 12))],
    );

    expect(document.eventCount, 1);
    expect(document.offDayCount, 1);
    expect(document.overnightEventCount, 0);
    expect(document.content, contains('DTSTART;VALUE=DATE:20260412'));
    expect(document.content, contains('DTEND;VALUE=DATE:20260413'));
    expect(document.content, contains('SUMMARY:Ward rota: Off day'));
    expect(document.content, contains('TRANSP:TRANSPARENT'));
    expect(
      document.content,
      contains(
        r'DESCRIPTION:Job: Ward rota\nMarked as an off day in ShiftMate Pay.',
      ),
    );
  });
}

ShiftInstance _shift({
  required String id,
  required DateTime date,
  required DateTime start,
  required DateTime end,
  String? note,
}) {
  return ShiftInstance(
    id: id,
    jobId: 'job-1',
    date: date,
    templateSnapshot: const ShiftTemplateSnapshot(
      templateId: 'template-1',
      name: 'Early',
      category: ShiftCategory.day,
      startMinutesLocal: 1320,
      endMinutesLocal: 360,
      unpaidBreakMinutes: 30,
      defaultNote: null,
    ),
    startDateTime: start,
    endDateTime: end,
    unpaidBreakMinutes: 30,
    source: ShiftSource.pattern,
    note: note,
    isHoliday: false,
    overrideType: null,
  );
}

ShiftInstance _offDay({required String id, required DateTime date}) {
  return ShiftInstance(
    id: id,
    jobId: 'job-1',
    date: date,
    templateSnapshot: null,
    startDateTime: date,
    endDateTime: date.add(const Duration(days: 1)),
    unpaidBreakMinutes: 0,
    source: ShiftSource.manual,
    note: null,
    isHoliday: false,
    overrideType: ShiftOverrideType.markOffDay,
  );
}
