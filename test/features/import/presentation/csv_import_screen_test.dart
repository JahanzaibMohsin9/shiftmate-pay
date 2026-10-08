import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shiftmate_pay/app/theme/app_theme.dart';
import 'package:shiftmate_pay/core/common/result.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/core/money/currency_amount.dart';
import 'package:shiftmate_pay/core/services/reminder_notification_service.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/data/local/database/database_providers.dart';
import 'package:shiftmate_pay/data/local/preferences/app_preferences.dart';
import 'package:shiftmate_pay/domain/entities/import_preview.dart';
import 'package:shiftmate_pay/domain/entities/job.dart';
import 'package:shiftmate_pay/domain/entities/planning_settings.dart';
import 'package:shiftmate_pay/domain/entities/reminder_rule.dart';
import 'package:shiftmate_pay/domain/entities/shift_instance.dart';
import 'package:shiftmate_pay/domain/repositories/repositories.dart';
import 'package:shiftmate_pay/domain/services/reminder_schedule_planning_service.dart';
import 'package:shiftmate_pay/domain/usecases/usecases.dart';
import 'package:shiftmate_pay/features/import/application/import_providers.dart';
import 'package:shiftmate_pay/features/import/presentation/screens/csv_import_screen.dart';
import 'package:shiftmate_pay/features/jobs/application/jobs_providers.dart';

void main() {
  final job = Job(
    id: 'job-1',
    name: 'Ward rota',
    colorHex: '#4F46E5',
    currencyCode: 'USD',
    hourlyRate: const CurrencyAmount(minorUnits: 3000, currencyCode: 'USD'),
    payRuleSetId: 'pay-rules-1',
    holidayRuleSetId: 'holiday-rules-1',
    defaultSleepLeadMinutes: 480,
    isArchived: false,
    createdAt: DateTime.utc(2026, 4, 1),
    updatedAt: DateTime.utc(2026, 4, 1),
  );

  testWidgets('free users can preview rows but see a premium gate at save', (
    tester,
  ) async {
    final fakePicker = _FakeCsvImportFileService();
    await _pumpScreen(
      tester,
      premiumUnlocked: false,
      job: job,
      fileService: fakePicker,
      previewUseCase: _FakeBuildShiftImportPreviewUseCase(_preview(job.id)),
      repository: _FakeShiftInstanceRepository(),
    );

    await tester.tap(find.text('Choose CSV file'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Review before save'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Accepted rows'), findsOneWidget);
    expect(
      find.text(
        'Preview is free to review. Saving accepted import rows is a Premium action.',
      ),
      findsOneWidget,
    );
    expect(find.text('Import 1 accepted rows'), findsOneWidget);
  });

  testWidgets('premium users can import accepted rows', (tester) async {
    final fakeRepository = _FakeShiftInstanceRepository();
    final fakePicker = _FakeCsvImportFileService();
    final reminderService = _FakeReminderNotificationService();
    await _pumpScreen(
      tester,
      premiumUnlocked: true,
      job: job,
      fileService: fakePicker,
      previewUseCase: _FakeBuildShiftImportPreviewUseCase(_preview(job.id)),
      repository: fakeRepository,
      reminderService: reminderService,
    );

    await tester.tap(find.text('Choose CSV file'));
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(CsvImportScreen)),
    );
    await container
        .read(csvImportControllerProvider(job.id).notifier)
        .importAcceptedRows();
    await tester.pumpAndSettle();

    expect(fakeRepository.saved.length, 1);
    expect(fakeRepository.saved.single.jobId, job.id);
    expect(reminderService.syncAllCalls, 1);
  });
}

Future<void> _pumpScreen(
  WidgetTester tester, {
  required bool premiumUnlocked,
  required Job job,
  required CsvImportFileService fileService,
  required BuildShiftImportPreviewUseCase previewUseCase,
  required ShiftInstanceRepository repository,
  ReminderNotificationService? reminderService,
}) async {
  SharedPreferences.setMockInitialValues({'premium_unlocked': premiumUnlocked});
  final preferences = AppPreferences(await SharedPreferences.getInstance());
  await tester.binding.setSurfaceSize(const Size(800, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appPreferencesProvider.overrideWithValue(preferences),
        jobsProvider.overrideWith((ref) async => [job]),
        csvImportFileServiceProvider.overrideWithValue(fileService),
        buildShiftImportPreviewUseCaseProvider.overrideWithValue(
          previewUseCase,
        ),
        shiftInstanceRepositoryProvider.overrideWithValue(repository),
        reminderNotificationServiceProvider.overrideWithValue(
          reminderService ?? _FakeReminderNotificationService(),
        ),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) =>
                  const CsvImportScreen(jobId: 'job-1'),
            ),
          ],
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

ShiftImportPreviewResult _preview(String jobId) {
  final parsedRow = ParsedShiftImportRow(
    rowNumber: 2,
    rawValues: const {
      'date': '2026-04-10',
      'start_time': '07:00',
      'end_time': '15:00',
    },
    date: DateTime.utc(2026, 4, 10),
    startDateTime: DateTime.utc(2026, 4, 10, 7),
    endDateTime: DateTime.utc(2026, 4, 10, 15),
    jobName: 'Ward rota',
    shiftName: 'Early',
    category: null,
    unpaidBreakMinutes: 30,
    isHoliday: false,
    notes: 'Imported from rota',
    issues: const [],
  );

  return ShiftImportPreviewResult(
    rows: [
      ImportPreviewRow(
        parsedRow: parsedRow,
        status: ImportPreviewRowStatus.accepted,
        message: 'Ready to import as a direct shift.',
        proposedShift: ShiftInstance(
          id: 'import-preview:$jobId:2',
          jobId: jobId,
          date: DateTime.utc(2026, 4, 10),
          templateSnapshot: const ShiftTemplateSnapshot(
            templateId: null,
            name: 'Early',
            category: ShiftCategory.custom,
            startMinutesLocal: 420,
            endMinutesLocal: 900,
            unpaidBreakMinutes: 30,
            defaultNote: 'Imported from rota',
          ),
          startDateTime: DateTime.utc(2026, 4, 10, 7),
          endDateTime: DateTime.utc(2026, 4, 10, 15),
          unpaidBreakMinutes: 30,
          source: ShiftSource.imported,
          note: 'Imported from rota',
          isHoliday: false,
          overrideType: null,
        ),
        duplicateOfShiftId: null,
        conflictedShiftIds: const [],
        appliesAsOverride: false,
      ),
    ],
  );
}

class _FakeCsvImportFileService implements CsvImportFileService {
  @override
  Future<PickedCsvImportFile?> pickCsv() async {
    return const PickedCsvImportFile(
      name: 'april-rota.csv',
      content: 'date,start_time,end_time\n2026-04-10,07:00,15:00',
    );
  }
}

class _FakeBuildShiftImportPreviewUseCase
    implements BuildShiftImportPreviewUseCase {
  _FakeBuildShiftImportPreviewUseCase(this.preview);

  final ShiftImportPreviewResult preview;

  @override
  Future<Result<ShiftImportPreviewResult>> call({
    required String jobId,
    required String csvContent,
  }) async => Success(preview);
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
