import 'package:drift/drift.dart';

import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../core/common/shared_types.dart';
import '../../core/time/app_date_range.dart';
import '../../core/time/date_range_extensions.dart';
import '../../domain/entities/shift_instance.dart';
import '../../domain/repositories/repositories.dart';
import '../local/database/app_database.dart';
import 'repository_utils.dart';

class DriftShiftInstanceRepository implements ShiftInstanceRepository {
  DriftShiftInstanceRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Result<void>> deleteInstance(EntityId id) {
    return guardResult(() async {
      await (_database.delete(_database.shiftInstancesTable)..where((table) => table.id.equals(id))).go();
    });
  }

  @override
  Future<Result<ShiftInstance?>> getInstanceById(EntityId id) {
    return guardResult(() async {
      final row = await (_database.select(_database.shiftInstancesTable)..where((table) => table.id.equals(id))).getSingleOrNull();
      if (row == null) {
        return null;
      }

      final templatesById = await _loadTemplatesById(
        row.shiftTemplateId == null ? const <String>{} : {row.shiftTemplateId!},
      );
      return _mapInstance(row, templatesById);
    });
  }

  @override
  Future<Result<List<ShiftInstance>>> listInstancesForRange({
    required EntityId jobId,
    required AppDateRange range,
  }) {
    return guardResult(() async {
      final normalizedStart = range.start.startOfDay;
      final normalizedEndExclusive = range.end.startOfDay.add(const Duration(days: 1));

      final rows = await (_database.select(_database.shiftInstancesTable)
            ..where(
              (table) =>
                  table.jobId.equals(jobId) &
                  table.startDateTime.isBiggerOrEqualValue(normalizedStart) &
                  table.startDateTime.isSmallerThanValue(normalizedEndExclusive),
            )
            ..orderBy([
              (table) => OrderingTerm(expression: table.startDateTime),
              (table) => OrderingTerm(expression: table.id),
            ]))
          .get();

      final templateIds = rows.map((row) => row.shiftTemplateId).whereType<String>().toSet();
      final templatesById = await _loadTemplatesById(templateIds);

      return rows.map((row) => _mapInstance(row, templatesById)).toList(growable: false);
    });
  }

  @override
  Future<Result<ShiftInstance>> saveInstance(ShiftInstance instance) {
    return guardResult(() async {
      await _database.into(_database.shiftInstancesTable).insertOnConflictUpdate(
            ShiftInstancesTableCompanion.insert(
              id: instance.id,
              jobId: instance.jobId,
              shiftTemplateId: Value(instance.templateSnapshot?.templateId),
              startDateTime: instance.startDateTime,
              endDateTime: instance.endDateTime,
              unpaidBreakMinutes: instance.unpaidBreakMinutes,
              source: instance.source.name,
              overrideType: Value(instance.overrideType?.name),
              note: Value(instance.note),
              isOffDay: Value(instance.overrideType == ShiftOverrideType.markOffDay),
              isHoliday: Value(instance.isHoliday),
              createdAt: instance.startDateTime,
              updatedAt: DateTime.now(),
            ),
          );

      return instance;
    });
  }

  Future<Map<String, ShiftTemplatesTableData>> _loadTemplatesById(Set<String> templateIds) async {
    if (templateIds.isEmpty) {
      return const <String, ShiftTemplatesTableData>{};
    }

    final rows = await (_database.select(_database.shiftTemplatesTable)
          ..where((table) => table.id.isIn(templateIds)))
        .get();

    return {
      for (final row in rows) row.id: row,
    };
  }

  ShiftInstance _mapInstance(
    ShiftInstancesTableData row,
    Map<String, ShiftTemplatesTableData> templatesById,
  ) {
    final templateRow = row.shiftTemplateId == null ? null : templatesById[row.shiftTemplateId!];

    return ShiftInstance(
      id: row.id,
      jobId: row.jobId,
      date: row.startDateTime.startOfDay,
      templateSnapshot: row.shiftTemplateId == null
          ? null
          : ShiftTemplateSnapshot(
              templateId: row.shiftTemplateId,
              name: templateRow?.name ?? 'Manual shift',
              category: templateRow == null
                  ? ShiftCategory.custom
                  : ShiftCategory.values.byName(templateRow.category),
              startMinutesLocal: row.startDateTime.hour * 60 + row.startDateTime.minute,
              endMinutesLocal: row.endDateTime.hour * 60 + row.endDateTime.minute,
              unpaidBreakMinutes: row.unpaidBreakMinutes,
              defaultNote: row.note ?? templateRow?.defaultNote,
            ),
      startDateTime: row.startDateTime,
      endDateTime: row.endDateTime,
      unpaidBreakMinutes: row.unpaidBreakMinutes,
      source: ShiftSource.values.byName(row.source),
      note: row.note,
      isHoliday: row.isHoliday,
      overrideType: row.overrideType == null ? null : ShiftOverrideType.values.byName(row.overrideType!),
    );
  }
}
