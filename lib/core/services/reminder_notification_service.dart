import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../common/shared_types.dart';
import '../../core/time/app_date_range.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/reminder_schedule_planning_service.dart';
import '../../domain/usecases/usecases.dart';

enum NotificationPermissionState { granted, denied, unsupported }

class ReminderNotificationService {
  ReminderNotificationService({
    required JobRepository jobRepository,
    required ReminderRuleRepository reminderRuleRepository,
    required PlanningSettingsRepository planningSettingsRepository,
    required GenerateShiftScheduleUseCase generateShiftScheduleUseCase,
    required ReminderSchedulePlanningService reminderSchedulePlanningService,
    required bool premiumUnlocked,
    FlutterLocalNotificationsPlugin? notificationsPlugin,
  }) : _jobRepository = jobRepository,
       _reminderRuleRepository = reminderRuleRepository,
       _planningSettingsRepository = planningSettingsRepository,
       _generateShiftScheduleUseCase = generateShiftScheduleUseCase,
       _reminderSchedulePlanningService = reminderSchedulePlanningService,
       _premiumUnlocked = premiumUnlocked,
       _notificationsPlugin =
           notificationsPlugin ?? FlutterLocalNotificationsPlugin();

  static const String shiftReminderChannelId = 'shift_reminders';
  static const String sleepReminderChannelId = 'sleep_reminders';
  static const String prepReminderChannelId = 'prep_reminders';

  final JobRepository _jobRepository;
  final ReminderRuleRepository _reminderRuleRepository;
  final PlanningSettingsRepository _planningSettingsRepository;
  final GenerateShiftScheduleUseCase _generateShiftScheduleUseCase;
  final ReminderSchedulePlanningService _reminderSchedulePlanningService;
  final bool _premiumUnlocked;
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  bool _initialized = false;
  bool _notificationsAvailable = true;

  Future<void> initialize() async {
    if (_initialized || !_notificationsAvailable) {
      return;
    }

    try {
      tz.initializeTimeZones();

      const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      );

      await _notificationsPlugin.initialize(initializationSettings);
      _initialized = true;
    } catch (_) {
      _notificationsAvailable = false;
    }
  }

  Future<NotificationPermissionState> getPermissionState() async {
    await initialize();

    if (!_notificationsAvailable) {
      return NotificationPermissionState.unsupported;
    }

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation == null) {
      return NotificationPermissionState.unsupported;
    }

    final areEnabled = await androidImplementation.areNotificationsEnabled();
    return areEnabled == true
        ? NotificationPermissionState.granted
        : NotificationPermissionState.denied;
  }

  Future<NotificationPermissionState> requestPermission() async {
    await initialize();

    if (!_notificationsAvailable) {
      return NotificationPermissionState.unsupported;
    }

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation == null) {
      return NotificationPermissionState.unsupported;
    }

    final granted = await androidImplementation
        .requestNotificationsPermission();
    return granted == true
        ? NotificationPermissionState.granted
        : NotificationPermissionState.denied;
  }

  Future<void> syncAllReminderSchedules() async {
    await initialize();

    if (!_notificationsAvailable) {
      return;
    }

    final permissionState = await getPermissionState();
    if (permissionState != NotificationPermissionState.granted) {
      await _notificationsPlugin.cancelAll();
      return;
    }

    await _notificationsPlugin.cancelAll();

    final jobsResult = await _jobRepository.listJobs();
    final jobs = jobsResult.when(
      success: (value) => value,
      failure: (error) => throw error,
    );

    for (final job in jobs.where((entry) => !entry.isArchived)) {
      await syncReminderSchedulesForJob(job);
    }
  }

  Future<void> syncReminderSchedulesForJob(Job job) async {
    await initialize();

    if (!_notificationsAvailable) {
      return;
    }

    await cancelReminderSchedulesForJob(job.id);

    final permissionState = await getPermissionState();
    if (permissionState != NotificationPermissionState.granted) {
      return;
    }

    final rulesResult = await _reminderRuleRepository.listForJob(job.id);
    final rules = rulesResult.when(
      success: (value) => value,
      failure: (error) => throw error,
    );

    final window = _reminderSchedulePlanningService.buildSchedulingWindow();
    final scheduleResult = await _generateShiftScheduleUseCase.call(
      jobId: job.id,
      range: window,
    );

    final schedule = scheduleResult.when(
      success: (value) => value,
      failure: (error) => throw error,
    );
    final planningSettingsResult = await _planningSettingsRepository.getForJob(
      job.id,
    );
    final planningSettings = planningSettingsResult.when(
      success: (value) => value,
      failure: (error) => throw error,
    );

    final plan = _reminderSchedulePlanningService.buildPlan(
      job: job,
      rules: rules,
      schedule: schedule,
      planningSettings: planningSettings,
      premiumUnlocked: _premiumUnlocked,
    );

    for (final recommendation in plan.recommendations) {
      await _scheduleRecommendation(
        job: job,
        recommendation: recommendation,
        window: window,
      );
    }
  }

  Future<void> cancelReminderSchedulesForJob(String jobId) async {
    await initialize();

    if (!_notificationsAvailable) {
      return;
    }

    for (final type in const [
      ReminderType.shiftStart,
      ReminderType.sleep,
      ReminderType.prep,
    ]) {
      await _notificationsPlugin.cancel(_notificationId(jobId, type));
    }
  }

  Future<void> _scheduleRecommendation({
    required Job job,
    required ReminderRecommendation recommendation,
    required AppDateRange window,
  }) async {
    final formatter = DateFormat('EEE, MMM d • h:mm a');
    final scheduledAtUtc = recommendation.scheduledFor.toUtc();

    await _notificationsPlugin.zonedSchedule(
      _notificationId(job.id, recommendation.type),
      _titleFor(job: job, recommendation: recommendation),
      _bodyFor(
        job: job,
        recommendation: recommendation,
        formatter: formatter,
        window: window,
      ),
      tz.TZDateTime.from(scheduledAtUtc, tz.UTC),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdFor(recommendation.type),
          _channelNameFor(recommendation.type),
          channelDescription: _channelDescriptionFor(recommendation.type),
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: jsonEncode({
        'jobId': job.id,
        'type': recommendation.type.name,
        'scheduledForUtc': scheduledAtUtc.toIso8601String(),
        'shiftStartUtc': recommendation.shiftStart.toUtc().toIso8601String(),
      }),
    );
  }

  String _titleFor({
    required Job job,
    required ReminderRecommendation recommendation,
  }) {
    return switch (recommendation.type) {
      ReminderType.sleep => 'Sleep reminder for ${job.name}',
      ReminderType.prep => recommendation.title,
      ReminderType.shiftStart => 'Upcoming shift for ${job.name}',
      _ => 'Shift reminder for ${job.name}',
    };
  }

  String _bodyFor({
    required Job job,
    required ReminderRecommendation recommendation,
    required DateFormat formatter,
    required AppDateRange window,
  }) {
    final shiftStartLabel = formatter.format(recommendation.shiftStart);

    return switch (recommendation.type) {
      ReminderType.sleep =>
        '${recommendation.message} ${job.name} shift: $shiftStartLabel. Window: ${DateFormat('MMM d').format(window.start)} - ${DateFormat('MMM d').format(window.end)}.',
      ReminderType.prep =>
        '${recommendation.message} Next ${job.name} shift: $shiftStartLabel. Window: ${DateFormat('MMM d').format(window.start)} - ${DateFormat('MMM d').format(window.end)}.',
      ReminderType.shiftStart =>
        'Your next ${job.name} shift starts at $shiftStartLabel. This alert fired ${recommendation.leadMinutes} minutes early.',
      _ => 'Reminder scheduled for your upcoming ${job.name} shift.',
    };
  }

  int _notificationId(String jobId, ReminderType type) {
    return Object.hash(jobId, type.name) & 0x7fffffff;
  }

  String _channelIdFor(ReminderType type) {
    return switch (type) {
      ReminderType.sleep => sleepReminderChannelId,
      ReminderType.prep => prepReminderChannelId,
      _ => shiftReminderChannelId,
    };
  }

  String _channelNameFor(ReminderType type) {
    return switch (type) {
      ReminderType.sleep => 'Sleep reminders',
      ReminderType.prep => 'Prep reminders',
      _ => 'Shift reminders',
    };
  }

  String _channelDescriptionFor(ReminderType type) {
    return switch (type) {
      ReminderType.sleep =>
        'Prompts to prepare for sleep before an upcoming shift.',
      ReminderType.prep =>
        'Prompts to prepare for an upcoming shift with extra buffer.',
      _ => 'Alerts before an upcoming scheduled shift.',
    };
  }
}
