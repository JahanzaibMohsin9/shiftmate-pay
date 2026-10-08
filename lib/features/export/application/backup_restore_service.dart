import 'dart:convert';
import 'dart:io';


import 'package:file_picker/file_picker.dart';

import '../../../data/local/database/app_database.dart';

enum RestoreResult {
  success,
  cancelled,
  invalidFile,
  missingSnapshot,
  importFailed,
}

class RestoreReport {
  const RestoreReport({
    required this.result,
    this.message,
    this.tablesRestored,
  });

  final RestoreResult result;
  final String? message;
  final int? tablesRestored;

  bool get isSuccess => result == RestoreResult.success;
}

const _requiredTables = {
  'jobs',
  'payRuleSets',
  'holidayRuleSets',
  'shiftTemplates',
  'shiftPatterns',
  'shiftPatternEntries',
  'shiftInstances',
  'reminderRules',
};

/// Maps backup JSON keys → actual Drift table names in the SQLite database.
const _tableNames = {
  'jobs': 'jobs_table',
  'payRuleSets': 'pay_rule_sets_table',
  'holidayRuleSets': 'holiday_rule_sets_table',
  'shiftTemplates': 'shift_templates_table',
  'shiftPatterns': 'shift_patterns_table',
  'shiftPatternEntries': 'shift_pattern_entries_table',
  'shiftInstances': 'shift_instances_table',
  'reminderRules': 'reminder_rules_table',
};

/// Dependency-free deletion order (children before parents).
const _deletionOrder = [
  'shift_instances_table',
  'shift_pattern_entries_table',
  'shift_patterns_table',
  'shift_templates_table',
  'reminder_rules_table',
  'holiday_rule_sets_table',
  'pay_rule_sets_table',
  'jobs_table',
];

/// Insertion order (parents before children).
const _insertionOrderKeys = [
  'jobs',
  'payRuleSets',
  'holidayRuleSets',
  'shiftTemplates',
  'shiftPatterns',
  'shiftPatternEntries',
  'shiftInstances',
  'reminderRules',
];

class BackupRestoreService {
  const BackupRestoreService({required AppDatabase database})
    : _database = database;

  final AppDatabase _database;

  /// Picks a JSON backup file, validates it, then replaces all local data.
  Future<RestoreReport> restoreFromFilePicker() async {
    // 1. Pick the file.
    final pickResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      dialogTitle: 'Select ShiftMate Pay backup file',
    );

    if (pickResult == null || pickResult.files.isEmpty) {
      return const RestoreReport(result: RestoreResult.cancelled);
    }

    final path = pickResult.files.single.path;
    if (path == null) {
      return const RestoreReport(
        result: RestoreResult.invalidFile,
        message: 'Could not access the selected file path.',
      );
    }

    // 2. Read and parse.
    final String raw;
    try {
      raw = await File(path).readAsString();
    } catch (e) {
      return RestoreReport(
        result: RestoreResult.invalidFile,
        message: 'Unable to read file: $e',
      );
    }

    final Map<String, dynamic> parsed;
    try {
      parsed = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return const RestoreReport(
        result: RestoreResult.invalidFile,
        message: 'The selected file is not valid JSON.',
      );
    }

    // 3. Validate structure.
    final snapshot = parsed['databaseSnapshot'];
    if (snapshot == null || snapshot is! Map<String, dynamic>) {
      return const RestoreReport(
        result: RestoreResult.missingSnapshot,
        message:
            'This file does not contain a database snapshot. '
            'Select a JSON backup created by ShiftMate Pay.',
      );
    }

    final missing = _requiredTables.difference(snapshot.keys.toSet());
    if (missing.isNotEmpty) {
      return RestoreReport(
        result: RestoreResult.missingSnapshot,
        message: 'Backup is missing required data: ${missing.join(', ')}.',
      );
    }

    // 4. Replace-all restore inside a transaction.
    try {
      await _database.transaction(() async {
        // Delete in child-first order.
        for (final tableName in _deletionOrder) {
          await _database.customStatement('DELETE FROM $tableName');
        }

        // Insert in parent-first order.
        for (final key in _insertionOrderKeys) {
          final rows = _rowsOf(snapshot, key);
          final tableName = _tableNames[key]!;
          for (final row in rows) {
            final colNames = row.keys.join(', ');
            final valueLiterals = row.values.map(_toSqlLiteral).join(', ');
            await _database.customStatement(
              'INSERT OR REPLACE INTO $tableName ($colNames) VALUES ($valueLiterals)',
            );
          }
        }
      });
    } catch (e) {
      return RestoreReport(
        result: RestoreResult.importFailed,
        message: 'Import failed: $e',
      );
    }

    return const RestoreReport(
      result: RestoreResult.success,
      message: 'All data restored successfully from backup.',
      tablesRestored: 8,
    );
  }

  static List<Map<String, dynamic>> _rowsOf(
    Map<String, dynamic> snapshot,
    String key,
  ) {
    final raw = snapshot[key];
    if (raw is! List) return const [];
    return raw.cast<Map<String, dynamic>>();
  }

  /// Converts a JSON-decoded value to a safe SQLite literal string.
  ///
  /// - `null` → `NULL`
  /// - `bool` → `0` / `1`
  /// - `int` / `double` → numeric literal
  /// - everything else → single-quoted, with internal single-quotes escaped.
  static String _toSqlLiteral(dynamic value) {
    if (value == null) return 'NULL';
    if (value is bool) return value ? '1' : '0';
    if (value is int || value is double) return '$value';
    final escaped = value.toString().replaceAll("'", "''");
    return "'$escaped'";
  }
}
