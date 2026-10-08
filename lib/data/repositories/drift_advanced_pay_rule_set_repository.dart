import 'package:drift/drift.dart';

import '../../core/common/result.dart';
import '../../core/common/shared_types.dart';
import '../../domain/entities/advanced_pay_rule_set.dart';
import '../../domain/repositories/repositories.dart';
import '../local/database/app_database.dart';
import 'repository_utils.dart';

class DriftAdvancedPayRuleSetRepository implements AdvancedPayRuleSetRepository {
  DriftAdvancedPayRuleSetRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Result<AdvancedPayRuleSet?>> getForJob(String jobId) {
    return guardResult(() async {
      final header = await (_database.select(
        _database.advancedPayRuleSetsTable,
      )..where((table) => table.jobId.equals(jobId))).getSingleOrNull();
      if (header == null) {
        return null;
      }

      return _loadRuleSet(header);
    });
  }

  @override
  Future<Result<AdvancedPayRuleSet>> save(AdvancedPayRuleSet ruleSet) {
    return guardResult(() async {
      await _database.transaction(() async {
        await _database.into(_database.advancedPayRuleSetsTable).insertOnConflictUpdate(
              AdvancedPayRuleSetsTableCompanion.insert(
                id: ruleSet.id,
                jobId: ruleSet.jobId,
                enabled: Value(ruleSet.enabled),
                version: Value(ruleSet.version),
                createdAt: ruleSet.createdAt,
                updatedAt: ruleSet.updatedAt,
              ),
            );

        await (_database.delete(
          _database.overtimeTierRulesTable,
        )..where((table) => table.advancedPayRuleSetId.equals(ruleSet.id))).go();
        await (_database.delete(
          _database.differentialRulesTable,
        )..where((table) => table.advancedPayRuleSetId.equals(ruleSet.id))).go();
        await (_database.delete(
          _database.allowanceRulesTable,
        )..where((table) => table.advancedPayRuleSetId.equals(ruleSet.id))).go();
        await (_database.delete(
          _database.advancedBreakRulesTable,
        )..where((table) => table.advancedPayRuleSetId.equals(ruleSet.id))).go();

        for (final rule in ruleSet.overtimeRules) {
          await _database.into(_database.overtimeTierRulesTable).insert(
                OvertimeTierRulesTableCompanion.insert(
                  id: rule.id,
                  advancedPayRuleSetId: ruleSet.id,
                  periodType: rule.periodType.name,
                  thresholdMinutes: rule.thresholdMinutes,
                  multiplierBps: rule.multiplierBps,
                  priority: rule.priority,
                  enabled: Value(rule.enabled),
                ),
              );
        }

        for (final rule in ruleSet.differentialRules) {
          await _database.into(_database.differentialRulesTable).insert(
                DifferentialRulesTableCompanion.insert(
                  id: rule.id,
                  advancedPayRuleSetId: ruleSet.id,
                  type: rule.type.name,
                  combinationMode: rule.combinationMode.name,
                  multiplierBps: Value(rule.multiplierBps),
                  flatAmountMinor: Value(rule.flatAmountMinor),
                  startMinutesLocal: Value(rule.startMinutesLocal),
                  endMinutesLocal: Value(rule.endMinutesLocal),
                  appliesOnSaturday: Value(rule.appliesOnSaturday),
                  appliesOnSunday: Value(rule.appliesOnSunday),
                  shiftTemplateId: Value(rule.shiftTemplateId),
                  enabled: Value(rule.enabled),
                ),
              );
        }

        for (final rule in ruleSet.allowanceRules) {
          await _database.into(_database.allowanceRulesTable).insert(
                AllowanceRulesTableCompanion.insert(
                  id: rule.id,
                  advancedPayRuleSetId: ruleSet.id,
                  type: rule.type.name,
                  amountMinor: rule.amountMinor,
                  appliesOnHoliday: Value(rule.appliesOnHoliday),
                  shiftTemplateId: Value(rule.shiftTemplateId),
                  enabled: Value(rule.enabled),
                ),
              );
        }

        for (final rule in ruleSet.breakRules) {
          await _database.into(_database.advancedBreakRulesTable).insert(
                AdvancedBreakRulesTableCompanion.insert(
                  id: rule.id,
                  advancedPayRuleSetId: ruleSet.id,
                  minutes: rule.minutes,
                  shiftTemplateId: Value(rule.shiftTemplateId),
                  shiftCategory: Value(rule.shiftCategory?.name),
                  enabled: Value(rule.enabled),
                ),
              );
        }
      });

      return ruleSet;
    });
  }

  Future<AdvancedPayRuleSet> _loadRuleSet(AdvancedPayRuleSetsTableData header) async {
    final overtimeRows = await (_database.select(
      _database.overtimeTierRulesTable,
    )..where((table) => table.advancedPayRuleSetId.equals(header.id))
      ..orderBy([(table) => OrderingTerm.asc(table.priority)])).get();
    final differentialRows = await (_database.select(
      _database.differentialRulesTable,
    )..where((table) => table.advancedPayRuleSetId.equals(header.id))).get();
    final allowanceRows = await (_database.select(
      _database.allowanceRulesTable,
    )..where((table) => table.advancedPayRuleSetId.equals(header.id))).get();
    final breakRows = await (_database.select(
      _database.advancedBreakRulesTable,
    )..where((table) => table.advancedPayRuleSetId.equals(header.id))).get();

    return AdvancedPayRuleSet(
      id: header.id,
      jobId: header.jobId,
      enabled: header.enabled,
      overtimeRules: overtimeRows
          .map(
            (row) => OvertimeTierRule(
              id: row.id,
              periodType: OvertimePeriodType.values.byName(row.periodType),
              thresholdMinutes: row.thresholdMinutes,
              multiplierBps: row.multiplierBps,
              priority: row.priority,
              enabled: row.enabled,
            ),
          )
          .toList(growable: false),
      differentialRules: differentialRows
          .map(
            (row) => DifferentialPayRule(
              id: row.id,
              type: DifferentialRuleType.values.byName(row.type),
              combinationMode: DifferentialCombinationMode.values.byName(
                row.combinationMode,
              ),
              enabled: row.enabled,
              multiplierBps: row.multiplierBps,
              flatAmountMinor: row.flatAmountMinor,
              startMinutesLocal: row.startMinutesLocal,
              endMinutesLocal: row.endMinutesLocal,
              appliesOnSaturday: row.appliesOnSaturday,
              appliesOnSunday: row.appliesOnSunday,
              shiftTemplateId: row.shiftTemplateId,
            ),
          )
          .toList(growable: false),
      allowanceRules: allowanceRows
          .map(
            (row) => AllowancePayRule(
              id: row.id,
              type: AllowanceRuleType.values.byName(row.type),
              amountMinor: row.amountMinor,
              enabled: row.enabled,
              appliesOnHoliday: row.appliesOnHoliday,
              shiftTemplateId: row.shiftTemplateId,
            ),
          )
          .toList(growable: false),
      breakRules: breakRows
          .map(
            (row) => AdvancedBreakRule(
              id: row.id,
              minutes: row.minutes,
              enabled: row.enabled,
              shiftTemplateId: row.shiftTemplateId,
              shiftCategory: row.shiftCategory == null
                  ? null
                  : ShiftCategory.values.byName(row.shiftCategory!),
            ),
          )
          .toList(growable: false),
      version: header.version,
      createdAt: header.createdAt,
      updatedAt: header.updatedAt,
    );
  }
}
