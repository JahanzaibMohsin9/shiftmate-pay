import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/database/database_providers.dart';
import '../../../domain/entities/advanced_pay_rule_set.dart';
import '../../../domain/entities/holiday_rule_set.dart';
import '../../../domain/entities/job.dart';
import '../../../domain/entities/pay_rule_set.dart';
import '../../jobs/application/jobs_providers.dart';

class AdvancedPaySettingsViewData {
  const AdvancedPaySettingsViewData({
    required this.job,
    required this.payRuleSet,
    required this.holidayRuleSet,
    required this.advancedPayRuleSet,
  });

  final Job job;
  final PayRuleSet? payRuleSet;
  final HolidayRuleSet? holidayRuleSet;
  final AdvancedPayRuleSet? advancedPayRuleSet;
}

final advancedPaySettingsViewProvider =
    FutureProvider.family<AdvancedPaySettingsViewData, String>((
      ref,
      jobId,
    ) async {
      final jobs = await ref.watch(jobsProvider.future);
      final job = jobs.firstWhere((entry) => entry.id == jobId);
      final payRuleSet = await ref.watch(
        payRuleSetForJobProvider(jobId).future,
      );
      final holidayRuleSet = await ref.watch(
        holidayRuleSetForJobProvider(jobId).future,
      );
      final advancedPayRuleSetResult = await ref
          .watch(advancedPayRuleSetRepositoryProvider)
          .getForJob(jobId);
      final advancedPayRuleSet = advancedPayRuleSetResult.when(
        success: (ruleSet) => ruleSet,
        failure: (error) => throw error,
      );

      return AdvancedPaySettingsViewData(
        job: job,
        payRuleSet: payRuleSet,
        holidayRuleSet: holidayRuleSet,
        advancedPayRuleSet: advancedPayRuleSet,
      );
    });
