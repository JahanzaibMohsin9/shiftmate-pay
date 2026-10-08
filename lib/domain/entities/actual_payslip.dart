import '../../core/common/identifiers.dart';
import '../../core/common/shared_types.dart';

enum ActualPayslipSource { manual }

class ActualPayslip {
  const ActualPayslip({
    required this.id,
    required this.jobId,
    required this.periodStart,
    required this.periodEnd,
    required this.paidAt,
    required this.grossPayMinor,
    required this.workedMinutesReported,
    required this.overtimePayMinor,
    required this.holidayPayMinor,
    required this.allowancesMinor,
    required this.notes,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });

  final EntityId id;
  final EntityId jobId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime? paidAt;
  final MinorUnits grossPayMinor;
  final Minutes? workedMinutesReported;
  final MinorUnits? overtimePayMinor;
  final MinorUnits? holidayPayMinor;
  final MinorUnits? allowancesMinor;
  final String? notes;
  final ActualPayslipSource source;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActualPayslip copyWith({
    EntityId? id,
    EntityId? jobId,
    DateTime? periodStart,
    DateTime? periodEnd,
    DateTime? paidAt,
    bool setPaidAt = false,
    MinorUnits? grossPayMinor,
    Minutes? workedMinutesReported,
    bool setWorkedMinutesReported = false,
    MinorUnits? overtimePayMinor,
    bool setOvertimePayMinor = false,
    MinorUnits? holidayPayMinor,
    bool setHolidayPayMinor = false,
    MinorUnits? allowancesMinor,
    bool setAllowancesMinor = false,
    String? notes,
    bool setNotes = false,
    ActualPayslipSource? source,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActualPayslip(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      paidAt: setPaidAt ? paidAt : paidAt ?? this.paidAt,
      grossPayMinor: grossPayMinor ?? this.grossPayMinor,
      workedMinutesReported: setWorkedMinutesReported
          ? workedMinutesReported
          : workedMinutesReported ?? this.workedMinutesReported,
      overtimePayMinor: setOvertimePayMinor
          ? overtimePayMinor
          : overtimePayMinor ?? this.overtimePayMinor,
      holidayPayMinor: setHolidayPayMinor
          ? holidayPayMinor
          : holidayPayMinor ?? this.holidayPayMinor,
      allowancesMinor: setAllowancesMinor
          ? allowancesMinor
          : allowancesMinor ?? this.allowancesMinor,
      notes: setNotes ? notes : notes ?? this.notes,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
