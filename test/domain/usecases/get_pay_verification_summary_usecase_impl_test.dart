import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/common/result.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/domain/entities/actual_payslip.dart';
import 'package:shiftmate_pay/domain/entities/pay_verification.dart';
import 'package:shiftmate_pay/domain/services/pay_discrepancy_detector.dart';
import 'package:shiftmate_pay/domain/repositories/repositories.dart';
import 'package:shiftmate_pay/domain/services/pay_verification_comparator.dart';
import 'package:shiftmate_pay/domain/usecases/get_pay_verification_summary_usecase_impl.dart';
import 'package:shiftmate_pay/domain/usecases/usecases.dart';

void main() {
  final range = AppDateRange(
    start: DateTime.utc(2026, 4, 1),
    end: DateTime.utc(2026, 4, 7),
  );

  test(
    'loads payslip and expected pay summary to build verification summary',
    () async {
      final useCase = GetPayVerificationSummaryUseCaseImpl(
        actualPayslipRepository: _FakeActualPayslipRepository(
          result: Success(_payslip()),
        ),
        getPaySummaryUseCase: _FakeGetPaySummaryUseCase(
          result: Success(_paySummary(range)),
        ),
        comparator: const PayVerificationComparator(),
        discrepancyDetector: const PayDiscrepancyDetector(),
      );

      final result = await useCase(jobId: 'job-1', range: range);

      expect(result.isSuccess, isTrue);
      final summary = result.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
      expect(summary.actualGrossPayMinor, 100000);
      expect(summary.expectedGrossPayMinor, 102000);
      expect(
        summary.varianceDirection,
        PayVerificationVarianceDirection.uncertain,
      );
      expect(summary.discrepancies, isNotEmpty);
    },
  );

  test(
    'returns payslip_not_found when no saved record exists for the period',
    () async {
      final useCase = GetPayVerificationSummaryUseCaseImpl(
        actualPayslipRepository: _FakeActualPayslipRepository(
          result: const Success(null),
        ),
        getPaySummaryUseCase: _FakeGetPaySummaryUseCase(
          result: Success(_paySummary(range)),
        ),
        comparator: const PayVerificationComparator(),
        discrepancyDetector: const PayDiscrepancyDetector(),
      );

      final result = await useCase(jobId: 'job-1', range: range);

      expect(result.isFailure, isTrue);
      expect(
        result.when(success: (_) => 'success', failure: (error) => error.code),
        'payslip_not_found',
      );
    },
  );
}

class _FakeActualPayslipRepository implements ActualPayslipRepository {
  _FakeActualPayslipRepository({required this.result});

  final Result<ActualPayslip?> result;

  @override
  Future<Result<void>> delete(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<ActualPayslip?>> getById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<ActualPayslip?>> getForJobAndPeriod({
    required String jobId,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) async => result;

  @override
  Future<Result<List<ActualPayslip>>> listForJob(String jobId) {
    throw UnimplementedError();
  }

  @override
  Future<Result<ActualPayslip>> save(ActualPayslip payslip) {
    throw UnimplementedError();
  }
}

class _FakeGetPaySummaryUseCase implements GetPaySummaryUseCase {
  _FakeGetPaySummaryUseCase({required this.result});

  final Result<PayPeriodSummary> result;

  @override
  Future<Result<PayPeriodSummary>> call({
    required String jobId,
    required AppDateRange range,
  }) async => result;
}

PayPeriodSummary _paySummary(AppDateRange range) {
  return PayPeriodSummary(
    jobId: 'job-1',
    range: range,
    currencyCode: 'USD',
    periodLabel: '1-7 Apr 2026',
    totalWorkedMinutes: 2280,
    totalShifts: 5,
    holidayShifts: 1,
    basePay: 80000,
    overtimePay: 12000,
    doubleTimePay: 0,
    holidayPay: 3000,
    allowancePay: 2500,
    differentialPay: 4500,
    grossPay: 102000,
    doubleTimeEnabled: false,
    breakdownItems: const [],
  );
}

ActualPayslip _payslip() {
  final now = DateTime.utc(2026, 4, 8);
  return ActualPayslip(
    id: 'payslip-1',
    jobId: 'job-1',
    periodStart: DateTime.utc(2026, 4, 1),
    periodEnd: DateTime.utc(2026, 4, 7),
    paidAt: now,
    grossPayMinor: 100000,
    workedMinutesReported: null,
    overtimePayMinor: null,
    holidayPayMinor: null,
    allowancesMinor: null,
    notes: null,
    source: ActualPayslipSource.manual,
    createdAt: now,
    updatedAt: now,
  );
}
