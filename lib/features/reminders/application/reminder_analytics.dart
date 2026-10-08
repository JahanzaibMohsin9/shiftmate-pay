import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ReminderAnalyticsEvent { reminderSettingsSaved, reminderRescheduled }

abstract interface class ReminderAnalyticsTracker {
  void track(
    ReminderAnalyticsEvent event, {
    Map<String, Object?> fields = const {},
  });
}

class DebugReminderAnalyticsTracker implements ReminderAnalyticsTracker {
  const DebugReminderAnalyticsTracker();

  static const bool _analyticsLoggingEnabled = bool.fromEnvironment(
    'SHIFTMATE_LOG_ANALYTICS',
    defaultValue: false,
  );

  @override
  void track(
    ReminderAnalyticsEvent event, {
    Map<String, Object?> fields = const {},
  }) {
    if (kReleaseMode || !_analyticsLoggingEnabled) {
      return;
    }

    debugPrint('[ReminderAnalytics] ${event.name} $fields');
  }
}

final reminderAnalyticsTrackerProvider = Provider<ReminderAnalyticsTracker>(
  (ref) => const DebugReminderAnalyticsTracker(),
);
