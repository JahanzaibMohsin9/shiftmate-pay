import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/common/identifiers.dart';
import '../../../data/local/database/app_database.dart';
import '../../../data/local/preferences/app_preferences.dart';
import '../../../domain/services/calendar_ics_builder.dart';
import '../../../domain/usecases/usecases.dart';
import 'export_models.dart';

class ExportArtifact {
  const ExportArtifact({required this.fileName, required this.filePath});

  final String fileName;
  final String filePath;
}

class ExportFileService {
  ExportFileService({
    required AppDatabase database,
    required AppPreferences preferences,
    CalendarIcsBuilder? calendarIcsBuilder,
  }) : _database = database,
       _preferences = preferences,
       _calendarIcsBuilder = calendarIcsBuilder ?? CalendarIcsBuilder();

  final AppDatabase _database;
  final AppPreferences _preferences;
  final CalendarIcsBuilder _calendarIcsBuilder;

  List<ExportHistoryEntry> loadHistory() => _preferences.exportHistory;

  Future<ExportArtifact> writeSchedulePdf({
    required ScheduleExportDocument document,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
        ),
        build: (context) => [
          pw.Text(
            document.jobName,
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text('Schedule export · ${document.rangeLabel}'),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _summaryCell(
                  'Worked time',
                  _formatMinutes(document.totalWorkedMinutes),
                ),
                _summaryCell('Shifts', '${document.totalShifts}'),
                _summaryCell('Holidays', '${document.holidayShifts}'),
                _summaryCell(
                  'Projected pay',
                  _formatMoney(document.grossPayMinor, document.currencyCode),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignment: pw.Alignment.centerLeft,
            columnWidths: {
              0: const pw.FlexColumnWidth(2.1),
              1: const pw.FlexColumnWidth(1.8),
              2: const pw.FlexColumnWidth(2.0),
              3: const pw.FlexColumnWidth(3.2),
              4: const pw.FlexColumnWidth(1.2),
            },
            headers: const ['Date', 'Time', 'Shift', 'Notes', 'Flags'],
            data: document.shiftRows
                .map(
                  (row) => [
                    row.dateLabel,
                    row.timeLabel,
                    row.shiftLabel,
                    row.note ?? '—',
                    [
                          if (row.isHoliday) 'Holiday',
                          if (row.isOffDay) 'Off',
                        ].join(', ').isEmpty
                        ? '—'
                        : [
                            if (row.isHoliday) 'Holiday',
                            if (row.isOffDay) 'Off',
                          ].join(', '),
                  ],
                )
                .toList(growable: false),
          ),
        ],
      ),
    );

    final bytes = await pdf.save();
    return _writeArtifact(
      type: 'pdf',
      fileName: _buildFileName(document.jobName, 'schedule', 'pdf'),
      bytes: bytes,
    );
  }

  Future<ExportArtifact> writeJsonBackup({
    required ScheduleExportBundle bundle,
    required PayPeriodSummary summary,
  }) async {
    final payload = {
      'generatedAt': DateTime.now().toIso8601String(),
      'job': {
        'id': bundle.job.id,
        'name': bundle.job.name,
        'colorHex': bundle.job.colorHex,
        'currencyCode': bundle.job.currencyCode,
        'hourlyRateMinorUnits': bundle.job.hourlyRate.minorUnits,
      },
      'range': {
        'start': bundle.range.start.toIso8601String(),
        'end': bundle.range.end.toIso8601String(),
      },
      'paySummary': {
        'periodLabel': summary.periodLabel,
        'totalWorkedMinutes': summary.totalWorkedMinutes,
        'totalShifts': summary.totalShifts,
        'holidayShifts': summary.holidayShifts,
        'basePay': summary.basePay,
        'overtimePay': summary.overtimePay,
        'doubleTimePay': summary.doubleTimePay,
        'holidayPay': summary.holidayPay,
        'grossPay': summary.grossPay,
        'currencyCode': summary.currencyCode,
      },
      'schedule': bundle.instances
          .map(
            (instance) => {
              'id': instance.id,
              'date': instance.date.toIso8601String(),
              'startDateTime': instance.startDateTime.toIso8601String(),
              'endDateTime': instance.endDateTime.toIso8601String(),
              'unpaidBreakMinutes': instance.unpaidBreakMinutes,
              'source': instance.source.name,
              'overrideType': instance.overrideType?.name,
              'note': instance.note,
              'isHoliday': instance.isHoliday,
              'templateSnapshot': instance.templateSnapshot == null
                  ? null
                  : {
                      'templateId': instance.templateSnapshot!.templateId,
                      'name': instance.templateSnapshot!.name,
                      'category': instance.templateSnapshot!.category.name,
                      'startMinutesLocal':
                          instance.templateSnapshot!.startMinutesLocal,
                      'endMinutesLocal':
                          instance.templateSnapshot!.endMinutesLocal,
                      'unpaidBreakMinutes':
                          instance.templateSnapshot!.unpaidBreakMinutes,
                      'defaultNote': instance.templateSnapshot!.defaultNote,
                    },
            },
          )
          .toList(growable: false),
      'databaseSnapshot': await _readDatabaseSnapshot(),
    };

    final bytes = Uint8List.fromList(
      const JsonEncoder.withIndent('  ').convert(payload).codeUnits,
    );
    return _writeArtifact(
      type: 'backup',
      fileName: _buildFileName(bundle.job.name, 'backup', 'json'),
      bytes: bytes,
    );
  }

  Future<ExportArtifact> writeCalendarIcs({
    required ScheduleExportBundle bundle,
  }) async {
    final document = _calendarIcsBuilder.build(
      job: bundle.job,
      range: bundle.range,
      instances: bundle.instances,
    );
    final fileName = _buildCalendarFileName(
      bundle.job.name,
      bundle.range.start,
      bundle.range.end,
    );

    final bytes = Uint8List.fromList(document.content.codeUnits);
    return _writeArtifact(
      type: 'calendar_ics',
      fileName: fileName,
      bytes: bytes,
    );
  }

  Future<Map<String, Object?>> _readDatabaseSnapshot() async {
    final jobs = await _database.select(_database.jobsTable).get();
    final payRules = await _database.select(_database.payRuleSetsTable).get();
    final holidayRules = await _database
        .select(_database.holidayRuleSetsTable)
        .get();
    final templates = await _database
        .select(_database.shiftTemplatesTable)
        .get();
    final patterns = await _database.select(_database.shiftPatternsTable).get();
    final patternEntries = await _database
        .select(_database.shiftPatternEntriesTable)
        .get();
    final shiftInstances = await _database
        .select(_database.shiftInstancesTable)
        .get();
    final reminderRules = await _database
        .select(_database.reminderRulesTable)
        .get();

    return {
      'jobs': jobs.map((row) => row.toJson()).toList(growable: false),
      'payRuleSets': payRules
          .map((row) => row.toJson())
          .toList(growable: false),
      'holidayRuleSets': holidayRules
          .map((row) => row.toJson())
          .toList(growable: false),
      'shiftTemplates': templates
          .map((row) => row.toJson())
          .toList(growable: false),
      'shiftPatterns': patterns
          .map((row) => row.toJson())
          .toList(growable: false),
      'shiftPatternEntries': patternEntries
          .map((row) => row.toJson())
          .toList(growable: false),
      'shiftInstances': shiftInstances
          .map((row) => row.toJson())
          .toList(growable: false),
      'reminderRules': reminderRules
          .map((row) => row.toJson())
          .toList(growable: false),
    };
  }

  Future<ExportArtifact> _writeArtifact({
    required String type,
    required String fileName,
    required Uint8List bytes,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final exportDirectory = Directory(p.join(directory.path, 'exports'));
    if (!exportDirectory.existsSync()) {
      await exportDirectory.create(recursive: true);
    }

    final filePath = p.join(exportDirectory.path, fileName);
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    await _preferences.addExportHistoryEntry(
      ExportHistoryEntry(
        id: AppId.generate(),
        type: type,
        fileName: fileName,
        filePath: filePath,
        createdAt: DateTime.now(),
      ),
    );

    return ExportArtifact(fileName: fileName, filePath: filePath);
  }

  String _buildFileName(String jobName, String suffix, String extension) {
    final slug = jobName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return '${slug.isEmpty ? 'shiftmate' : slug}_${suffix}_$timestamp.$extension';
  }

  String _buildCalendarFileName(String jobName, DateTime start, DateTime end) {
    final slug = jobName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final startLabel = DateFormat('yyyyMMdd').format(start);
    final endLabel = DateFormat('yyyyMMdd').format(end);
    return '${slug.isEmpty ? 'shiftmate' : slug}_calendar_${startLabel}_$endLabel.ics';
  }

  static pw.Widget _summaryCell(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 4),
        pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static String _formatMinutes(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours == 0) {
      return '${minutes}m';
    }
    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${minutes}m';
  }

  static String _formatMoney(int minorUnits, String currencyCode) {
    final amount = (minorUnits / 100).toStringAsFixed(2);
    return '$currencyCode $amount';
  }
}
