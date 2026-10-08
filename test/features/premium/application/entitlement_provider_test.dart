import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftmate_pay/data/local/database/database_providers.dart';
import 'package:shiftmate_pay/data/local/preferences/app_preferences.dart';
import 'package:shiftmate_pay/domain/entities/app_entitlement.dart';
import 'package:shiftmate_pay/features/premium/application/premium_billing_providers.dart';
import 'package:shiftmate_pay/features/premium/data/premium_billing_service.dart';
import 'package:shiftmate_pay/features/premium/domain/premium_billing_models.dart';

void main() {
  test('entitlementProvider defaults to free tier when premium is not unlocked', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await AppPreferences.create();
    final container = ProviderContainer(
      overrides: [
        appPreferencesProvider.overrideWithValue(preferences),
        premiumBillingServiceProvider.overrideWithValue(
          const _FakePremiumBillingService(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final entitlement = container.read(entitlementProvider);

    expect(entitlement.premium, isFalse);
    expect(entitlement.canAccess(AppFeature.export), isFalse);
  });

  test('entitlementProvider resolves premium tier from persisted preferences', () async {
    SharedPreferences.setMockInitialValues({'premium_unlocked': true});
    final preferences = await AppPreferences.create();
    final container = ProviderContainer(
      overrides: [
        appPreferencesProvider.overrideWithValue(preferences),
        premiumBillingServiceProvider.overrideWithValue(
          const _FakePremiumBillingService(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final entitlement = container.read(entitlementProvider);

    expect(entitlement.premium, isTrue);
    expect(entitlement.canAccess(AppFeature.multipleJobs), isTrue);
    expect(entitlement.canAccess(AppFeature.export), isTrue);
  });

  test('startup reconciliation unlocks premium from an owned Play purchase', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await AppPreferences.create();
    final container = ProviderContainer(
      overrides: [
        appPreferencesProvider.overrideWithValue(preferences),
        premiumBillingServiceProvider.overrideWithValue(
          _FakePremiumBillingService(
            pastPurchases: [
              _FakePurchaseDetails(
                productID: 'shiftmate_premium_monthly',
                status: PurchaseStatus.purchased,
                transactionDate: '100',
              ),
            ],
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(entitlementProvider);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    final entitlement = container.read(entitlementProvider);
    expect(entitlement.premium, isTrue);
    expect(entitlement.canAccess(AppFeature.export), isTrue);
    expect(preferences.premiumUnlocked, isTrue);
  });

  test('startup reconciliation clears stale cached premium when Play has no purchase', () async {
    SharedPreferences.setMockInitialValues({
      'premium_unlocked': true,
      'premium_state_snapshot':
          '{"premium":true,"status":"active","freshness":"cached","billingAvailable":true}',
    });
    final preferences = await AppPreferences.create();
    final container = ProviderContainer(
      overrides: [
        appPreferencesProvider.overrideWithValue(preferences),
        premiumBillingServiceProvider.overrideWithValue(
          const _FakePremiumBillingService(),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(entitlementProvider);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    final entitlement = container.read(entitlementProvider);
    expect(entitlement.premium, isFalse);
    expect(preferences.premiumUnlocked, isFalse);
  });
}

class _FakePremiumBillingService implements PremiumBillingService {
  const _FakePremiumBillingService({
    this.pastPurchases = const [],
  });

  final List<PurchaseDetails> pastPurchases;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => const Stream.empty();

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {}

  @override
  Future<void> purchase(PremiumStoreProduct product) async {}

  @override
  Future<PremiumProductCatalogResult> queryCatalog() async {
    return const PremiumProductCatalogResult(
      billingAvailable: true,
      products: [],
      notFoundProductIds: [],
    );
  }

  @override
  Future<List<PurchaseDetails>> queryPastPurchases() async => pastPurchases;

  @override
  Future<void> restorePurchases() async {}
}

class _FakePurchaseDetails extends PurchaseDetails {
  _FakePurchaseDetails({
    required super.productID,
    required super.status,
    required String transactionDate,
  }) : super(
         transactionDate: transactionDate,
         verificationData: PurchaseVerificationData(
      localVerificationData: 'local',
      serverVerificationData: 'server',
      source: 'fake',
         ),
       );
}
