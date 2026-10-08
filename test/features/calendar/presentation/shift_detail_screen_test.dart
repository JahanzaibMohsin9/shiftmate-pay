import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiftmate_pay/core/common/result.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/core/services/reminder_notification_service.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/data/local/database/database_providers.dart';
import 'package:shiftmate_pay/domain/entities/job.dart';
import 'package:shiftmate_pay/domain/entities/planning_settings.dart';
import 'package:shiftmate_pay/domain/entities/reminder_rule.dart';
import 'package:shiftmate_pay/domain/entities/shift_instance.dart';
import 'package:shiftmate_pay/domain/entities/shift_template.dart';
import 'package:shiftmate_pay/domain/repositories/repositories.dart';
import 'package:shiftmate_pay/domain/services/reminder_schedule_planning_service.dart';
import 'package:shiftmate_pay/domain/usecases/usecases.dart';
import 'package:shiftmate_pay/features/calendar/presentation/screens/shift_detail_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('saving an override reschedules reminders', (tester) async {
    final reminderService = _FakeReminderNotificationService();
    final shiftRepository = _FakeShiftInstanceRepository();
    final shiftTemplateRepository = _FakeShiftTemplateRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          shiftTemplateRepositoryProvider.overrideWithValue(
            shiftTemplateRepository,
          ),
          shiftInstanceRepositoryProvider.overrideWithValue(shiftRepository),
          reminderNotificationServiceProvider.overrideWithValue(
            reminderService,
          ),
        ],
        child: MaterialApp(
          home: ShiftDetailScreen(jobId: 'job-1', date: DateTime(2026, 4, 7)),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Save override'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('Save override'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save override'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(shiftRepository.saved, hasLength(1));
    expect(reminderService.syncAllCalls, 1);
  });
}

class _FakeShiftInstanceRepository implements ShiftInstanceRepository {
  final List<ShiftInstance> saved = [];

  @override
  Future<Result<void>> deleteInstance(String id) async => const Success(null);

  @override
  Future<Result<ShiftInstance?>> getInstanceById(String id) async =>
      const Success(null);

  @override
  Future<Result<List<ShiftInstance>>> listInstancesForRange({
    required String jobId,
    required AppDateRange range,
  }) async => const Success([]);

  @override
  Future<Result<ShiftInstance>> saveInstance(ShiftInstance instance) async {
    saved.add(instance);
    return Success(instance);
  }
}

class _FakeShiftTemplateRepository implements ShiftTemplateRepository {
  static const _templates = [
    ShiftTemplate(
      id: 'template-1',
      jobId: 'job-1',
      name: 'Night shift',
      startMinutesLocal: 1200,
      endMinutesLocal: 360,
      unpaidBreakMinutes: 30,
      category: ShiftCategory.night,
      defaultNote: null,
    ),
  ];

  @override
  Future<Result<void>> deleteTemplate(String id) async => const Success(null);

  @override
  Future<Result<ShiftTemplate?>> getTemplateById(String id) async =>
      const Success(null);

  @override
  Future<Result<List<ShiftTemplate>>> listTemplatesForJob(String jobId) async =>
      const Success(_templates);

  @override
  Future<Result<ShiftTemplate>> saveTemplate(ShiftTemplate template) async =>
      Success(template);
}

class _FakeReminderNotificationService extends ReminderNotificationService {
  _FakeReminderNotificationService()
    : super(
        jobRepository: _NoopJobRepository(),
        reminderRuleRepository: _NoopReminderRuleRepository(),
        planningSettingsRepository: _NoopPlanningSettingsRepository(),
        generateShiftScheduleUseCase: _NoopGenerateShiftScheduleUseCase(),
        reminderSchedulePlanningService:
            const ReminderSchedulePlanningService(),
        premiumUnlocked: true,
      );

  int syncAllCalls = 0;

  @override
  Future<void> syncAllReminderSchedules() async {
    syncAllCalls += 1;
  }
}

class _NoopJobRepository implements JobRepository {
  @override
  Future<Result<void>> archiveJob(String id) async => const Success(null);

  @override
  Future<Result<Job?>> getJobById(String id) async => const Success(null);

  @override
  Future<Result<List<Job>>> listJobs() async => const Success([]);

  @override
  Future<Result<Job>> saveJob(Job job) async => Success(job);
}

class _NoopReminderRuleRepository implements ReminderRuleRepository {
  @override
  Future<Result<void>> delete(String id) async => const Success(null);

  @override
  Future<Result<List<ReminderRule>>> listForJob(String jobId) async =>
      const Success([]);

  @override
  Future<Result<ReminderRule>> save(ReminderRule rule) async => Success(rule);
}

class _NoopPlanningSettingsRepository implements PlanningSettingsRepository {
  @override
  Future<Result<PlanningSettings?>> getForJob(String jobId) async =>
      const Success(null);

  @override
  Future<Result<PlanningSettings>> save(PlanningSettings settings) async =>
      Success(settings);
}

class _NoopGenerateShiftScheduleUseCase
    implements GenerateShiftScheduleUseCase {
  @override
  Future<Result<List<ShiftInstance>>> call({
    required String jobId,
    required AppDateRange range,
  }) async => const Success([]);
}
