import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/domain/entities/import_preview.dart';
import 'package:shiftmate_pay/domain/services/csv_shift_import_parser.dart';

void main() {
  const parser = CsvShiftImportParser();

  test(
    'parses realistic CSV rows with aliases, notes, and overnight shifts',
    () {
      const csv = '''
day,from,to,role,template,shift_type,break,bank_holiday,comments
2026-04-04,7:30 PM,7:30 AM,Night ward,Night block,night,45,yes,"Bring badge, pager"
5 Apr 2026,08:00,16:00,Clinic,Day shift,day,30,no,
''';

      final result = parser.parse(csv);

      expect(result.headerMap['date'], 'day');
      expect(result.headerMap['start_time'], 'from');
      expect(result.rows, hasLength(2));

      final first = result.rows.first;
      expect(first.isValid, isTrue);
      expect(first.jobName, 'Night ward');
      expect(first.shiftName, 'Night block');
      expect(first.category, ShiftCategory.night);
      expect(first.unpaidBreakMinutes, 45);
      expect(first.isHoliday, isTrue);
      expect(first.notes, 'Bring badge, pager');
      expect(first.startDateTime, DateTime(2026, 4, 4, 19, 30));
      expect(first.endDateTime, DateTime(2026, 4, 5, 7, 30));

      final second = result.rows[1];
      expect(second.isValid, isTrue);
      expect(second.category, ShiftCategory.day);
      expect(second.notes, isNull);
    },
  );

  test('flags malformed and ambiguous rows with user-facing issues', () {
    const csv = '''
date,start_time,end_time,break,category
05/06/2026,09:00,17:00,abc,unknown
,09:00,17:00,30,day
''';

    final result = parser.parse(csv);

    expect(result.rows, hasLength(2));

    final ambiguous = result.rows.first;
    expect(ambiguous.isValid, isFalse);
    expect(
      ambiguous.issues.map((issue) => issue.code),
      containsAll([
        ParsedImportIssueCode.invalidDate,
        ParsedImportIssueCode.invalidBreakMinutes,
        ParsedImportIssueCode.unsupportedCategory,
      ]),
    );

    final missingDate = result.rows[1];
    expect(missingDate.isValid, isFalse);
    expect(
      missingDate.issues.map((issue) => issue.code),
      contains(ParsedImportIssueCode.missingDate),
    );
  });

  test('handles BOM headers and flags malformed row shape issues', () {
    const csv = '''
\uFEFFdate,start_time,end_time,notes
2026-04-04,09:00,17:00,Normal row
2026-04-05,09:00,17:00,Too,many,columns
"2026-04-06,09:00,17:00,Unclosed quote
''';

    final result = parser.parse(csv);

    expect(result.headerMap['date'], 'date');
    expect(result.rows, hasLength(3));
    expect(result.rows.first.isValid, isTrue);
    expect(
      result.rows[1].issues.map((issue) => issue.code),
      contains(ParsedImportIssueCode.invalidRowShape),
    );
    expect(
      result.rows[2].issues.map((issue) => issue.code),
      contains(ParsedImportIssueCode.invalidRowShape),
    );
  });
}
