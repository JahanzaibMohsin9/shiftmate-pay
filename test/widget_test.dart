import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shiftmate_pay/app/app.dart';
import 'package:shiftmate_pay/app/bootstrap/app_bootstrap_data.dart';
import 'package:shiftmate_pay/app/routing/app_router.dart';
import 'package:shiftmate_pay/data/local/database/database_providers.dart';
import 'package:shiftmate_pay/data/local/preferences/app_preferences.dart';

void main() {
  testWidgets('app boots into onboarding when first-run setup is incomplete', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = AppPreferences(await SharedPreferences.getInstance());
    final GoRouter router = createAppRouter();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appBootstrapDataProvider.overrideWithValue(
            AppBootstrapData(
              environmentName: 'test',
              initializedAt: DateTime.utc(2026, 1, 1),
              enableDebugLogging: true,
              preferences: preferences,
            ),
          ),
          appPreferencesProvider.overrideWithValue(preferences),
        ],
        child: ShiftMatePayApp(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Job setup'), findsOneWidget);
    expect(find.text('Create your first job'), findsOneWidget);
  });
}
