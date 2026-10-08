import 'package:intl/intl.dart';

import '../../core/common/shared_types.dart';
import '../entities/import_preview.dart';

class CsvShiftImportParser {
  const CsvShiftImportParser();

  static const Map<String, List<String>> _headerAliases = {
    'date': ['date', 'shift_date', 'day'],
    'start_time': ['start', 'start_time', 'clock_in', 'from'],
    'end_time': ['end', 'end_time', 'clock_out', 'to'],
    'job_name': ['job', 'job_name', 'role', 'location'],
    'shift_name': ['shift_name', 'template', 'shift', 'label'],
    'category': ['category', 'type', 'shift_type'],
    'unpaid_break_minutes': ['break', 'break_minutes', 'unpaid_break_minutes'],
    'is_holiday': ['holiday', 'is_holiday', 'bank_holiday'],
    'notes': ['notes', 'note', 'comment', 'comments'],
  };

  CsvShiftImportParseResult parse(String csvContent) {
    final csvTable = _parseCsvRows(csvContent);
    final rows = csvTable.rows;
    if (rows.isEmpty) {
      return const CsvShiftImportParseResult(
        headerMap: <String, String>{},
        rows: <ParsedShiftImportRow>[],
      );
    }

    final rawHeader = rows.first;
    final headerMap = _buildHeaderMap(rawHeader);
    final parsedRows = <ParsedShiftImportRow>[];

    for (var index = 1; index < rows.length; index++) {
      final row = rows[index];
      final rawValues = <String, String>{};
      for (var columnIndex = 0; columnIndex < rawHeader.length; columnIndex++) {
        final headerName = rawHeader[columnIndex].trim();
        rawValues[headerName] = columnIndex < row.length
            ? row[columnIndex].trim()
            : '';
      }
      parsedRows.add(
        _parseRow(
          rowNumber: index + 1,
          row: row,
          headerRow: rawHeader,
          headerMap: headerMap,
          rawValues: rawValues,
          hasUnterminatedQuote:
              csvTable.hasUnterminatedQuote && index == rows.length - 1,
        ),
      );
    }

    return CsvShiftImportParseResult(
      headerMap: headerMap,
      rows: List.unmodifiable(parsedRows),
    );
  }

  ParsedShiftImportRow _parseRow({
    required int rowNumber,
    required List<String> row,
    required List<String> headerRow,
    required Map<String, String> headerMap,
    required Map<String, String> rawValues,
    required bool hasUnterminatedQuote,
  }) {
    final issues = <ParsedImportIssue>[];
    if (row.length > headerRow.length) {
      issues.add(
        ParsedImportIssue(
          code: ParsedImportIssueCode.invalidRowShape,
          message:
              'This row has more columns than the header. Check for stray commas or broken quoting.',
        ),
      );
    }
    if (hasUnterminatedQuote) {
      issues.add(
        const ParsedImportIssue(
          code: ParsedImportIssueCode.invalidRowShape,
          message:
              'This row ends inside a quoted field. Close the quote and try the import again.',
        ),
      );
    }
    final dateText = _valueFor('date', row, headerRow, headerMap);
    final startText = _valueFor('start_time', row, headerRow, headerMap);
    final endText = _valueFor('end_time', row, headerRow, headerMap);
    final breakText = _valueFor(
      'unpaid_break_minutes',
      row,
      headerRow,
      headerMap,
    );
    final categoryText = _valueFor('category', row, headerRow, headerMap);

    if (dateText == null || dateText.isEmpty) {
      issues.add(
        const ParsedImportIssue(
          code: ParsedImportIssueCode.missingDate,
          message: 'Date is required.',
        ),
      );
    }
    if (startText == null || startText.isEmpty) {
      issues.add(
        const ParsedImportIssue(
          code: ParsedImportIssueCode.missingStartTime,
          message: 'Start time is required.',
        ),
      );
    }
    if (endText == null || endText.isEmpty) {
      issues.add(
        const ParsedImportIssue(
          code: ParsedImportIssueCode.missingEndTime,
          message: 'End time is required.',
        ),
      );
    }

    final parsedDate = dateText == null || dateText.isEmpty
        ? null
        : _parseDate(dateText, issues);
    final parsedStart =
        parsedDate == null || startText == null || startText.isEmpty
        ? null
        : _parseTime(
            dateText: startText,
            date: parsedDate,
            issueCode: ParsedImportIssueCode.invalidStartTime,
            issues: issues,
          );
    final parsedEnd = parsedDate == null || endText == null || endText.isEmpty
        ? null
        : _parseTime(
            dateText: endText,
            date: parsedDate,
            issueCode: ParsedImportIssueCode.invalidEndTime,
            issues: issues,
          );

    DateTime? normalizedEnd = parsedEnd;
    if (parsedStart != null &&
        parsedEnd != null &&
        !parsedEnd.isAfter(parsedStart)) {
      normalizedEnd = parsedEnd.add(const Duration(days: 1));
    }

    Minutes? unpaidBreakMinutes;
    if (breakText != null && breakText.isNotEmpty) {
      final parsedBreak = int.tryParse(breakText.trim());
      if (parsedBreak == null || parsedBreak < 0) {
        issues.add(
          const ParsedImportIssue(
            code: ParsedImportIssueCode.invalidBreakMinutes,
            message: 'Break minutes must be a whole number.',
          ),
        );
      } else {
        unpaidBreakMinutes = parsedBreak;
      }
    }

    final category = _parseCategory(categoryText, issues);
    return ParsedShiftImportRow(
      rowNumber: rowNumber,
      rawValues: rawValues,
      date: parsedDate,
      startDateTime: parsedStart,
      endDateTime: normalizedEnd,
      jobName: _nullableValue(_valueFor('job_name', row, headerRow, headerMap)),
      shiftName: _nullableValue(
        _valueFor('shift_name', row, headerRow, headerMap),
      ),
      category: category,
      unpaidBreakMinutes: unpaidBreakMinutes,
      isHoliday: _parseHoliday(
        _valueFor('is_holiday', row, headerRow, headerMap),
      ),
      notes: _nullableValue(_valueFor('notes', row, headerRow, headerMap)),
      issues: List.unmodifiable(issues),
    );
  }

  String? _valueFor(
    String canonicalField,
    List<String> row,
    List<String> headerRow,
    Map<String, String> headerMap,
  ) {
    final matchedHeader = headerMap[canonicalField];
    if (matchedHeader == null) {
      return null;
    }
    final index = headerRow.indexWhere(
      (value) => value.trim() == matchedHeader,
    );
    if (index < 0 || index >= row.length) {
      return null;
    }
    return row[index].trim();
  }

  Map<String, String> _buildHeaderMap(List<String> headerRow) {
    final normalizedHeaders = {
      for (final header in headerRow)
        _normalizeHeader(header): _stripBom(header).trim(),
    };
    final headerMap = <String, String>{};
    for (final entry in _headerAliases.entries) {
      for (final alias in entry.value) {
        final matched = normalizedHeaders[_normalizeHeader(alias)];
        if (matched != null) {
          headerMap[entry.key] = matched;
          break;
        }
      }
    }
    return Map.unmodifiable(headerMap);
  }

  DateTime? _parseDate(String value, List<ParsedImportIssue> issues) {
    final trimmed = value.trim();
    if (trimmed.contains('/')) {
      final parts = trimmed.split('/');
      if (parts.length == 3) {
        final first = int.tryParse(parts[0]);
        final second = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (first != null && second != null && year != null) {
          final normalizedYear = year < 100 ? 2000 + year : year;
          if (first <= 12 && second <= 12 && first != second) {
            issues.add(
              ParsedImportIssue(
                code: ParsedImportIssueCode.invalidDate,
                message:
                    'Date "$trimmed" is ambiguous. Use ISO format like 2026-04-04 instead.',
              ),
            );
            return null;
          }
          final month = first > 12 ? second : first;
          final day = first > 12 ? first : second;
          final candidate = DateTime(normalizedYear, month, day);
          if (candidate.month == month && candidate.day == day) {
            return candidate;
          }
        }
      }
    }

    for (final pattern in [
      'yyyy-MM-dd',
      'd MMM yyyy',
      'd MMMM yyyy',
      'yyyy/MM/dd',
      'dd/MM/yyyy',
      'd/M/yy',
      'd/M/yyyy',
      'M/d/yyyy',
      'M/d/yy',
    ]) {
      try {
        final parsed = DateFormat(pattern).parseStrict(trimmed);
        return DateTime(parsed.year, parsed.month, parsed.day);
      } catch (_) {
        // Try the next format.
      }
    }

    issues.add(
      ParsedImportIssue(
        code: ParsedImportIssueCode.invalidDate,
        message: 'Date "$trimmed" could not be parsed.',
      ),
    );
    return null;
  }

  DateTime? _parseTime({
    required String dateText,
    required DateTime date,
    required ParsedImportIssueCode issueCode,
    required List<ParsedImportIssue> issues,
  }) {
    final trimmed = dateText
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .toUpperCase();
    for (final pattern in ['HH:mm', 'H:mm', 'h:mm a', 'h a']) {
      try {
        final parsed = DateFormat(pattern).parseStrict(trimmed);
        return DateTime(
          date.year,
          date.month,
          date.day,
          parsed.hour,
          parsed.minute,
        );
      } catch (_) {
        // Try the next format.
      }
    }

    issues.add(
      ParsedImportIssue(
        code: issueCode,
        message: 'Time "$trimmed" could not be parsed.',
      ),
    );
    return null;
  }

  ShiftCategory? _parseCategory(String? value, List<ParsedImportIssue> issues) {
    final normalized = _nullableValue(value)?.toLowerCase();
    if (normalized == null) {
      return null;
    }
    return switch (normalized) {
      'day' => ShiftCategory.day,
      'evening' => ShiftCategory.evening,
      'night' => ShiftCategory.night,
      'custom' => ShiftCategory.custom,
      _ => () {
        issues.add(
          ParsedImportIssue(
            code: ParsedImportIssueCode.unsupportedCategory,
            message:
                'Category "$value" is not supported. Use day, evening, night, or custom.',
          ),
        );
        return null;
      }(),
    };
  }

  bool _parseHoliday(String? value) {
    final normalized = _nullableValue(value)?.toLowerCase();
    return normalized == 'true' || normalized == 'yes' || normalized == '1';
  }

  String? _nullableValue(String? value) {
    if (value == null) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _normalizeHeader(String value) {
    return _stripBom(
      value,
    ).trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
  }

  String _stripBom(String value) {
    return value.startsWith('\uFEFF') ? value.substring(1) : value;
  }

  _ParsedCsvTable _parseCsvRows(String csvContent) {
    final normalizedContent = csvContent
        .replaceFirst('\uFEFF', '')
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n');
    final rows = <List<String>>[];
    final currentRow = <String>[];
    final currentCell = StringBuffer();
    var inQuotes = false;

    for (var index = 0; index < normalizedContent.length; index++) {
      final char = normalizedContent[index];
      if (char == '"') {
        if (inQuotes &&
            index + 1 < normalizedContent.length &&
            normalizedContent[index + 1] == '"') {
          currentCell.write('"');
          index++;
        } else {
          inQuotes = !inQuotes;
        }
        continue;
      }
      if (char == ',' && !inQuotes) {
        currentRow.add(currentCell.toString());
        currentCell.clear();
        continue;
      }
      if (char == '\n' && !inQuotes) {
        currentRow.add(currentCell.toString());
        currentCell.clear();
        if (currentRow.any((value) => value.trim().isNotEmpty)) {
          rows.add(List.unmodifiable(currentRow.toList()));
        }
        currentRow.clear();
        continue;
      }
      currentCell.write(char);
    }

    if (currentCell.isNotEmpty || currentRow.isNotEmpty) {
      currentRow.add(currentCell.toString());
      if (currentRow.any((value) => value.trim().isNotEmpty)) {
        rows.add(List.unmodifiable(currentRow.toList()));
      }
    }

    return _ParsedCsvTable(
      rows: List.unmodifiable(rows),
      hasUnterminatedQuote: inQuotes,
    );
  }
}

class _ParsedCsvTable {
  const _ParsedCsvTable({
    required this.rows,
    required this.hasUnterminatedQuote,
  });

  final List<List<String>> rows;
  final bool hasUnterminatedQuote;
}
