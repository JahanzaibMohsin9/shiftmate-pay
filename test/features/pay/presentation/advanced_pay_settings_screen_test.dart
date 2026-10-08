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
import 'package:shiftmate_pay/data/repositories/drift_holiday_rule_set_repository.dart';
import 'package:shiftmate_pay/data/repositories/drift_job_repository.dart';
import 'package:shiftmate_pay/data/repositories/drift_pay_rule_set_repository.dart';
import 'package:shiftmate_pay/domain/entities/holiday_rule_set.dart';
import 'package:shiftmate_pay/domain/entities/job.dart';
import 'package:shiftmate_pay/domain/entities/pay_rule_set.dart';
import 'package:shiftmate_pay/features/pay/presentation/screens/advanced_pay_settings_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('advanced pay settings shows Day 11 IA and free-tier gate', (
    tester,
  ) async {
    final setup = await _pumpScreen(
      tester,
      premiumUnlocked: false,
      jobName: 'Hospital nights',
    );

    expect(find.text('Advanced pay rules'), findsOneWidget);
    expect(find.text('Simple pay defaults'), findsOneWidget);
    expect(find.text('Best time to gate Premium'), findsOneWidget);
    expect(find.text('Unlock advanced pay rules'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('What Premium unlocks here'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('What Premium unlocks here'), findsOneWidget);

    await setup.database.close();
  });

  testWidgets('premium users see the completed Day 13 advanced-pay flow', (
    tester,
  ) async {
    final setup = await _pumpScreen(
      tester,
      premiumUnlocked: true,
      jobName: 'Warehouse weekends',
    );

    expect(find.text('Complete advanced pay flow'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Readable rule summary'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Readable rule summary'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Pay impact preview'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Pay impact preview'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Overtime tiers'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Overtime tiers'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Night differential'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Night differential'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Allowances'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Allowances'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Break deductions'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Break deductions'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Save advanced pay rules'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Save advanced pay rules'), findsOneWidget);

    await setup.database.close();
  });
}

Future<_ScreenSetup> _pumpScreen(
  WidgetTester tester, {
  required bool premiumUnlocked,
  required String jobName,
}) async {
  SharedPreferences.setMockInitialValues({'premium_unlocked': premiumUnlocked});
  final preferences = AppPreferences(await SharedPreferences.getInstance());
  final database = AppDatabase(executor: NativeDatabase.memory());
  final jobRepository = DriftJobRepository(database);
  final payRuleSetRepository = DriftPayRuleSetRepository(database);
  final holidayRuleSetRepository = DriftHolidayRuleSetRepository(database);

  final createdAt = DateTime.utc(2026, 4, 4);
  final jobId = AppId.generate();
  final payRuleSetId = AppId.generate();
  final holidayRuleSetId = AppId.generate();

  await jobRepository.saveJob(
    Job(
      id: jobId,
      name: jobName,
      colorHex: '#4F46E5',
      currencyCode: 'USD',
      hourlyRate: const CurrencyAmount(minorUnits: 3250, currencyCode: 'USD'),
      payRuleSetId: payRuleSetId,
      holidayRuleSetId: holidayRuleSetId,
      defaultSleepLeadMinutes: 480,
      isArchived: false,
      createdAt: createdAt,
      updatedAt: createdAt,
    ),
  );

  await payRuleSetRepository.save(
    PayRuleSet(
      id: payRuleSetId,
      jobId: jobId,
      overtimeThresholdDailyMinutes: 8 * 60,
      overtimeThresholdWeeklyMinutes: 40 * 60,
      overtimeMultiplierBps: 15000,
      doubleTimeThresholdMinutes: null,
      doubleTimeMultiplierBps: null,
      roundRule: RoundRule.nearestMinute,
    ),
  );

  await holidayRuleSetRepository.save(
    HolidayRuleSet(
      id: holidayRuleSetId,
      jobId: jobId,
      holidayMultiplierBps: 20000,
      holidaySource: HolidaySource.manual,
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
        home: AdvancedPaySettingsScreen(jobId: jobId),
      ),
    ),
  );

  await tester.pumpAndSettle();
  return _ScreenSetup(database: database, jobId: jobId);
}

class _ScreenSetup {
  const _ScreenSetup({required this.database, required this.jobId});

  final AppDatabase database;
  final String jobId;
}
