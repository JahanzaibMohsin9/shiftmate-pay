import 'package:drift/drift.dart';

import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../core/money/currency_amount.dart';
import '../../domain/entities/job.dart';
import '../../domain/repositories/repositories.dart';
import '../local/database/app_database.dart';
import 'repository_utils.dart';

class DriftJobRepository implements JobRepository {
  DriftJobRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Result<void>> archiveJob(EntityId id) {
    return guardResult(() async {
      await (_database.update(_database.jobsTable)..where((table) => table.id.equals(id))).write(
        JobsTableCompanion(
          isArchived: const Value(true),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
    });
  }

  @override
  Future<Result<Job?>> getJobById(EntityId id) {
    return guardResult(() async {
      final row = await (_database.select(_database.jobsTable)..where((table) => table.id.equals(id))).getSingleOrNull();
      return row == null ? null : _mapJob(row);
    });
  }

  @override
  Future<Result<List<Job>>> listJobs() {
    return guardResult(() async {
      final rows = await (_database.select(_database.jobsTable)
            ..orderBy([(table) => OrderingTerm(expression: table.createdAt)]))
          .get();
      return rows.map(_mapJob).toList(growable: false);
    });
  }

  @override
  Future<Result<Job>> saveJob(Job job) {
    return guardResult(() async {
      await _database.into(_database.jobsTable).insertOnConflictUpdate(
            JobsTableCompanion.insert(
              id: job.id,
              name: job.name,
              colorHex: job.colorHex,
              currencyCode: job.currencyCode,
              hourlyRateMinorUnits: job.hourlyRate.minorUnits,
              payRuleSetId: Value(job.payRuleSetId),
              holidayRuleSetId: Value(job.holidayRuleSetId),
              defaultSleepLeadMinutes: Value(job.defaultSleepLeadMinutes),
              isArchived: Value(job.isArchived),
              createdAt: job.createdAt,
              updatedAt: job.updatedAt,
            ),
          );
      return job;
    });
  }

  Job _mapJob(JobsTableData row) {
    return Job(
      id: row.id,
      name: row.name,
      colorHex: row.colorHex,
      currencyCode: row.currencyCode,
      hourlyRate: CurrencyAmount(
        minorUnits: row.hourlyRateMinorUnits,
        currencyCode: row.currencyCode,
      ),
      payRuleSetId: row.payRuleSetId,
      holidayRuleSetId: row.holidayRuleSetId,
      defaultSleepLeadMinutes: row.defaultSleepLeadMinutes,
      isArchived: row.isArchived,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
