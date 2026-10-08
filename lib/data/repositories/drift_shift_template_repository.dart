import 'package:drift/drift.dart';

import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../core/common/shared_types.dart';
import '../../domain/entities/shift_template.dart';
import '../../domain/repositories/repositories.dart';
import '../local/database/app_database.dart';
import 'repository_utils.dart';

class DriftShiftTemplateRepository implements ShiftTemplateRepository {
  DriftShiftTemplateRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Result<void>> deleteTemplate(EntityId id) {
    return guardResult(() async {
      await (_database.delete(_database.shiftTemplatesTable)..where((table) => table.id.equals(id))).go();
    });
  }

  @override
  Future<Result<ShiftTemplate?>> getTemplateById(EntityId id) {
    return guardResult(() async {
      final row = await (_database.select(_database.shiftTemplatesTable)..where((table) => table.id.equals(id))).getSingleOrNull();
      return row == null ? null : _mapTemplate(row);
    });
  }

  @override
  Future<Result<List<ShiftTemplate>>> listTemplatesForJob(EntityId jobId) {
    return guardResult(() async {
      final rows = await (_database.select(_database.shiftTemplatesTable)
            ..where((table) => table.jobId.equals(jobId))
            ..orderBy([(table) => OrderingTerm(expression: table.name)]))
          .get();
      return rows.map(_mapTemplate).toList(growable: false);
    });
  }

  @override
  Future<Result<ShiftTemplate>> saveTemplate(ShiftTemplate template) {
    return guardResult(() async {
      await _database.into(_database.shiftTemplatesTable).insertOnConflictUpdate(
            ShiftTemplatesTableCompanion.insert(
              id: template.id,
              jobId: template.jobId,
              name: template.name,
              startMinutesLocal: template.startMinutesLocal,
              endMinutesLocal: template.endMinutesLocal,
              unpaidBreakMinutes: template.unpaidBreakMinutes,
              category: template.category.name,
              defaultNote: Value(template.defaultNote),
            ),
          );
      return template;
    });
  }

  ShiftTemplate _mapTemplate(ShiftTemplatesTableData row) {
    return ShiftTemplate(
      id: row.id,
      jobId: row.jobId,
      name: row.name,
      startMinutesLocal: row.startMinutesLocal,
      endMinutesLocal: row.endMinutesLocal,
      unpaidBreakMinutes: row.unpaidBreakMinutes,
      category: ShiftCategory.values.byName(row.category),
      defaultNote: row.defaultNote,
    );
  }
}
