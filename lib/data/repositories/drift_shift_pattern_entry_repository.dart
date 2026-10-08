import 'package:drift/drift.dart';

import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../domain/entities/shift_pattern_entry.dart';
import '../../domain/repositories/repositories.dart';
import '../local/database/app_database.dart';
import 'repository_utils.dart';

class DriftShiftPatternEntryRepository implements ShiftPatternEntryRepository {
  DriftShiftPatternEntryRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Result<List<ShiftPatternEntry>>> listEntriesForPattern(EntityId patternId) {
    return guardResult(() async {
      final rows = await (_database.select(_database.shiftPatternEntriesTable)
            ..where((table) => table.patternId.equals(patternId))
            ..orderBy([(table) => OrderingTerm(expression: table.dayIndex)]))
          .get();

      return rows.map(_mapEntry).toList(growable: false);
    });
  }

  @override
  Future<Result<List<ShiftPatternEntry>>> replaceEntries({
    required EntityId patternId,
    required List<ShiftPatternEntry> entries,
  }) {
    return guardResult(() async {
      await _database.transaction(() async {
        await (_database.delete(_database.shiftPatternEntriesTable)
              ..where((table) => table.patternId.equals(patternId)))
            .go();

        for (final entry in entries) {
          await _database.into(_database.shiftPatternEntriesTable).insert(
                ShiftPatternEntriesTableCompanion.insert(
                  id: entry.id,
                  patternId: patternId,
                  dayIndex: entry.dayOffset,
                  shiftTemplateId: Value(entry.shiftTemplateId),
                  isOffDay: Value(entry.isOffDay),
                ),
              );
        }
      });

      return entries;
    });
  }

  ShiftPatternEntry _mapEntry(ShiftPatternEntriesTableData row) {
    return ShiftPatternEntry(
      id: row.id,
      patternId: row.patternId,
      dayOffset: row.dayIndex,
      shiftTemplateId: row.shiftTemplateId,
      isOffDay: row.isOffDay,
    );
  }
}
