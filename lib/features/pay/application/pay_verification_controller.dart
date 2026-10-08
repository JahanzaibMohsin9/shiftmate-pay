import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/identifiers.dart';
import '../../../data/local/database/database_providers.dart';
import '../../../domain/entities/actual_payslip.dart';
import 'pay_verification_providers.dart';

class PayVerificationControllerState {
  const PayVerificationControllerState({
    this.isSaving = false,
    this.isDeleting = false,
    this.errorMessage,
    this.completedAt,
  });

  final bool isSaving;
  final bool isDeleting;
  final String? errorMessage;
  final DateTime? completedAt;

  PayVerificationControllerState copyWith({
    bool? isSaving,
    bool? isDeleting,
    String? errorMessage,
    bool clearError = false,
    DateTime? completedAt,
  }) {
    return PayVerificationControllerState(
      isSaving: isSaving ?? this.isSaving,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class PayVerificationDraft {
  const PayVerificationDraft({
    required this.grossPayMinor,
    this.paidAt,
    this.workedMinutesReported,
    this.overtimePayMinor,
    this.holidayPayMinor,
    this.allowancesMinor,
    this.notes,
  });

  final int grossPayMinor;
  final DateTime? paidAt;
  final int? workedMinutesReported;
  final int? overtimePayMinor;
  final int? holidayPayMinor;
  final int? allowancesMinor;
  final String? notes;
}

class PayVerificationController
    extends StateNotifier<PayVerificationControllerState> {
  PayVerificationController(this._ref)
    : super(const PayVerificationControllerState());

  final Ref _ref;

  Future<void> saveAndCompare({
    required PayVerificationRouteArgs args,
    required PayVerificationDraft draft,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final repository = _ref.read(actualPayslipRepositoryProvider);
      final existingResult = await repository.getForJobAndPeriod(
        jobId: args.jobId,
        periodStart: args.periodStart,
        periodEnd: args.periodEnd,
      );
      final existingPayslip = existingResult.when(
        success: (value) => value,
        failure: (error) => throw error,
      );

      final now = DateTime.now().toUtc();
      final payslip =
          (existingPayslip ??
                  ActualPayslip(
                    id: AppId.generate(),
                    jobId: args.jobId,
                    periodStart: args.periodStart,
                    periodEnd: args.periodEnd,
                    paidAt: null,
                    grossPayMinor: draft.grossPayMinor,
                    workedMinutesReported: null,
                    overtimePayMinor: null,
                    holidayPayMinor: null,
                    allowancesMinor: null,
                    notes: null,
                    source: ActualPayslipSource.manual,
                    createdAt: now,
                    updatedAt: now,
                  ))
              .copyWith(
                grossPayMinor: draft.grossPayMinor,
                paidAt: draft.paidAt,
                setPaidAt: true,
                workedMinutesReported: draft.workedMinutesReported,
                setWorkedMinutesReported: true,
                overtimePayMinor: draft.overtimePayMinor,
                setOvertimePayMinor: true,
                holidayPayMinor: draft.holidayPayMinor,
                setHolidayPayMinor: true,
                allowancesMinor: draft.allowancesMinor,
                setAllowancesMinor: true,
                notes: draft.notes,
                setNotes: true,
                updatedAt: now,
              );

      final saveResult = await repository.save(payslip);
      saveResult.when(success: (_) {}, failure: (error) => throw error);

      _ref.invalidate(payVerificationViewProvider(args));
      state = PayVerificationControllerState(
        isSaving: false,
        completedAt: DateTime.now(),
      );
    } catch (error) {
      state = state.copyWith(isSaving: false, errorMessage: error.toString());
    }
  }

  Future<void> delete({
    required PayVerificationRouteArgs args,
    required String payslipId,
  }) async {
    state = state.copyWith(isDeleting: true, clearError: true);

    try {
      final deleteResult = await _ref
          .read(actualPayslipRepositoryProvider)
          .delete(payslipId);
      deleteResult.when(success: (_) {}, failure: (error) => throw error);

      _ref.invalidate(payVerificationViewProvider(args));
      state = PayVerificationControllerState(
        isDeleting: false,
        completedAt: DateTime.now(),
      );
    } catch (error) {
      state = state.copyWith(isDeleting: false, errorMessage: error.toString());
    }
  }
}

final payVerificationControllerProvider =
    StateNotifierProvider.autoDispose<
      PayVerificationController,
      PayVerificationControllerState
    >(PayVerificationController.new);
