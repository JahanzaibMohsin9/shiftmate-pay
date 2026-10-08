import 'package:drift/drift.dart';

import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../core/common/shared_types.dart';
import '../../domain/entities/reminder_rule.dart';
import '../../domain/repositories/repositories.dart';
import '../local/database/app_database.dart';
import 'repository_utils.dart';

class DriftReminderRuleRepository implements ReminderRuleRepository {
  DriftReminderRuleRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Result<void>> delete(EntityId id) {
    return guardResult(() async {
      await (_database.delete(_database.reminderRulesTable)
            ..where((table) => table.id.equals(id)))
          .go();
    });
  }

  @override
  Future<Result<List<ReminderRule>>> listForJob(EntityId jobId) {
    return guardResult(() async {
      final rows = await (_database.select(_database.reminderRulesTable)
            ..where((table) => table.jobId.equals(jobId))
            ..orderBy([
              (table) => OrderingTerm(expression: table.type),
              (table) => OrderingTerm(expression: table.leadMinutes),
            ]))
          .get();

      return rows.map(_mapRule).toList(growable: false);
    });
  }

  @override
  Future<Result<ReminderRule>> save(ReminderRule rule) {
    return guardResult(() async {
      await _database.into(_database.reminderRulesTable).insertOnConflictUpdate(
            ReminderRulesTableCompanion.insert(
              id: rule.id,
              jobId: rule.jobId,
              type: rule.type.name,
              leadMinutes: rule.leadMinutes,
              enabled: Value(rule.enabled),
            ),
          );

      return rule;
    });
  }

  ReminderRule _mapRule(ReminderRulesTableData row) {
    return ReminderRule(
      id: row.id,
      jobId: row.jobId,
      type: ReminderType.values.byName(row.type),
      leadMinutes: row.leadMinutes,
      enabled: row.enabled,
    );
  }
}
