import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/shared_types.dart';
import '../../../core/time/app_date_range.dart';
import '../../../core/time/date_range_extensions.dart';
import '../../../data/local/database/database_providers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../jobs/application/jobs_providers.dart';

final paySelectedJobIdProvider = StateProvider<String?>((ref) => null);

final paySelectedAnchorDateProvider =
    StateProvider<DateTime>((ref) => DateTime.now().startOfDay);

final paySelectedPresetProvider =
    StateProvider<DateRangePreset>((ref) => DateRangePreset.month);

final payResolvedJobIdProvider = Provider<String?>((ref) {
  final explicit = ref.watch(paySelectedJobIdProvider);
  final jobsAsync = ref.watch(jobsProvider);

  return jobsAsync.maybeWhen(
    data: (jobs) {
      if (jobs.isEmpty) {
        return null;
      }
      if (explicit != null && jobs.any((job) => job.id == explicit)) {
        return explicit;
      }
      return jobs.first.id;
    },
    orElse: () => explicit,
  );
});

final paySelectedRangeProvider = Provider<AppDateRange>((ref) {
  final anchor = ref.watch(paySelectedAnchorDateProvider).startOfDay;
  final preset = ref.watch(paySelectedPresetProvider);

  return switch (preset) {
    DateRangePreset.week => anchor.weekRange(),
    DateRangePreset.month => anchor.monthRange(),
    DateRangePreset.custom => anchor.monthRange(),
  };
});

final paySummaryProvider = FutureProvider<PayPeriodSummary?>((ref) async {
  final jobId = ref.watch(payResolvedJobIdProvider);
  if (jobId == null) {
    return null;
  }

  final result = await ref.watch(getPaySummaryUseCaseProvider).call(
        jobId: jobId,
        range: ref.watch(paySelectedRangeProvider),
      );

  return result.when(
    success: (summary) => summary,
    failure: (error) => throw error,
  );
});
