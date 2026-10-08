import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shiftmate_pay/app/theme/app_theme.dart';
import 'package:shiftmate_pay/core/common/identifiers.dart';
import 'package:shiftmate_pay/core/common/shared_types.dart';
import 'package:shiftmate_pay/core/money/currency_amount.dart';
import 'package:shiftmate_pay/data/local/database/app_database.dart';
import 'package:shiftmate_pay/data/local/database/database_providers.dart';
import 'package:shiftmate_pay/data/local/preferences/app_preferences.dart';
import 'package:shiftmate_pay/data/repositories/drift_job_repository.dart';
import 'package:shiftmate_pay/data/repositories/drift_shift_template_repository.dart';
import 'package:shiftmate_pay/domain/entities/job.dart';
import 'package:shiftmate_pay/domain/entities/shift_template.dart';
import 'package:shiftmate_pay/features/jobs/presentation/screens/jobs_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'jobs screen renders saved shift templates without fallback placeholders',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = AppPreferences(await SharedPreferences.getInstance());
      final database = AppDatabase(executor: NativeDatabase.memory());
      final jobRepository = DriftJobRepository(database);
      final templateRepository = DriftShiftTemplateRepository(database);

      final createdAt = DateTime.utc(2026, 3, 18);
      final job = Job(
        id: AppId.generate(),
        name: 'Ear',
        colorHex: '#16A34A',
        currencyCode: 'PKR',
        hourlyRate: const CurrencyAmount(
          minorUnits: 28000,
          currencyCode: 'PKR',
        ),
        payRuleSetId: null,
        holidayRuleSetId: null,
        defaultSleepLeadMinutes: 480,
        isArchived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      final template = ShiftTemplate(
        id: AppId.generate(),
        jobId: job.id,
        name: 'Night Shift',
        startMinutesLocal: 22 * 60,
        endMinutesLocal: 6 * 60,
        unpaidBreakMinutes: 30,
        category: ShiftCategory.night,
        defaultNote: 'Bring badge',
      );

      await jobRepository.saveJob(job);
      await templateRepository.saveTemplate(template);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(database),
            appPreferencesProvider.overrideWithValue(preferences),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            home: const JobsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Night Shift'), findsOneWidget);
      expect(find.text('No shift templates yet'), findsNothing);
      expect(find.text('Overnight'), findsOneWidget);
      expect(find.text('Advanced pay rules'), findsOneWidget);
      expect(
        find.text('Protect complex pay from the Jobs tab'),
        findsOneWidget,
      );

      await database.close();
    },
  );
}
