import 'package:drift/drift.dart';

import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../core/common/shared_types.dart';
import '../../domain/entities/pay_rule_set.dart';
import '../../domain/repositories/repositories.dart';
import '../local/database/app_database.dart';
import 'repository_utils.dart';

class DriftPayRuleSetRepository implements PayRuleSetRepository {
  DriftPayRuleSetRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Result<PayRuleSet?>> getForJob(EntityId jobId) {
    return guardResult(() async {
      final row = await (_database.select(
        _database.payRuleSetsTable,
      )..where((table) => table.jobId.equals(jobId))).getSingleOrNull();

      return row == null ? null : _mapRow(row);
    });
  }

  @override
  Future<Result<PayRuleSet>> save(PayRuleSet ruleSet) {
    return guardResult(() async {
      await _database.into(_database.payRuleSetsTable).insertOnConflictUpdate(
            PayRuleSetsTableCompanion.insert(
              id: ruleSet.id,
              jobId: ruleSet.jobId,
              overtimeThresholdDailyMinutes: Value(
                ruleSet.overtimeThresholdDailyMinutes,
              ),
              overtimeThresholdWeeklyMinutes: Value(
                ruleSet.overtimeThresholdWeeklyMinutes,
              ),
              overtimeMultiplierBps: ruleSet.overtimeMultiplierBps,
              doubleTimeThresholdMinutes: Value(ruleSet.doubleTimeThresholdMinutes),
              doubleTimeMultiplierBps: Value(ruleSet.doubleTimeMultiplierBps),
              roundRule: ruleSet.roundRule.name,
            ),
          );

      return ruleSet;
    });
  }

  PayRuleSet _mapRow(PayRuleSetsTableData row) {
    return PayRuleSet(
      id: row.id,
      jobId: row.jobId,
      overtimeThresholdDailyMinutes: row.overtimeThresholdDailyMinutes,
      overtimeThresholdWeeklyMinutes: row.overtimeThresholdWeeklyMinutes,
      overtimeMultiplierBps: row.overtimeMultiplierBps,
      doubleTimeThresholdMinutes: row.doubleTimeThresholdMinutes,
      doubleTimeMultiplierBps: row.doubleTimeMultiplierBps,
      roundRule: RoundRule.values.byName(row.roundRule),
    );
  }
}
