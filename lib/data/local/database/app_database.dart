import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class JobsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get colorHex => text().withLength(min: 7, max: 7)();
  TextColumn get currencyCode => text().withLength(min: 3, max: 3)();
  IntColumn get hourlyRateMinorUnits => integer()();
  TextColumn get payRuleSetId => text().nullable()();
  TextColumn get holidayRuleSetId => text().nullable()();
  IntColumn get defaultSleepLeadMinutes => integer().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PayRuleSetsTable extends Table {
  TextColumn get id => text()();
  TextColumn get jobId => text().references(JobsTable, #id)();
  IntColumn get overtimeThresholdDailyMinutes => integer().nullable()();
  IntColumn get overtimeThresholdWeeklyMinutes => integer().nullable()();
  IntColumn get overtimeMultiplierBps => integer()();
  IntColumn get doubleTimeThresholdMinutes => integer().nullable()();
  IntColumn get doubleTimeMultiplierBps => integer().nullable()();
  TextColumn get roundRule => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AdvancedPayRuleSetsTable extends Table {
  TextColumn get id => text()();
  TextColumn get jobId => text().references(JobsTable, #id)();
  BoolColumn get enabled => boolean().withDefault(const Constant(false))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class OvertimeTierRulesTable extends Table {
  TextColumn get id => text()();
  TextColumn get advancedPayRuleSetId =>
      text().references(AdvancedPayRuleSetsTable, #id)();
  TextColumn get periodType => text()();
  IntColumn get thresholdMinutes => integer()();
  IntColumn get multiplierBps => integer()();
  IntColumn get priority => integer()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class DifferentialRulesTable extends Table {
  TextColumn get id => text()();
  TextColumn get advancedPayRuleSetId =>
      text().references(AdvancedPayRuleSetsTable, #id)();
  TextColumn get type => text()();
  TextColumn get combinationMode => text()();
  IntColumn get multiplierBps => integer().nullable()();
  IntColumn get flatAmountMinor => integer().nullable()();
  IntColumn get startMinutesLocal => integer().nullable()();
  IntColumn get endMinutesLocal => integer().nullable()();
  BoolColumn get appliesOnSaturday =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get appliesOnSunday =>
      boolean().withDefault(const Constant(false))();
  TextColumn get shiftTemplateId =>
      text().nullable().references(ShiftTemplatesTable, #id)();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AllowanceRulesTable extends Table {
  TextColumn get id => text()();
  TextColumn get advancedPayRuleSetId =>
      text().references(AdvancedPayRuleSetsTable, #id)();
  TextColumn get type => text()();
  IntColumn get amountMinor => integer()();
  BoolColumn get appliesOnHoliday =>
      boolean().withDefault(const Constant(false))();
  TextColumn get shiftTemplateId =>
      text().nullable().references(ShiftTemplatesTable, #id)();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AdvancedBreakRulesTable extends Table {
  TextColumn get id => text()();
  TextColumn get advancedPayRuleSetId =>
      text().references(AdvancedPayRuleSetsTable, #id)();
  IntColumn get minutes => integer()();
  TextColumn get shiftTemplateId =>
      text().nullable().references(ShiftTemplatesTable, #id)();
  TextColumn get shiftCategory => text().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class HolidayRuleSetsTable extends Table {
  TextColumn get id => text()();
  TextColumn get jobId => text().references(JobsTable, #id)();
  IntColumn get holidayMultiplierBps => integer()();
  TextColumn get holidaySource => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ShiftTemplatesTable extends Table {
  TextColumn get id => text()();
  TextColumn get jobId => text().references(JobsTable, #id)();
  TextColumn get name => text()();
  IntColumn get startMinutesLocal => integer()();
  IntColumn get endMinutesLocal => integer()();
  IntColumn get unpaidBreakMinutes => integer()();
  TextColumn get category => text()();
  TextColumn get defaultNote => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ShiftPatternsTable extends Table {
  TextColumn get id => text()();
  TextColumn get jobId => text().references(JobsTable, #id)();
  TextColumn get name => text()();
  IntColumn get cycleLengthDays => integer()();
  DateTimeColumn get startDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ShiftPatternEntriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get patternId => text().references(ShiftPatternsTable, #id)();
  IntColumn get dayIndex => integer()();
  TextColumn get shiftTemplateId =>
      text().nullable().references(ShiftTemplatesTable, #id)();
  BoolColumn get isOffDay => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ShiftInstancesTable extends Table {
  TextColumn get id => text()();
  TextColumn get jobId => text().references(JobsTable, #id)();
  TextColumn get shiftTemplateId =>
      text().nullable().references(ShiftTemplatesTable, #id)();
  DateTimeColumn get startDateTime => dateTime()();
  DateTimeColumn get endDateTime => dateTime()();
  IntColumn get unpaidBreakMinutes => integer()();
  TextColumn get source => text()();
  TextColumn get overrideType => text().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get isOffDay => boolean().withDefault(const Constant(false))();
  BoolColumn get isHoliday => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ReminderRulesTable extends Table {
  TextColumn get id => text()();
  TextColumn get jobId => text().references(JobsTable, #id)();
  TextColumn get type => text()();
  IntColumn get leadMinutes => integer()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PlanningSettingsTable extends Table {
  TextColumn get id => text()();
  TextColumn get jobId => text().references(JobsTable, #id).unique()();
  BoolColumn get planningAlertsEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get minimumRestMinutes => integer().nullable()();
  IntColumn get maxConsecutiveWorkDays => integer().nullable()();
  IntColumn get weeklyOvertimeCapMinutes => integer().nullable()();
  IntColumn get monthlyOvertimeCapMinutes => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AvailabilityRulesTable extends Table {
  TextColumn get id => text()();
  TextColumn get jobId => text().references(JobsTable, #id)();
  TextColumn get type => text()();
  TextColumn get state => text()();
  DateTimeColumn get startDateTime => dateTime().nullable()();
  DateTimeColumn get endDateTime => dateTime().nullable()();
  IntColumn get weekday => integer().nullable()();
  IntColumn get startMinuteOfDay => integer().nullable()();
  IntColumn get endMinuteOfDay => integer().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ActualPayslipsTable extends Table {
  TextColumn get id => text()();
  TextColumn get jobId => text().references(JobsTable, #id)();
  DateTimeColumn get periodStart => dateTime()();
  DateTimeColumn get periodEnd => dateTime()();
  DateTimeColumn get paidAt => dateTime().nullable()();
  IntColumn get grossPayMinor => integer()();
  IntColumn get workedMinutesReported => integer().nullable()();
  IntColumn get overtimePayMinor => integer().nullable()();
  IntColumn get holidayPayMinor => integer().nullable()();
  IntColumn get allowancesMinor => integer().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    JobsTable,
    PayRuleSetsTable,
    AdvancedPayRuleSetsTable,
    OvertimeTierRulesTable,
    DifferentialRulesTable,
    AllowanceRulesTable,
    AdvancedBreakRulesTable,
    HolidayRuleSetsTable,
    ShiftTemplatesTable,
    ShiftPatternsTable,
    ShiftPatternEntriesTable,
    ShiftInstancesTable,
    ReminderRulesTable,
    PlanningSettingsTable,
    AvailabilityRulesTable,
    ActualPayslipsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor}) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      for (var version = from; version < to; version++) {
        switch (version + 1) {
          case 1:
            await migrator.createAll();
            break;
          case 2:
            await migrator.createTable(advancedPayRuleSetsTable);
            await migrator.createTable(overtimeTierRulesTable);
            await migrator.createTable(differentialRulesTable);
            await migrator.createTable(allowanceRulesTable);
            await migrator.createTable(advancedBreakRulesTable);
            await migrator.createTable(actualPayslipsTable);
            break;
          case 3:
            await migrator.createTable(planningSettingsTable);
            await migrator.createTable(availabilityRulesTable);
            break;
        }
      }
    },
    beforeOpen: (_) async {},
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web is not supported by the local Drift database yet.',
      );
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'shiftmate_pay.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
