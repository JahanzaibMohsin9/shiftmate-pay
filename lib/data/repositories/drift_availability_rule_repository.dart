import 'package:drift/drift.dart';

import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../domain/entities/availability_rule.dart';
import '../../domain/repositories/repositories.dart';
import '../local/database/app_database.dart';
import 'repository_utils.dart';

class DriftAvailabilityRuleRepository implements AvailabilityRuleRepository {
  DriftAvailabilityRuleRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Result<void>> delete(EntityId id) {
    return guardResult(() async {
      await (_database.delete(
        _database.availabilityRulesTable,
      )..where((table) => table.id.equals(id))).go();
    });
  }

  @override
  Future<Result<List<AvailabilityRule>>> listForJob(EntityId jobId) {
    return guardResult(() async {
      final rows =
          await (_database.select(_database.availabilityRulesTable)
                ..where((table) => table.jobId.equals(jobId))
                ..orderBy([
                  (table) => OrderingTerm(expression: table.startDateTime),
                  (table) => OrderingTerm(expression: table.createdAt),
                ]))
              .get();
      return rows.map(_map).toList(growable: false);
    });
  }

  @override
  Future<Result<AvailabilityRule>> save(AvailabilityRule rule) {
    return guardResult(() async {
      await _database
          .into(_database.availabilityRulesTable)
          .insertOnConflictUpdate(
            AvailabilityRulesTableCompanion.insert(
              id: rule.id,
              jobId: rule.jobId,
              type: rule.type.name,
              state: rule.state.name,
              startDateTime: Value(rule.startDateTime),
              endDateTime: Value(rule.endDateTime),
              weekday: Value(rule.weekday),
              startMinuteOfDay: Value(rule.startMinuteOfDay),
              endMinuteOfDay: Value(rule.endMinuteOfDay),
              note: Value(rule.note),
              isEnabled: Value(rule.isEnabled),
              createdAt: rule.createdAt,
              updatedAt: rule.updatedAt,
            ),
          );
      return rule;
    });
  }

  AvailabilityRule _map(AvailabilityRulesTableData row) {
    return AvailabilityRule(
      id: row.id,
      jobId: row.jobId,
      type: AvailabilityRuleType.values.byName(row.type),
      state: AvailabilityState.values.byName(row.state),
      startDateTime: row.startDateTime,
      endDateTime: row.endDateTime,
      weekday: row.weekday,
      startMinuteOfDay: row.startMinuteOfDay,
      endMinuteOfDay: row.endMinuteOfDay,
      note: row.note,
      isEnabled: row.isEnabled,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
