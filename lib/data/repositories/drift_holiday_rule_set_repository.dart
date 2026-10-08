import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../core/common/shared_types.dart';
import '../../domain/entities/holiday_rule_set.dart';
import '../../domain/repositories/repositories.dart';
import '../local/database/app_database.dart';
import 'repository_utils.dart';

class DriftHolidayRuleSetRepository implements HolidayRuleSetRepository {
  DriftHolidayRuleSetRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Result<HolidayRuleSet?>> getForJob(EntityId jobId) {
    return guardResult(() async {
      final row = await (_database.select(
        _database.holidayRuleSetsTable,
      )..where((table) => table.jobId.equals(jobId))).getSingleOrNull();

      return row == null ? null : _mapRow(row);
    });
  }

  @override
  Future<Result<HolidayRuleSet>> save(HolidayRuleSet ruleSet) {
    return guardResult(() async {
      await _database.into(_database.holidayRuleSetsTable).insertOnConflictUpdate(
            HolidayRuleSetsTableCompanion.insert(
              id: ruleSet.id,
              jobId: ruleSet.jobId,
              holidayMultiplierBps: ruleSet.holidayMultiplierBps,
              holidaySource: ruleSet.holidaySource.name,
            ),
          );

      return ruleSet;
    });
  }

  HolidayRuleSet _mapRow(HolidayRuleSetsTableData row) {
    return HolidayRuleSet(
      id: row.id,
      jobId: row.jobId,
      holidayMultiplierBps: row.holidayMultiplierBps,
      holidaySource: HolidaySource.values.byName(row.holidaySource),
    );
  }
}
