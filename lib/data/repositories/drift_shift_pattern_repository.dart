import 'package:drift/drift.dart';

import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../domain/entities/shift_pattern.dart';
import '../../domain/repositories/repositories.dart';
import '../local/database/app_database.dart';
import 'repository_utils.dart';

class DriftShiftPatternRepository implements ShiftPatternRepository {
  DriftShiftPatternRepository(this._database);

  final AppDatabase _database;

  static const _defaultTimezone = 'local';

  @override
  Future<Result<ShiftPattern?>> getActivePatternForJob(EntityId jobId) {
    return guardResult(() async {
      final row = await (_database.select(_database.shiftPatternsTable)
            ..where((table) => table.jobId.equals(jobId) & table.isActive.equals(true))
            ..orderBy([(table) => OrderingTerm.desc(table.startDate)])
            ..limit(1))
          .getSingleOrNull();

      return row == null ? null : _mapPattern(row);
    });
  }

  @override
  Future<Result<List<ShiftPattern>>> listPatternsForJob(EntityId jobId) {
    return guardResult(() async {
      final rows = await (_database.select(_database.shiftPatternsTable)
            ..where((table) => table.jobId.equals(jobId))
            ..orderBy([
              (table) => OrderingTerm.desc(table.isActive),
              (table) => OrderingTerm(expression: table.startDate),
            ]))
          .get();

      return rows.map(_mapPattern).toList(growable: false);
    });
  }

  @override
  Future<Result<ShiftPattern>> savePattern(ShiftPattern pattern) {
    return guardResult(() async {
      await _database.transaction(() async {
        if (pattern.isActive) {
          await (_database.update(_database.shiftPatternsTable)
                ..where((table) => table.jobId.equals(pattern.jobId)))
              .write(const ShiftPatternsTableCompanion(isActive: Value(false)));
        }

        await _database.into(_database.shiftPatternsTable).insertOnConflictUpdate(
              ShiftPatternsTableCompanion.insert(
                id: pattern.id,
                jobId: pattern.jobId,
                name: pattern.name,
                cycleLengthDays: pattern.cycleLengthDays,
                startDate: pattern.startDate,
                isActive: Value(pattern.isActive),
              ),
            );
      });

      return pattern;
    });
  }

  @override
  Future<Result<void>> setPatternActive({
    required EntityId patternId,
    required bool isActive,
  }) {
    return guardResult(() async {
      final existing = await (_database.select(_database.shiftPatternsTable)
            ..where((table) => table.id.equals(patternId)))
          .getSingleOrNull();

      if (existing == null) {
        throw StateError('Shift pattern not found for id $patternId');
      }

      await _database.transaction(() async {
        if (isActive) {
          await (_database.update(_database.shiftPatternsTable)
                ..where((table) => table.jobId.equals(existing.jobId)))
              .write(const ShiftPatternsTableCompanion(isActive: Value(false)));
        }

        await (_database.update(_database.shiftPatternsTable)
              ..where((table) => table.id.equals(patternId)))
            .write(ShiftPatternsTableCompanion(isActive: Value(isActive)));
      });
    });
  }

  ShiftPattern _mapPattern(ShiftPatternsTableData row) {
    return ShiftPattern(
      id: row.id,
      jobId: row.jobId,
      name: row.name,
      cycleLengthDays: row.cycleLengthDays,
      startDate: row.startDate,
      timezone: _defaultTimezone,
      isActive: row.isActive,
    );
  }
}
