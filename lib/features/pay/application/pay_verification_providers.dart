import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/time/app_date_range.dart';
import '../../../data/local/database/database_providers.dart';
import '../../../domain/entities/actual_payslip.dart';
import '../../../domain/entities/job.dart';
import '../../../domain/entities/pay_verification.dart';
import '../../../domain/usecases/usecases.dart';
import '../../jobs/application/jobs_providers.dart';

class PayVerificationRouteArgs {
  const PayVerificationRouteArgs({
    required this.jobId,
    required this.periodStart,
    required this.periodEnd,
  });

  final String jobId;
  final DateTime periodStart;
  final DateTime periodEnd;

  AppDateRange get range => AppDateRange(start: periodStart, end: periodEnd);

  @override
  bool operator ==(Object other) {
    return other is PayVerificationRouteArgs &&
        other.jobId == jobId &&
        other.periodStart == periodStart &&
        other.periodEnd == periodEnd;
  }

  @override
  int get hashCode => Object.hash(jobId, periodStart, periodEnd);
}

class PayVerificationViewData {
  const PayVerificationViewData({
    required this.job,
    required this.expectedSummary,
    required this.existingPayslip,
    required this.verificationSummary,
  });

  final Job job;
  final PayPeriodSummary expectedSummary;
  final ActualPayslip? existingPayslip;
  final PayVerificationSummary? verificationSummary;
}

final payVerificationViewProvider =
    FutureProvider.family<PayVerificationViewData, PayVerificationRouteArgs>((
      ref,
      args,
    ) async {
      final jobs = await ref.watch(jobsProvider.future);
      final job = jobs.firstWhere((entry) => entry.id == args.jobId);

      final expectedResult = await ref
          .watch(getPaySummaryUseCaseProvider)
          .call(jobId: args.jobId, range: args.range);
      final expectedSummary = expectedResult.when(
        success: (value) => value,
        failure: (error) => throw error,
      );

      final existingPayslipResult = await ref
          .watch(actualPayslipRepositoryProvider)
          .getForJobAndPeriod(
            jobId: args.jobId,
            periodStart: args.periodStart,
            periodEnd: args.periodEnd,
          );
      final existingPayslip = existingPayslipResult.when(
        success: (value) => value,
        failure: (error) => throw error,
      );

      PayVerificationSummary? verificationSummary;
      if (existingPayslip != null) {
        final verificationResult = await ref
            .watch(getPayVerificationSummaryUseCaseProvider)
            .call(jobId: args.jobId, range: args.range);
        verificationSummary = verificationResult.when(
          success: (value) => value,
          failure: (error) => throw error,
        );
      }

      return PayVerificationViewData(
        job: job,
        expectedSummary: expectedSummary,
        existingPayslip: existingPayslip,
        verificationSummary: verificationSummary,
      );
    });
