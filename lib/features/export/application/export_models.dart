import 'package:intl/intl.dart';

import '../../../core/common/shared_types.dart';
import '../../../domain/entities/shift_instance.dart';
import '../../../domain/usecases/usecases.dart';

class ScheduleExportDocument {
  const ScheduleExportDocument({
    required this.jobName,
    required this.rangeLabel,
    required this.currencyCode,
    required this.totalShifts,
    required this.totalWorkedMinutes,
    required this.holidayShifts,
    required this.grossPayMinor,
    required this.shiftRows,
  });

  final String jobName;
  final String rangeLabel;
  final String currencyCode;
  final int totalShifts;
  final Minutes totalWorkedMinutes;
  final int holidayShifts;
  final int grossPayMinor;
  final List<ScheduleExportShiftRow> shiftRows;
}

class ScheduleExportShiftRow {
  const ScheduleExportShiftRow({
    required this.dateLabel,
    required this.timeLabel,
    required this.shiftLabel,
    required this.note,
    required this.isHoliday,
    required this.isOffDay,
  });

  final String dateLabel;
  final String timeLabel;
  final String shiftLabel;
  final String? note;
  final bool isHoliday;
  final bool isOffDay;
}

ScheduleExportDocument buildScheduleExportDocument({
  required ScheduleExportBundle bundle,
  required PayPeriodSummary summary,
}) {
  final rows = bundle.instances
      .map(
        (instance) => ScheduleExportShiftRow(
          dateLabel: DateFormat('EEE, d MMM yyyy').format(instance.date),
          timeLabel: _buildTimeLabel(instance),
          shiftLabel: _buildShiftLabel(instance),
          note: instance.note?.trim().isEmpty ?? true
              ? null
              : instance.note?.trim(),
          isHoliday: instance.isHoliday,
          isOffDay: instance.overrideType == ShiftOverrideType.markOffDay,
        ),
      )
      .toList(growable: false);

  return ScheduleExportDocument(
    jobName: bundle.job.name,
    rangeLabel: summary.periodLabel,
    currencyCode: summary.currencyCode,
    totalShifts: summary.totalShifts,
    totalWorkedMinutes: summary.totalWorkedMinutes,
    holidayShifts: summary.holidayShifts,
    grossPayMinor: summary.grossPay,
    shiftRows: rows,
  );
}

String _buildShiftLabel(ShiftInstance instance) {
  if (instance.overrideType == ShiftOverrideType.markOffDay) {
    return 'Off day';
  }

  return instance.templateSnapshot?.name ?? 'Manual shift';
}

String _buildTimeLabel(ShiftInstance instance) {
  if (instance.overrideType == ShiftOverrideType.markOffDay) {
    return 'Marked off';
  }

  final format = DateFormat('h:mm a');
  return '${format.format(instance.startDateTime)} - ${format.format(instance.endDateTime)}';
}
