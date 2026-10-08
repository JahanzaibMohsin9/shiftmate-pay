import '../../core/common/identifiers.dart';
import '../../core/common/result.dart';
import '../../core/time/app_date_range.dart';
import '../entities/pay_verification.dart';
import '../repositories/repositories.dart';
import '../services/pay_discrepancy_detector.dart';
import '../services/pay_verification_comparator.dart';
import 'usecases.dart';

class GetPayVerificationSummaryUseCaseImpl
    implements GetPayVerificationSummaryUseCase {
  GetPayVerificationSummaryUseCaseImpl({
    required ActualPayslipRepository actualPayslipRepository,
    required GetPaySummaryUseCase getPaySummaryUseCase,
    required PayVerificationComparator comparator,
    required PayDiscrepancyDetector discrepancyDetector,
  }) : _actualPayslipRepository = actualPayslipRepository,
       _getPaySummaryUseCase = getPaySummaryUseCase,
       _comparator = comparator,
       _discrepancyDetector = discrepancyDetector;

  final ActualPayslipRepository _actualPayslipRepository;
  final GetPaySummaryUseCase _getPaySummaryUseCase;
  final PayVerificationComparator _comparator;
  final PayDiscrepancyDetector _discrepancyDetector;

  @override
  Future<Result<PayVerificationSummary>> call({
    required EntityId jobId,
    required AppDateRange range,
  }) async {
    final payslipResult = await _actualPayslipRepository.getForJobAndPeriod(
      jobId: jobId,
      periodStart: range.start,
      periodEnd: range.end,
    );
    if (payslipResult.isFailure) {
      return payslipResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }

    final payslip = payslipResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );
    if (payslip == null) {
      return Failure(
        const AppError(
          code: 'payslip_not_found',
          message: 'No saved payslip exists for the selected job and period.',
        ),
      );
    }

    final paySummaryResult = await _getPaySummaryUseCase(
      jobId: jobId,
      range: range,
    );
    if (paySummaryResult.isFailure) {
      return paySummaryResult.when(
        success: (_) => throw StateError('Unreachable state'),
        failure: Failure.new,
      );
    }

    final paySummary = paySummaryResult.when(
      success: (value) => value,
      failure: (_) => throw StateError('Unreachable state'),
    );

    final comparison = _comparator.compare(
      expected: paySummary,
      actual: payslip,
    );

    return Success(
      comparison.copyWith(
        discrepancies: _discrepancyDetector.detect(comparison),
      ),
    );
  }
}
