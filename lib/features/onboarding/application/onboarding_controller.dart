import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../../app/routing/app_router.dart';
import '../../../core/common/app_constants.dart';
import '../../../core/common/identifiers.dart';
import '../../../core/common/result.dart';
import '../../../core/common/shared_types.dart';
import '../../../core/money/currency_amount.dart';
import '../../../data/local/database/app_database.dart';
import '../../../data/local/database/database_providers.dart';
import '../../../domain/entities/holiday_rule_set.dart';
import '../../../domain/entities/job.dart';
import '../../../domain/entities/pay_rule_set.dart';
import '../../../domain/entities/reminder_rule.dart';
import '../../jobs/application/jobs_providers.dart';
import '../../reminders/application/reminder_providers.dart';

class OnboardingFormState {
  const OnboardingFormState({this.isSubmitting = false, this.errorMessage});

  final bool isSubmitting;
  final String? errorMessage;

  OnboardingFormState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OnboardingFormState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class OnboardingController extends StateNotifier<OnboardingFormState> {
  OnboardingController(this._ref) : super(const OnboardingFormState());

  final Ref _ref;

  Future<String?> submit({
    String? existingJobId,
    String? existingPayRuleSetId,
    String? existingHolidayRuleSetId,
    required String jobName,
    required String colorHex,
    required String currencyCode,
    required double hourlyRateMajorUnits,
    required int overtimeDailyHours,
    required int overtimeWeeklyHours,
    required double overtimeMultiplier,
    required double holidayMultiplier,
    required int defaultReminderLeadMinutes,
  }) async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    final now = DateTime.now().toUtc();
    final isEditing = existingJobId != null;
    final jobId = existingJobId ?? AppId.generate();
    final payRuleSetId = existingPayRuleSetId ?? AppId.generate();
    final holidayRuleSetId = existingHolidayRuleSetId ?? AppId.generate();

    final job = Job(
      id: jobId,
      name: jobName.trim(),
      colorHex: colorHex,
      currencyCode: currencyCode.trim().toUpperCase(),
      hourlyRate: CurrencyAmount(
        minorUnits: (hourlyRateMajorUnits * AppConstants.minorUnitsPerMajorUnit)
            .round(),
        currencyCode: currencyCode.trim().toUpperCase(),
      ),
      payRuleSetId: payRuleSetId,
      holidayRuleSetId: holidayRuleSetId,
      defaultSleepLeadMinutes: defaultReminderLeadMinutes,
      isArchived: false,
      createdAt: now,
      updatedAt: now,
    );

    final payRuleSet = PayRuleSet(
      id: payRuleSetId,
      jobId: jobId,
      overtimeThresholdDailyMinutes:
          overtimeDailyHours * AppConstants.minutesPerHour,
      overtimeThresholdWeeklyMinutes:
          overtimeWeeklyHours * AppConstants.minutesPerHour,
      overtimeMultiplierBps: (overtimeMultiplier * 10000).round(),
      doubleTimeThresholdMinutes: null,
      doubleTimeMultiplierBps: null,
      roundRule: RoundRule.nearestMinute,
    );

    final holidayRuleSet = HolidayRuleSet(
      id: holidayRuleSetId,
      jobId: jobId,
      holidayMultiplierBps: (holidayMultiplier * 10000).round(),
      holidaySource: HolidaySource.manual,
    );

    final database = _ref.read(appDatabaseProvider);
    final jobRepository = _ref.read(jobRepositoryProvider);
    final onboardingRepository = _ref.read(onboardingRepositoryProvider);
    final reminderRepository = _ref.read(reminderRuleRepositoryProvider);

    try {
      await database.transaction(() async {
        final jobSave = await jobRepository.saveJob(job);
        if (jobSave.isFailure) {
          throw _unwrapFailure(jobSave);
        }

        await database
            .into(database.payRuleSetsTable)
            .insertOnConflictUpdate(
              PayRuleSetsTableCompanion.insert(
                id: payRuleSet.id,
                jobId: payRuleSet.jobId,
                overtimeThresholdDailyMinutes: Value(
                  payRuleSet.overtimeThresholdDailyMinutes,
                ),
                overtimeThresholdWeeklyMinutes: Value(
                  payRuleSet.overtimeThresholdWeeklyMinutes,
                ),
                overtimeMultiplierBps: payRuleSet.overtimeMultiplierBps,
                doubleTimeThresholdMinutes: Value(
                  payRuleSet.doubleTimeThresholdMinutes,
                ),
                doubleTimeMultiplierBps: Value(
                  payRuleSet.doubleTimeMultiplierBps,
                ),
                roundRule: payRuleSet.roundRule.name,
              ),
            );

        await database
            .into(database.holidayRuleSetsTable)
            .insertOnConflictUpdate(
              HolidayRuleSetsTableCompanion.insert(
                id: holidayRuleSet.id,
                jobId: holidayRuleSet.jobId,
                holidayMultiplierBps: holidayRuleSet.holidayMultiplierBps,
                holidaySource: holidayRuleSet.holidaySource.name,
              ),
            );

        final reminderRulesResult = await reminderRepository.listForJob(jobId);
        final reminderRules = reminderRulesResult.when(
          success: (rules) => rules,
          failure: (error) => throw error,
        );
        final existingSleepRule = reminderRules
            .where((rule) => rule.type == ReminderType.sleep)
            .firstOrNull;

        final reminderSave = await reminderRepository.save(
          ReminderRule(
            id: existingSleepRule?.id ?? AppId.generate(),
            jobId: jobId,
            type: ReminderType.sleep,
            leadMinutes: defaultReminderLeadMinutes,
            enabled: existingSleepRule?.enabled ?? true,
          ),
        );
        if (reminderSave.isFailure) {
          throw _unwrapFailure(reminderSave);
        }

        if (!isEditing) {
          final onboardingResult = await onboardingRepository
              .setOnboardingCompleted();
          if (onboardingResult.isFailure) {
            throw _unwrapFailure(onboardingResult);
          }
        }
      });

      try {
        await _ref
            .read(reminderNotificationServiceProvider)
            .syncAllReminderSchedules();
      } catch (_) {
        // Onboarding success should not be blocked by notification availability.
      }
      _ref.invalidate(reminderNotificationPermissionProvider);
      _ref.invalidate(jobsProvider);

      state = state.copyWith(isSubmitting: false, clearError: true);
      return isEditing ? AppRoutes.jobs : AppRoutes.calendar;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString(),
      );
      return null;
    }
  }

  AppError _unwrapFailure(Result<Object?> result) {
    return result.when(
      success: (_) => const AppError(
        code: 'unexpected_success',
        message: 'Expected failure result.',
      ),
      failure: (error) => error,
    );
  }
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingFormState>(
      OnboardingController.new,
    );

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
