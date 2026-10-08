import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/shared_types.dart';
import '../../../core/time/app_date_range.dart';
import '../../../core/time/date_range_extensions.dart';
import '../../../data/local/database/database_providers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../jobs/application/jobs_providers.dart';
import 'export_file_service.dart';
import 'backup_restore_service.dart';

final exportSelectedJobIdProvider = StateProvider<String?>((ref) => null);

final exportSelectedAnchorDateProvider =
    StateProvider<DateTime>((ref) => DateTime.now().startOfDay);

final exportSelectedPresetProvider =
    StateProvider<DateRangePreset>((ref) => DateRangePreset.month);

final exportResolvedJobIdProvider = Provider<String?>((ref) {
  final explicit = ref.watch(exportSelectedJobIdProvider);
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

final exportSelectedRangeProvider = Provider<AppDateRange>((ref) {
  final anchor = ref.watch(exportSelectedAnchorDateProvider).startOfDay;
  final preset = ref.watch(exportSelectedPresetProvider);

  return switch (preset) {
    DateRangePreset.week => anchor.weekRange(),
    DateRangePreset.month => anchor.monthRange(),
    DateRangePreset.custom => anchor.monthRange(),
  };
});

final scheduleExportBundleProvider = FutureProvider<ScheduleExportBundle?>((ref) async {
  final jobId = ref.watch(exportResolvedJobIdProvider);
  if (jobId == null) {
    return null;
  }

  final result = await ref.watch(buildScheduleExportUseCaseProvider).call(
        jobId: jobId,
        range: ref.watch(exportSelectedRangeProvider),
      );

  return result.when(
    success: (bundle) => bundle,
    failure: (error) => throw error,
  );
});

final exportPaySummaryProvider = FutureProvider<PayPeriodSummary?>((ref) async {
  final jobId = ref.watch(exportResolvedJobIdProvider);
  if (jobId == null) {
    return null;
  }

  final result = await ref.watch(getPaySummaryUseCaseProvider).call(
        jobId: jobId,
        range: ref.watch(exportSelectedRangeProvider),
      );

  return result.when(
    success: (summary) => summary,
    failure: (error) => throw error,
  );
});

final exportFileServiceProvider = Provider<ExportFileService>(
  (ref) => ExportFileService(
    database: ref.watch(appDatabaseProvider),
    preferences: ref.watch(appPreferencesProvider),
  ),
);

final exportHistoryProvider = Provider((ref) {
  return ref.watch(exportFileServiceProvider).loadHistory();
});

final backupRestoreServiceProvider = Provider<BackupRestoreService>(
  (ref) => BackupRestoreService(database: ref.watch(appDatabaseProvider)),
);
