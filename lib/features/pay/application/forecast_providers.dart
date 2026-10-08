import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/time/app_date_range.dart';
import '../../../data/local/database/database_providers.dart';
import '../../../domain/entities/income_forecast.dart';
import '../../../domain/entities/job.dart';
import '../../../domain/entities/shift_template.dart';
import '../../jobs/application/jobs_providers.dart';

class ForecastRouteArgs {
  const ForecastRouteArgs({
    required this.jobId,
    required this.anchorDate,
    required this.windowPreset,
  });

  final String jobId;
  final DateTime anchorDate;
  final ForecastWindowPreset windowPreset;

  AppDateRange get range {
    final start = DateTime(anchorDate.year, anchorDate.month, anchorDate.day);
    final length = switch (windowPreset) {
      ForecastWindowPreset.days30 => 30,
      ForecastWindowPreset.days60 => 60,
      ForecastWindowPreset.days90 => 90,
    };
    return AppDateRange(
      start: start,
      end: start.add(Duration(days: length - 1)),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ForecastRouteArgs &&
        other.jobId == jobId &&
        other.anchorDate == anchorDate &&
        other.windowPreset == windowPreset;
  }

  @override
  int get hashCode => Object.hash(jobId, anchorDate, windowPreset);
}

class ForecastViewData {
  const ForecastViewData({required this.job, required this.summary});

  final Job job;
  final IncomeForecastSummary summary;
}

class ForecastSimulationArgs {
  const ForecastSimulationArgs({
    required this.jobId,
    required this.range,
    required this.templateId,
    required this.simulatedDate,
  });

  final String jobId;
  final AppDateRange range;
  final String templateId;
  final DateTime simulatedDate;

  @override
  bool operator ==(Object other) {
    return other is ForecastSimulationArgs &&
        other.jobId == jobId &&
        other.range.start == range.start &&
        other.range.end == range.end &&
        other.templateId == templateId &&
        other.simulatedDate == simulatedDate;
  }

  @override
  int get hashCode =>
      Object.hash(jobId, range.start, range.end, templateId, simulatedDate);
}

final forecastViewProvider =
    FutureProvider.family<ForecastViewData, ForecastRouteArgs>((
      ref,
      args,
    ) async {
      final jobs = await ref.watch(jobsProvider.future);
      final job = jobs.firstWhere((entry) => entry.id == args.jobId);
      final result = await ref
          .watch(getIncomeForecastUseCaseProvider)
          .call(
            jobId: args.jobId,
            range: args.range,
            windowPreset: args.windowPreset,
          );
      final summary = result.when(
        success: (value) => value,
        failure: (error) => throw error,
      );

      return ForecastViewData(job: job, summary: summary);
    });

final forecastTemplatesProvider =
    FutureProvider.family<List<ShiftTemplate>, String>((ref, jobId) async {
      final templates = List<ShiftTemplate>.of(
        await ref.watch(shiftTemplatesForJobProvider(jobId).future),
      );
      templates.sort((left, right) => left.name.compareTo(right.name));
      return templates;
    });

final forecastSimulationProvider =
    FutureProvider.family<
      ForecastShiftSimulationResult,
      ForecastSimulationArgs
    >((ref, args) async {
      final result = await ref
          .watch(simulateExtraShiftForecastUseCaseProvider)
          .call(
            jobId: args.jobId,
            range: args.range,
            shiftTemplateId: args.templateId,
            simulatedDate: args.simulatedDate,
          );
      return result.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
    });
