import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shiftmate_pay/app/theme/app_theme.dart';
import 'package:shiftmate_pay/data/local/database/database_providers.dart';
import 'package:shiftmate_pay/data/local/preferences/app_preferences.dart';
import 'package:shiftmate_pay/features/premium/application/premium_billing_providers.dart';
import 'package:shiftmate_pay/features/premium/data/premium_billing_service.dart';
import 'package:shiftmate_pay/features/premium/domain/premium_billing_models.dart';
import 'package:shiftmate_pay/features/premium/presentation/screens/premium_screen.dart';

void main() {
  testWidgets(
    'premium screen shows stronger value-led copy for advanced pay interest',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await AppPreferences.create();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appPreferencesProvider.overrideWithValue(preferences),
            premiumBillingServiceProvider.overrideWithValue(
              const _FakePremiumBillingService(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            home: const PremiumScreen(
              entryPoint: 'pay_advanced_rules_prompt',
              highlightFeature: 'advancedPayRules',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Protect your pay, not just your schedule'),
        findsOneWidget,
      );
      expect(
        find.text('Why people upgrade when pay gets complicated'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Opened from the Pay screen while reviewing a real estimate.',
        ),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(
        find.text('Beta pricing presentation'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Beta pricing presentation'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Subscription state'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Subscription state'), findsOneWidget);
      expect(find.text('Restore purchases'), findsOneWidget);
      expect(find.text('Refresh catalog'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Premium plans unavailable'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Premium plans unavailable'), findsOneWidget);
    },
  );
}

class _FakePremiumBillingService implements PremiumBillingService {
  const _FakePremiumBillingService();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => const Stream.empty();

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}

  @override
  Future<void> purchase(PremiumStoreProduct product) async {}

  @override
  Future<PremiumProductCatalogResult> queryCatalog() async {
    return const PremiumProductCatalogResult(
      billingAvailable: false,
      products: [],
      notFoundProductIds: [],
    );
  }

  @override
  Future<List<PurchaseDetails>> queryPastPurchases() async => const [];

  @override
  Future<void> restorePurchases() async {}
}
