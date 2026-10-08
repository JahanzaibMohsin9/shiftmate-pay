import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shiftmate_pay/app/theme/app_theme.dart';
import 'package:shiftmate_pay/core/common/identifiers.dart';
import 'package:shiftmate_pay/core/money/currency_amount.dart';
import 'package:shiftmate_pay/data/local/database/app_database.dart';
import 'package:shiftmate_pay/data/local/database/database_providers.dart';
import 'package:shiftmate_pay/data/local/preferences/app_preferences.dart';
import 'package:shiftmate_pay/data/repositories/drift_job_repository.dart';
import 'package:shiftmate_pay/domain/entities/job.dart';
import 'package:shiftmate_pay/features/export/presentation/screens/export_screen.dart';
import 'package:shiftmate_pay/features/pay/presentation/screens/pay_screen.dart';
import 'package:shiftmate_pay/features/reminders/presentation/screens/reminders_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('pay and export screens show empty states before jobs exist', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = AppPreferences(await SharedPreferences.getInstance());
    final database = AppDatabase(executor: NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          appPreferencesProvider.overrideWithValue(preferences),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          home: const PayScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('No jobs yet'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          appPreferencesProvider.overrideWithValue(preferences),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          home: const ExportScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('No jobs available'), findsOneWidget);

    await database.close();
  });

  testWidgets('reminders screen shows loaded reminder configuration state', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = AppPreferences(await SharedPreferences.getInstance());
    final database = AppDatabase(executor: NativeDatabase.memory());
    final jobRepository = DriftJobRepository(database);

    final createdAt = DateTime.utc(2026, 3, 18);
    await jobRepository.saveJob(
      Job(
        id: AppId.generate(),
        name: 'Clinic nights',
        colorHex: '#4F46E5',
        currencyCode: 'PKR',
        hourlyRate: const CurrencyAmount(
          minorUnits: 25000,
          currencyCode: 'PKR',
        ),
        payRuleSetId: null,
        holidayRuleSetId: null,
        defaultSleepLeadMinutes: 480,
        isArchived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          appPreferencesProvider.overrideWithValue(preferences),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          home: const RemindersScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Reminder settings'),
      250,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Reminder settings'), findsOneWidget);
    expect(find.text('Save reminder settings'), findsOneWidget);

    await database.close();
  });
}
