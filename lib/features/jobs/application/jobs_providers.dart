import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/database/database_providers.dart';
import '../../../domain/entities/holiday_rule_set.dart';
import '../../../domain/entities/job.dart';
import '../../../domain/entities/pay_rule_set.dart';
import '../../../domain/entities/shift_template.dart';

final jobsProvider = FutureProvider<List<Job>>((ref) async {
  final result = await ref.watch(jobRepositoryProvider).listJobs();
  return result.when(
    success: (jobs) => jobs.where((job) => !job.isArchived).toList(growable: false),
    failure: (error) => throw error,
  );
});

final shiftTemplatesForJobProvider = FutureProvider.family<List<ShiftTemplate>, String>((ref, jobId) async {
  final result = await ref.watch(shiftTemplateRepositoryProvider).listTemplatesForJob(jobId);
  return result.when(
    success: (templates) => templates,
    failure: (error) => throw error,
  );
});

final payRuleSetForJobProvider = FutureProvider.family<PayRuleSet?, String>((ref, jobId) async {
  final result = await ref.watch(payRuleSetRepositoryProvider).getForJob(jobId);
  return result.when(
    success: (ruleSet) => ruleSet,
    failure: (error) => throw error,
  );
});

final holidayRuleSetForJobProvider =
    FutureProvider.family<HolidayRuleSet?, String>((ref, jobId) async {
      final result = await ref.watch(holidayRuleSetRepositoryProvider).getForJob(jobId);
      return result.when(
        success: (ruleSet) => ruleSet,
        failure: (error) => throw error,
      );
    });
