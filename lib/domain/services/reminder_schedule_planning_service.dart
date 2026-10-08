import '../../core/common/shared_types.dart';
import '../../core/time/app_date_range.dart';
import '../../core/time/date_range_extensions.dart';
import '../entities/entities.dart';

class ReminderSchedulePlanningService {
  const ReminderSchedulePlanningService();

  static const int defaultSchedulingWindowDays = 14;
  static const int defaultShiftStartLeadMinutes = 60;
  static const int defaultSleepLeadMinutes = 480;

  AppDateRange buildSchedulingWindow({DateTime? now}) {
    final anchor = (now ?? DateTime.now()).startOfDay;
    return AppDateRange(
      start: anchor,
      end: anchor.add(const Duration(days: defaultSchedulingWindowDays - 1)),
    );
  }

  ReminderSchedulePlan buildPlan({
    required Job job,
    required List<ReminderRule> rules,
    required List<ShiftInstance> schedule,
    PlanningSettings? planningSettings,
    bool premiumUnlocked = false,
    DateTime? now,
  }) {
    final referenceTime = now ?? DateTime.now();
    final window = buildSchedulingWindow(now: referenceTime);
    final normalizedRules =
        rules
            .where(
              (rule) => _supportsRuleType(
                rule.type,
                premiumUnlocked: premiumUnlocked,
              ),
            )
            .toList(growable: false)
          ..sort((left, right) => left.type.index.compareTo(right.type.index));

    final nextShift =
        schedule
            .where((shift) => shift.startDateTime.isAfter(referenceTime))
            .toList(growable: false)
          ..sort(
            (left, right) => left.startDateTime.compareTo(right.startDateTime),
          );

    final resolvedNextShift = nextShift.isEmpty ? null : nextShift.first;
    final recommendations = <ReminderRecommendation>[];
    final shiftCategory = resolvedNextShift?.templateSnapshot?.category;
    final shortRestContext = _shortRestContextForNextShift(
      schedule: schedule,
      nextShift: resolvedNextShift,
      planningSettings: planningSettings,
    );

    if (resolvedNextShift != null) {
      for (final rule in normalizedRules.where((rule) => rule.enabled)) {
        final scheduledFor = resolvedNextShift.startDateTime.subtract(
          Duration(minutes: rule.leadMinutes),
        );

        if (scheduledFor.isBefore(referenceTime) ||
            scheduledFor.isBefore(window.start) ||
            scheduledFor.isAfter(window.end.add(const Duration(days: 1)))) {
          continue;
        }

        recommendations.add(
          ReminderRecommendation(
            type: rule.type,
            leadMinutes: rule.leadMinutes,
            scheduledFor: scheduledFor,
            shiftStart: resolvedNextShift.startDateTime,
            shiftCategory: shiftCategory,
            title: recommendationTitleFor(
              type: rule.type,
              shiftCategory: shiftCategory,
              shortRestRisk: shortRestContext != null,
            ),
            message: recommendationMessageFor(
              type: rule.type,
              shiftCategory: shiftCategory,
              leadMinutes: rule.leadMinutes,
              shiftStart: resolvedNextShift.startDateTime,
              shortRestContext: shortRestContext,
            ),
            shortRestRisk: shortRestContext != null,
          ),
        );
      }
    }

    return ReminderSchedulePlan(
      job: job,
      window: window,
      nextShift: resolvedNextShift,
      shortRestContext: shortRestContext,
      activeRules: List<ReminderRule>.unmodifiable(normalizedRules),
      recommendations: List<ReminderRecommendation>.unmodifiable(
        recommendations,
      ),
    );
  }

  int suggestedLeadMinutesFor({
    required ReminderType type,
    ShiftCategory? shiftCategory,
  }) {
    return switch (type) {
      ReminderType.shiftStart => defaultShiftStartLeadMinutes,
      ReminderType.sleep => defaultSleepLeadMinutes,
      ReminderType.prep => switch (shiftCategory) {
        ShiftCategory.night => 180,
        ShiftCategory.evening => 120,
        ShiftCategory.custom => 90,
        _ => 75,
      },
      ReminderType.wake => 30,
    };
  }

  String recommendationTitleFor({
    required ReminderType type,
    ShiftCategory? shiftCategory,
    bool shortRestRisk = false,
  }) {
    return switch (type) {
      ReminderType.sleep =>
        shortRestRisk ? 'Short-rest sleep reminder' : 'Sleep reminder',
      ReminderType.shiftStart => 'Shift start reminder',
      ReminderType.prep => switch (shiftCategory) {
        ShiftCategory.night =>
          shortRestRisk
              ? 'Night shift prep and rest reminder'
              : 'Night shift prep reminder',
        ShiftCategory.evening =>
          shortRestRisk
              ? 'Evening shift prep and rest reminder'
              : 'Evening shift prep reminder',
        ShiftCategory.day =>
          shortRestRisk
              ? 'Day shift prep and rest reminder'
              : 'Day shift prep reminder',
        _ =>
          shortRestRisk
              ? 'Shift prep and rest reminder'
              : 'Shift prep reminder',
      },
      ReminderType.wake => 'Wake reminder',
    };
  }

  String recommendationMessageFor({
    required ReminderType type,
    required int leadMinutes,
    required DateTime shiftStart,
    ShiftCategory? shiftCategory,
    ShortRestContext? shortRestContext,
  }) {
    final shiftTypeLabel = switch (shiftCategory) {
      ShiftCategory.night => 'night shift',
      ShiftCategory.evening => 'evening shift',
      ShiftCategory.day => 'day shift',
      _ => 'shift',
    };
    final shortRestSuffix = shortRestContext == null
        ? ''
        : ' Rest is tighter than your target by ${shortRestContext.shortfallMinutes} minutes, so keep the buffer calm.';

    return switch (type) {
      ReminderType.sleep =>
        'Start winding down $leadMinutes minutes before your next $shiftTypeLabel.$shortRestSuffix',
      ReminderType.shiftStart =>
        'Get a heads-up $leadMinutes minutes before your next shift starts.',
      ReminderType.prep =>
        'Give yourself a calmer buffer $leadMinutes minutes before this $shiftTypeLabel starts.$shortRestSuffix',
      ReminderType.wake =>
        'Wake-up support is still out of scope for the current reminder flow.',
    };
  }

  ShortRestContext? _shortRestContextForNextShift({
    required List<ShiftInstance> schedule,
    required ShiftInstance? nextShift,
    required PlanningSettings? planningSettings,
  }) {
    final minimumRestMinutes = planningSettings?.minimumRestMinutes;
    if (nextShift == null ||
        minimumRestMinutes == null ||
        minimumRestMinutes <= 0) {
      return null;
    }

    final workedShifts =
        schedule
            .where((shift) => shift.endDateTime.isAfter(shift.startDateTime))
            .toList(growable: false)
          ..sort(
            (left, right) => left.startDateTime.compareTo(right.startDateTime),
          );

    ShiftInstance? previousShift;
    for (final shift in workedShifts) {
      if (shift.startDateTime.isBefore(nextShift.startDateTime)) {
        previousShift = shift;
        continue;
      }
      break;
    }

    if (previousShift == null) {
      return null;
    }

    final restGapMinutes = nextShift.startDateTime
        .difference(previousShift.endDateTime)
        .inMinutes;
    if (restGapMinutes >= minimumRestMinutes) {
      return null;
    }

    return ShortRestContext(
      restGapMinutes: restGapMinutes,
      minimumRestMinutes: minimumRestMinutes,
      shortfallMinutes: minimumRestMinutes - restGapMinutes,
    );
  }

  bool _supportsRuleType(ReminderType type, {required bool premiumUnlocked}) {
    return switch (type) {
      ReminderType.shiftStart || ReminderType.sleep => true,
      ReminderType.prep => premiumUnlocked,
      ReminderType.wake => false,
    };
  }
}

class ReminderSchedulePlan {
  const ReminderSchedulePlan({
    required this.job,
    required this.window,
    required this.nextShift,
    required this.shortRestContext,
    required this.activeRules,
    required this.recommendations,
  });

  final Job job;
  final AppDateRange window;
  final ShiftInstance? nextShift;
  final ShortRestContext? shortRestContext;
  final List<ReminderRule> activeRules;
  final List<ReminderRecommendation> recommendations;
}

class ReminderRecommendation {
  const ReminderRecommendation({
    required this.type,
    required this.leadMinutes,
    required this.scheduledFor,
    required this.shiftStart,
    required this.shiftCategory,
    required this.title,
    required this.message,
    required this.shortRestRisk,
  });

  final ReminderType type;
  final Minutes leadMinutes;
  final DateTime scheduledFor;
  final DateTime shiftStart;
  final ShiftCategory? shiftCategory;
  final String title;
  final String message;
  final bool shortRestRisk;
}

class ShortRestContext {
  const ShortRestContext({
    required this.restGapMinutes,
    required this.minimumRestMinutes,
    required this.shortfallMinutes,
  });

  final Minutes restGapMinutes;
  final Minutes minimumRestMinutes;
  final Minutes shortfallMinutes;
}
