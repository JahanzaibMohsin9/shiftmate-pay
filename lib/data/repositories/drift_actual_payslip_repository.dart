import 'package:drift/drift.dart';

import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../domain/entities/actual_payslip.dart';
import '../../domain/repositories/repositories.dart';
import '../local/database/app_database.dart';
import 'repository_utils.dart';

class DriftActualPayslipRepository implements ActualPayslipRepository {
  DriftActualPayslipRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Result<void>> delete(EntityId id) {
    return guardResult(() async {
      await (_database.delete(
        _database.actualPayslipsTable,
      )..where((table) => table.id.equals(id))).go();
    });
  }

  @override
  Future<Result<ActualPayslip?>> getById(EntityId id) {
    return guardResult(() async {
      final row = await (_database.select(
        _database.actualPayslipsTable,
      )..where((table) => table.id.equals(id))).getSingleOrNull();
      return row == null ? null : _mapPayslip(row);
    });
  }

  @override
  Future<Result<ActualPayslip?>> getForJobAndPeriod({
    required EntityId jobId,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) {
    return guardResult(() async {
      final row =
          await (_database.select(_database.actualPayslipsTable)..where(
                (table) =>
                    table.jobId.equals(jobId) &
                    table.periodStart.equals(periodStart) &
                    table.periodEnd.equals(periodEnd),
              ))
              .getSingleOrNull();
      return row == null ? null : _mapPayslip(row);
    });
  }

  @override
  Future<Result<List<ActualPayslip>>> listForJob(EntityId jobId) {
    return guardResult(() async {
      final rows =
          await (_database.select(_database.actualPayslipsTable)
                ..where((table) => table.jobId.equals(jobId))
                ..orderBy([
                  (table) => OrderingTerm.desc(table.periodStart),
                  (table) => OrderingTerm.desc(table.createdAt),
                ]))
              .get();
      return rows.map(_mapPayslip).toList(growable: false);
    });
  }

  @override
  Future<Result<ActualPayslip>> save(ActualPayslip payslip) {
    return guardResult(() async {
      await _database
          .into(_database.actualPayslipsTable)
          .insertOnConflictUpdate(
            ActualPayslipsTableCompanion.insert(
              id: payslip.id,
              jobId: payslip.jobId,
              periodStart: payslip.periodStart,
              periodEnd: payslip.periodEnd,
              paidAt: Value(payslip.paidAt),
              grossPayMinor: payslip.grossPayMinor,
              workedMinutesReported: Value(payslip.workedMinutesReported),
              overtimePayMinor: Value(payslip.overtimePayMinor),
              holidayPayMinor: Value(payslip.holidayPayMinor),
              allowancesMinor: Value(payslip.allowancesMinor),
              notes: Value(payslip.notes),
              source: Value(payslip.source.name),
              createdAt: payslip.createdAt,
              updatedAt: payslip.updatedAt,
            ),
          );
      return payslip;
    });
  }

  ActualPayslip _mapPayslip(ActualPayslipsTableData row) {
    return ActualPayslip(
      id: row.id,
      jobId: row.jobId,
      periodStart: row.periodStart,
      periodEnd: row.periodEnd,
      paidAt: row.paidAt,
      grossPayMinor: row.grossPayMinor,
      workedMinutesReported: row.workedMinutesReported,
      overtimePayMinor: row.overtimePayMinor,
      holidayPayMinor: row.holidayPayMinor,
      allowancesMinor: row.allowancesMinor,
      notes: row.notes,
      source: ActualPayslipSource.values.byName(row.source),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
