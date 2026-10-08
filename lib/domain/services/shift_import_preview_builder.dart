import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';
import '../entities/import_preview.dart';
import '../entities/shift_instance.dart';

class ShiftImportPreviewBuilder {
  const ShiftImportPreviewBuilder();

  ShiftImportPreviewResult build({
    required EntityId jobId,
    required List<ParsedShiftImportRow> parsedRows,
    required List<ShiftInstance> existingShifts,
  }) {
    final sortedExisting = List<ShiftInstance>.of(
      existingShifts,
    )..sort((left, right) => left.startDateTime.compareTo(right.startDateTime));
    final existingShiftsByDate = _indexExistingShifts(sortedExisting);
    final previewRows = parsedRows
        .map(
          (row) => _buildPreviewRow(
            jobId: jobId,
            row: row,
            existingShiftsByDate: existingShiftsByDate,
          ),
        )
        .toList(growable: false);
    return ShiftImportPreviewResult(rows: List.unmodifiable(previewRows));
  }

  ImportPreviewRow _buildPreviewRow({
    required EntityId jobId,
    required ParsedShiftImportRow row,
    required Map<DateTime, List<ShiftInstance>> existingShiftsByDate,
  }) {
    if (!row.isValid) {
      return ImportPreviewRow(
        parsedRow: row,
        status: ImportPreviewRowStatus.skipped,
        message: row.issues.map((issue) => issue.message).join(' '),
        proposedShift: null,
        duplicateOfShiftId: null,
        conflictedShiftIds: const [],
        appliesAsOverride: false,
      );
    }

    final overlapping = _candidateExistingShifts(
      row,
      existingShiftsByDate,
    ).where((existing) => _overlaps(row, existing)).toList(growable: false);
    final duplicate = overlapping
        .where((existing) => _isDuplicate(row, existing))
        .firstOrNull;

    final appliesAsOverride = overlapping.isNotEmpty;
    final proposedShift = _buildProposedShift(
      jobId: jobId,
      row: row,
      appliesAsOverride: appliesAsOverride,
      overlapping: overlapping,
    );

    if (duplicate != null) {
      return ImportPreviewRow(
        parsedRow: row,
        status: ImportPreviewRowStatus.duplicate,
        message:
            'This row matches an existing saved shift closely enough to skip.',
        proposedShift: proposedShift,
        duplicateOfShiftId: duplicate.id,
        conflictedShiftIds: const [],
        appliesAsOverride: appliesAsOverride,
      );
    }

    if (overlapping.isNotEmpty) {
      return ImportPreviewRow(
        parsedRow: row,
        status: ImportPreviewRowStatus.conflict,
        message:
            'This row overlaps existing schedule data and should be reviewed before import.',
        proposedShift: proposedShift,
        duplicateOfShiftId: null,
        conflictedShiftIds: List.unmodifiable(
          overlapping.map((shift) => shift.id).toList(),
        ),
        appliesAsOverride: appliesAsOverride,
      );
    }

    return ImportPreviewRow(
      parsedRow: row,
      status: ImportPreviewRowStatus.accepted,
      message: appliesAsOverride
          ? 'Ready to import as a schedule override.'
          : 'Ready to import as a direct shift.',
      proposedShift: proposedShift,
      duplicateOfShiftId: null,
      conflictedShiftIds: const [],
      appliesAsOverride: appliesAsOverride,
    );
  }

  ShiftInstance _buildProposedShift({
    required EntityId jobId,
    required ParsedShiftImportRow row,
    required bool appliesAsOverride,
    required List<ShiftInstance> overlapping,
  }) {
    final snapshotName = row.shiftName ?? row.jobName ?? 'Imported shift';
    final existingPrimary = overlapping.isEmpty ? null : overlapping.first;
    final overrideType = !appliesAsOverride
        ? null
        : existingPrimary?.source == ShiftSource.pattern
        ? ShiftOverrideType.editGeneratedShift
        : ShiftOverrideType.replaceWithManualShift;

    return ShiftInstance(
      id: 'import-preview:$jobId:${row.rowNumber}',
      jobId: jobId,
      date: row.date!,
      templateSnapshot: ShiftTemplateSnapshot(
        templateId: null,
        name: snapshotName,
        category: row.category ?? ShiftCategory.custom,
        startMinutesLocal:
            (row.startDateTime!.hour * 60) + row.startDateTime!.minute,
        endMinutesLocal:
            ((row.endDateTime!.hour * 60) + row.endDateTime!.minute) %
            (24 * 60),
        unpaidBreakMinutes: row.unpaidBreakMinutes ?? 0,
        defaultNote: row.notes,
      ),
      startDateTime: row.startDateTime!,
      endDateTime: row.endDateTime!,
      unpaidBreakMinutes: row.unpaidBreakMinutes ?? 0,
      source: ShiftSource.imported,
      note: row.notes,
      isHoliday: row.isHoliday,
      overrideType: overrideType,
    );
  }

  bool _isDuplicate(ParsedShiftImportRow row, ShiftInstance existing) {
    return existing.date == row.date &&
        existing.startDateTime == row.startDateTime &&
        existing.endDateTime == row.endDateTime &&
        existing.isHoliday == row.isHoliday &&
        existing.unpaidBreakMinutes == (row.unpaidBreakMinutes ?? 0) &&
        (existing.note?.trim() ?? '') == (row.notes?.trim() ?? '');
  }

  bool _overlaps(ParsedShiftImportRow row, ShiftInstance existing) {
    if (existing.overrideType == ShiftOverrideType.markOffDay) {
      return existing.date == row.date;
    }
    return row.startDateTime!.isBefore(existing.endDateTime) &&
        row.endDateTime!.isAfter(existing.startDateTime);
  }

  Map<DateTime, List<ShiftInstance>> _indexExistingShifts(
    List<ShiftInstance> existingShifts,
  ) {
    final indexed = <DateTime, List<ShiftInstance>>{};
    for (final shift in existingShifts) {
      for (final date in _coveredDates(
        start: shift.startDateTime,
        end: shift.endDateTime,
      )) {
        indexed.putIfAbsent(date, () => <ShiftInstance>[]).add(shift);
      }
    }
    return indexed.map(
      (date, shifts) => MapEntry(date, List.unmodifiable(shifts)),
    );
  }

  List<ShiftInstance> _candidateExistingShifts(
    ParsedShiftImportRow row,
    Map<DateTime, List<ShiftInstance>> existingShiftsByDate,
  ) {
    final candidatesById = <EntityId, ShiftInstance>{};
    for (final date in _coveredDates(
      start: row.startDateTime!,
      end: row.endDateTime!,
    )) {
      for (final shift
          in existingShiftsByDate[date] ?? const <ShiftInstance>[]) {
        candidatesById[shift.id] = shift;
      }
    }
    return candidatesById.values.toList(growable: false);
  }

  Iterable<DateTime> _coveredDates({
    required DateTime start,
    required DateTime end,
  }) sync* {
    for (
      var date = DateTime(start.year, start.month, start.day);
      !date.isAfter(DateTime(end.year, end.month, end.day));
      date = date.add(const Duration(days: 1))
    ) {
      yield date;
    }
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
