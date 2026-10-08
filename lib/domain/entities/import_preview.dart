import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';
import 'shift_instance.dart';

enum ImportPreviewRowStatus { accepted, duplicate, conflict, skipped }

enum ParsedImportIssueCode {
  missingDate,
  missingStartTime,
  missingEndTime,
  invalidDate,
  invalidStartTime,
  invalidEndTime,
  invalidBreakMinutes,
  unsupportedCategory,
  invalidRowShape,
}

class ParsedImportIssue {
  const ParsedImportIssue({required this.code, required this.message});

  final ParsedImportIssueCode code;
  final String message;
}

class ParsedShiftImportRow {
  const ParsedShiftImportRow({
    required this.rowNumber,
    required this.rawValues,
    required this.date,
    required this.startDateTime,
    required this.endDateTime,
    required this.jobName,
    required this.shiftName,
    required this.category,
    required this.unpaidBreakMinutes,
    required this.isHoliday,
    required this.notes,
    required this.issues,
  });

  final int rowNumber;
  final Map<String, String> rawValues;
  final DateTime? date;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final String? jobName;
  final String? shiftName;
  final ShiftCategory? category;
  final Minutes? unpaidBreakMinutes;
  final bool isHoliday;
  final String? notes;
  final List<ParsedImportIssue> issues;

  bool get isValid =>
      date != null &&
      startDateTime != null &&
      endDateTime != null &&
      issues.isEmpty;
}

class CsvShiftImportParseResult {
  const CsvShiftImportParseResult({
    required this.headerMap,
    required this.rows,
  });

  final Map<String, String> headerMap;
  final List<ParsedShiftImportRow> rows;
}

class ImportPreviewRow {
  const ImportPreviewRow({
    required this.parsedRow,
    required this.status,
    required this.message,
    required this.proposedShift,
    required this.duplicateOfShiftId,
    required this.conflictedShiftIds,
    required this.appliesAsOverride,
  });

  final ParsedShiftImportRow parsedRow;
  final ImportPreviewRowStatus status;
  final String message;
  final ShiftInstance? proposedShift;
  final EntityId? duplicateOfShiftId;
  final List<EntityId> conflictedShiftIds;
  final bool appliesAsOverride;
}

class ShiftImportPreviewResult {
  const ShiftImportPreviewResult({required this.rows});

  final List<ImportPreviewRow> rows;

  int get totalRows => rows.length;

  int get acceptedRowCount =>
      rows.where((row) => row.status == ImportPreviewRowStatus.accepted).length;

  int get duplicateRowCount => rows
      .where((row) => row.status == ImportPreviewRowStatus.duplicate)
      .length;

  int get conflictRowCount =>
      rows.where((row) => row.status == ImportPreviewRowStatus.conflict).length;

  int get skippedRowCount =>
      rows.where((row) => row.status == ImportPreviewRowStatus.skipped).length;
}
