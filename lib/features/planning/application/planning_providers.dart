import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/time/app_date_range.dart';
import '../../../core/time/date_range_extensions.dart';
import '../../../data/local/database/database_providers.dart';
import '../../../domain/entities/availability_rule.dart';
import '../../../domain/entities/planning_alert.dart';
import '../../../domain/entities/planning_settings.dart';

class PlanningAlertsQuery {
  const PlanningAlertsQuery({required this.jobId, required this.range});

  final String jobId;
  final AppDateRange range;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PlanningAlertsQuery &&
        other.jobId == jobId &&
        other.range.start == range.start &&
        other.range.end == range.end;
  }

  @override
  int get hashCode => Object.hash(jobId, range.start, range.end);
}

final planningSettingsForJobProvider =
    FutureProvider.family<PlanningSettings?, String>((ref, jobId) async {
      final result = await ref
          .watch(planningSettingsRepositoryProvider)
          .getForJob(jobId);
      return result.when(
        success: (settings) => settings,
        failure: (error) => throw error,
      );
    });

final availabilityRulesForJobProvider =
    FutureProvider.family<List<AvailabilityRule>, String>((ref, jobId) async {
      final result = await ref
          .watch(availabilityRuleRepositoryProvider)
          .listForJob(jobId);
      return result.when(
        success: (rules) => rules,
        failure: (error) => throw error,
      );
    });

final planningAlertsProvider =
    FutureProvider.family<List<PlanningAlert>, PlanningAlertsQuery>((
      ref,
      query,
    ) async {
      final scheduleResult = await ref
          .watch(generatedShiftScheduleUseCaseProvider)
          .call(jobId: query.jobId, range: query.range);
      final shifts = scheduleResult.when(
        success: (instances) => instances,
        failure: (error) => throw error,
      );

      final settings = await ref.watch(
        planningSettingsForJobProvider(query.jobId).future,
      );
      final availability = await ref.watch(
        availabilityRulesForJobProvider(query.jobId).future,
      );
      final payRuleSet = await ref
          .watch(payRuleSetRepositoryProvider)
          .getForJob(query.jobId);

      return ref
          .watch(personalPlanningServiceProvider)
          .evaluate(
            jobId: query.jobId,
            range: query.range,
            shifts: shifts,
            settings: settings,
            availabilityRules: availability,
            payRuleSet: payRuleSet.when(
              success: (value) => value,
              failure: (error) => throw error,
            ),
          );
    });

final planningAlertsForDayProvider =
    FutureProvider.family<List<PlanningAlert>, ({String jobId, DateTime date})>(
      (ref, query) async {
        final targetDate = query.date.startOfDay;
        final range = AppDateRange(
          start: targetDate.subtract(const Duration(days: 7)),
          end: targetDate.add(const Duration(days: 7)),
        );
        final alerts = await ref.watch(
          planningAlertsProvider(
            PlanningAlertsQuery(jobId: query.jobId, range: range),
          ).future,
        );
        return alerts
            .where((alert) => alert.date.startOfDay == targetDate)
            .toList(growable: false);
      },
    );
