import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftmate_pay/app/routing/app_router.dart';
import 'package:shiftmate_pay/core/common/identifiers.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/core/time/app_date_range.dart';
import 'package:shiftmate_pay/data/local/database/app_database.dart';
import 'package:shiftmate_pay/data/local/database/database_providers.dart';
import 'package:shiftmate_pay/data/local/preferences/app_preferences.dart';
import 'package:shiftmate_pay/domain/entities/shift_pattern.dart';
import 'package:shiftmate_pay/domain/entities/shift_pattern_entry.dart';
import 'package:shiftmate_pay/domain/entities/shift_template.dart';
import 'package:shiftmate_pay/features/calendar/application/calendar_providers.dart';
import 'package:shiftmate_pay/features/jobs/application/jobs_providers.dart';
import 'package:shiftmate_pay/features/onboarding/application/onboarding_controller.dart';
import 'package:shiftmate_pay/features/pay/application/pay_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Day 15 core flow integration', () {
    late AppDatabase database;
    late AppPreferences preferences;
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = AppPreferences(await SharedPreferences.getInstance());
      database = AppDatabase(executor: NativeDatabase.memory());
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          appPreferencesProvider.overrideWithValue(preferences),
        ],
      );
    });

    tearDown(() async {
      container.dispose();
      await database.close();
    });

    test(
      'creates job, pattern, calendar schedule, and pay summary end to end',
      () async {
        final onboardingController = container.read(
          onboardingControllerProvider.notifier,
        );

        final route = await onboardingController.submit(
          jobName: 'Ward Rotation',
          colorHex: '#2563EB',
          currencyCode: 'usd',
          hourlyRateMajorUnits: 30,
          overtimeDailyHours: 8,
          overtimeWeeklyHours: 40,
          overtimeMultiplier: 1.5,
          holidayMultiplier: 2.0,
          defaultReminderLeadMinutes: 480,
        );

        expect(route, AppRoutes.calendar);

        final jobs = await container.read(jobsProvider.future);
        expect(jobs, hasLength(1));
        final job = jobs.single;

        final template = ShiftTemplate(
          id: AppId.generate(),
          jobId: job.id,
          name: 'Night Shift',
          startMinutesLocal: 20 * 60,
          endMinutesLocal: 4 * 60,
          unpaidBreakMinutes: 30,
          category: ShiftCategory.night,
          defaultNote: 'Ward cover',
        );

        final templateSave = await container
            .read(shiftTemplateRepositoryProvider)
            .saveTemplate(template);
        expect(templateSave.isSuccess, isTrue);

        final pattern = ShiftPattern(
          id: AppId.generate(),
          jobId: job.id,
          name: 'Alternating nights',
          cycleLengthDays: 2,
          startDate: DateTime(2024, 2, 28),
          timezone: 'local',
          isActive: true,
        );

        final patternSave = await container
            .read(shiftPatternRepositoryProvider)
            .savePattern(pattern);
        expect(patternSave.isSuccess, isTrue);

        final entrySave = await container
            .read(shiftPatternEntryRepositoryProvider)
            .replaceEntries(
              patternId: pattern.id,
              entries: [
                ShiftPatternEntry(
                  id: AppId.generate(),
                  patternId: pattern.id,
                  dayOffset: 0,
                  shiftTemplateId: template.id,
                  isOffDay: false,
                ),
                ShiftPatternEntry(
                  id: AppId.generate(),
                  patternId: pattern.id,
                  dayOffset: 1,
                  shiftTemplateId: null,
                  isOffDay: true,
                ),
              ],
            );
        expect(entrySave.isSuccess, isTrue);

        final range = CalendarScheduleQuery(
          jobId: job.id,
          range: AppDateRange(
            start: DateTime(2024, 2, 28),
            end: DateTime(2024, 3, 3),
          ),
        );

        final schedule = await container.read(
          calendarScheduleProvider(range).future,
        );

        expect(schedule, hasLength(3));
        expect(schedule.map((instance) => instance.date), [
          DateTime(2024, 2, 28),
          DateTime(2024, 3, 1),
          DateTime(2024, 3, 3),
        ]);
        expect(schedule.first.startDateTime, DateTime(2024, 2, 28, 20));
        expect(schedule.first.endDateTime, DateTime(2024, 2, 29, 4));

        container.read(paySelectedJobIdProvider.notifier).state = job.id;
        container.read(paySelectedPresetProvider.notifier).state =
            DateRangePreset.week;
        container.read(paySelectedAnchorDateProvider.notifier).state = DateTime(
          2024,
          2,
          28,
        );

        final summary = await container.read(paySummaryProvider.future);

        expect(summary, isNotNull);
        expect(summary!.jobId, job.id);
        expect(summary.totalShifts, 3);
        expect(summary.totalWorkedMinutes, 3 * 450);
        expect(summary.basePay, 67500);
        expect(summary.overtimePay, 0);
        expect(summary.holidayPay, 0);
        expect(summary.grossPay, 67500);
      },
    );
  });
}
