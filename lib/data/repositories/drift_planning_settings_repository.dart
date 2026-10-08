import 'package:drift/drift.dart';

import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../domain/entities/planning_settings.dart';
import '../../domain/repositories/repositories.dart';
import '../local/database/app_database.dart';
import 'repository_utils.dart';

class DriftPlanningSettingsRepository implements PlanningSettingsRepository {
  DriftPlanningSettingsRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Result<PlanningSettings?>> getForJob(EntityId jobId) {
    return guardResult(() async {
      final row = await (_database.select(
        _database.planningSettingsTable,
      )..where((table) => table.jobId.equals(jobId))).getSingleOrNull();
      return row == null ? null : _map(row);
    });
  }

  @override
  Future<Result<PlanningSettings>> save(PlanningSettings settings) {
    return guardResult(() async {
      await _database
          .into(_database.planningSettingsTable)
          .insertOnConflictUpdate(
            PlanningSettingsTableCompanion.insert(
              id: settings.id,
              jobId: settings.jobId,
              planningAlertsEnabled: Value(settings.planningAlertsEnabled),
              minimumRestMinutes: Value(settings.minimumRestMinutes),
              maxConsecutiveWorkDays: Value(settings.maxConsecutiveWorkDays),
              weeklyOvertimeCapMinutes: Value(
                settings.weeklyOvertimeCapMinutes,
              ),
              monthlyOvertimeCapMinutes: Value(
                settings.monthlyOvertimeCapMinutes,
              ),
              createdAt: settings.createdAt,
              updatedAt: settings.updatedAt,
            ),
          );
      return settings;
    });
  }

  PlanningSettings _map(PlanningSettingsTableData row) {
    return PlanningSettings(
      id: row.id,
      jobId: row.jobId,
      planningAlertsEnabled: row.planningAlertsEnabled,
      minimumRestMinutes: row.minimumRestMinutes,
      maxConsecutiveWorkDays: row.maxConsecutiveWorkDays,
      weeklyOvertimeCapMinutes: row.weeklyOvertimeCapMinutes,
      monthlyOvertimeCapMinutes: row.monthlyOvertimeCapMinutes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
