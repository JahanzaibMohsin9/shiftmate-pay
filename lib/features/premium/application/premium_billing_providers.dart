import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../data/local/database/database_providers.dart';
import '../../../data/local/preferences/app_preferences.dart';
import '../../../domain/entities/app_entitlement.dart';
import '../application/premium_analytics.dart';
import '../data/premium_billing_service.dart';
import '../domain/premium_billing_models.dart';
import '../domain/premium_state.dart';

final premiumPlanCatalogProvider = Provider<List<PremiumPlanDefinition>>(
  (ref) => premiumPlanCatalog,
);

final premiumBillingServiceProvider = Provider<PremiumBillingService>(
  (ref) => PlayPremiumBillingService(
    inAppPurchase: InAppPurchase.instance,
    catalog: ref.watch(premiumPlanCatalogProvider),
  ),
);

final premiumCatalogQueryProvider = FutureProvider<PremiumProductCatalogResult>(
  (ref) => ref.watch(premiumBillingServiceProvider).queryCatalog(),
);

final premiumStateProvider = StateNotifierProvider<PremiumStateController, PremiumState>((ref) {
  return PremiumStateController(
    billingService: ref.watch(premiumBillingServiceProvider),
    preferences: ref.watch(appPreferencesProvider),
    analytics: ref.watch(premiumAnalyticsTrackerProvider),
    catalog: ref.watch(premiumPlanCatalogProvider),
  );
});

final entitlementProvider = Provider<AppEntitlement>(
  (ref) => ref.watch(premiumStateProvider).entitlement,
);

class PremiumStateController extends StateNotifier<PremiumState> {
  PremiumStateController({
    required PremiumBillingService billingService,
    required AppPreferences preferences,
    required PremiumAnalyticsTracker analytics,
    required List<PremiumPlanDefinition> catalog,
  })  : _billingService = billingService,
        _preferences = preferences,
        _analytics = analytics,
        _catalog = catalog,
        super(PremiumState.initial()) {
    _hydrateFromCache();
    _purchaseSubscription = _billingService.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: _handlePurchaseStreamError,
    );
    unawaited(_initialize());
  }

  final PremiumBillingService _billingService;
  final AppPreferences _preferences;
  final PremiumAnalyticsTracker _analytics;
  final List<PremiumPlanDefinition> _catalog;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  Future<void> _initialize() async {
    await refreshCatalog();
    if (!mounted) {
      return;
    }
    await _reconcileOwnedPurchases(source: 'startup');
  }

  void _hydrateFromCache() {
    final raw = _preferences.premiumStateSnapshotJson;
    if (raw == null || raw.isEmpty) {
      if (_preferences.premiumUnlocked) {
        state = state.copyWith(
          entitlement: AppEntitlement.premium(),
          status: PremiumSubscriptionStatus.active,
          freshness: PremiumStateFreshness.cached,
          message:
              'Showing legacy Premium access from this device until Google Play confirms the latest purchase state.',
        );
        return;
      }

      state = state.copyWith(
        status: PremiumSubscriptionStatus.notPurchased,
        freshness: PremiumStateFreshness.stale,
        message: 'Premium has not been verified on this device yet.',
      );
      return;
    }

    try {
      final cached = PremiumState.fromJsonString(raw).copyWith(
        freshness: PremiumStateFreshness.cached,
        message:
            'Showing cached Premium status until Google Play confirms the latest purchase state.',
      );
      state = state.copyWith(
        entitlement: cached.entitlement,
        status: cached.status,
        activePlanId: cached.activePlanId,
        activeProductId: cached.activeProductId,
        freshness: cached.freshness,
        lastVerifiedAt: cached.lastVerifiedAt,
        message: cached.message,
      );
    } catch (_) {
      state = state.copyWith(
        status: PremiumSubscriptionStatus.notPurchased,
        freshness: PremiumStateFreshness.stale,
        message: 'Premium cache could not be read. A fresh Play verification is required.',
      );
    }
  }

  Future<void> refreshCatalog() async {
    _analytics.track(
      PremiumAnalyticsEvent.premiumEntitlementRefreshStarted,
      fields: {'screen_name': 'premium', 'source_freshness': state.freshness.name},
    );

    state = state.copyWith(
      status: state.isPremiumActive ? state.status : PremiumSubscriptionStatus.loading,
      catalogErrorMessage: null,
      purchaseErrorMessage: null,
      message: state.isPremiumActive ? state.message : 'Loading Google Play Premium plans...',
    );

    try {
      final result = await _billingService.queryCatalog();
      if (!mounted) {
        return;
      }
      state = state.copyWith(
        billingAvailable: result.billingAvailable,
        products: result.products,
        missingProductIds: result.notFoundProductIds,
        catalogErrorMessage: result.errorMessage,
        status: state.isPremiumActive
            ? PremiumSubscriptionStatus.active
            : PremiumSubscriptionStatus.notPurchased,
        message: result.billingAvailable
            ? state.message
            : 'Google Play Billing is unavailable on this device right now.',
      );
      _analytics.track(
        PremiumAnalyticsEvent.premiumEntitlementRefreshSucceeded,
        fields: {
          'screen_name': 'premium',
          'billing_available': result.billingAvailable,
          'result': result.hasProducts ? 'products_loaded' : 'no_products',
        },
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      state = state.copyWith(
        status: state.isPremiumActive ? PremiumSubscriptionStatus.active : PremiumSubscriptionStatus.error,
        catalogErrorMessage: error.toString(),
        message: 'Unable to load Premium plans right now.',
      );
      _analytics.track(
        PremiumAnalyticsEvent.premiumEntitlementRefreshFailed,
        fields: {'screen_name': 'premium', 'error_family': 'catalog_query'},
      );
    }
  }

  Future<void> purchaseProduct(PremiumStoreProduct product, {required String entryPoint}) async {
    if (state.isPurchaseInProgress) {
      return;
    }

    _analytics.track(
      PremiumAnalyticsEvent.premiumPlanSelected,
      fields: {
        'entry_point': entryPoint,
        'screen_name': 'premium',
        'product_id': product.productDetails.id,
        'plan_type': product.plan.planType.name,
      },
    );
    _analytics.track(
      PremiumAnalyticsEvent.premiumPurchaseStarted,
      fields: {
        'entry_point': entryPoint,
        'screen_name': 'premium',
        'product_id': product.productDetails.id,
        'plan_type': product.plan.planType.name,
      },
    );

    state = state.copyWith(
      isPurchaseInProgress: true,
      purchaseErrorMessage: null,
      message: 'Opening Google Play purchase flow for ${product.plan.billingPeriodLabel.toLowerCase()} Premium...',
    );

    try {
      await _billingService.purchase(product);
    } catch (error) {
      state = state.copyWith(
        isPurchaseInProgress: false,
        status: state.isPremiumActive ? PremiumSubscriptionStatus.active : PremiumSubscriptionStatus.error,
        purchaseErrorMessage: error.toString(),
        message: 'Unable to start the purchase flow.',
      );
      _analytics.track(
        PremiumAnalyticsEvent.premiumPurchaseFailed,
        fields: {
          'screen_name': 'premium',
          'product_id': product.productDetails.id,
          'plan_type': product.plan.planType.name,
          'error_family': 'purchase_start',
        },
      );
    }
  }

  Future<void> restorePurchases({required String entryPoint}) async {
    if (state.isRestoreInProgress) {
      return;
    }

    _analytics.track(
      PremiumAnalyticsEvent.premiumRestoreStarted,
      fields: {'entry_point': entryPoint, 'screen_name': 'premium'},
    );

    state = state.copyWith(
      isRestoreInProgress: true,
      purchaseErrorMessage: null,
      status: PremiumSubscriptionStatus.loading,
      message: 'Checking Google Play for previous Premium purchases...',
    );

    try {
      await _billingService.restorePurchases();
      await _reconcileOwnedPurchases(
        source: 'restore',
        restoreEntryPoint: entryPoint,
      );
    } catch (error) {
      state = state.copyWith(
        isRestoreInProgress: false,
        status: state.isPremiumActive ? PremiumSubscriptionStatus.active : PremiumSubscriptionStatus.error,
        purchaseErrorMessage: error.toString(),
        message: 'Restore could not be completed right now.',
      );
      _analytics.track(
        PremiumAnalyticsEvent.premiumRestoreFailed,
        fields: {'entry_point': entryPoint, 'screen_name': 'premium', 'error_family': 'restore'},
      );
    }
  }

  Future<void> _reconcileOwnedPurchases({
    required String source,
    String? restoreEntryPoint,
  }) async {
    try {
      final purchases = await _billingService.queryPastPurchases();
      if (!mounted) {
        return;
      }
      final relevantPurchases = purchases
          .where((purchase) => _catalog.any((plan) => plan.productId == purchase.productID))
          .toList(growable: false);

      final pendingPurchase = _selectLatestPurchase(
        relevantPurchases.where((purchase) => purchase.status == PurchaseStatus.pending),
      );
      if (pendingPurchase != null) {
        state = state.copyWith(
          entitlement: AppEntitlement.free(),
          status: PremiumSubscriptionStatus.pending,
          freshness: PremiumStateFreshness.verified,
          activePlanId: _planForProductId(pendingPurchase.productID)?.planId,
          activeProductId: pendingPurchase.productID,
          lastVerifiedAt: DateTime.now().toUtc(),
          isPurchaseInProgress: false,
          isRestoreInProgress: false,
          purchaseErrorMessage: null,
          message: 'Your purchase is pending confirmation from Google Play.',
        );
        return;
      }

      final activePurchase = _selectLatestPurchase(
        relevantPurchases.where(
          (purchase) =>
              purchase.status == PurchaseStatus.purchased ||
              purchase.status == PurchaseStatus.restored,
        ),
      );

      if (activePurchase == null) {
        await _persistPremiumState(
          state.copyWith(
            entitlement: AppEntitlement.free(),
            status: PremiumSubscriptionStatus.notPurchased,
            freshness: PremiumStateFreshness.verified,
            activePlanId: null,
            activeProductId: null,
            lastVerifiedAt: DateTime.now().toUtc(),
            isPurchaseInProgress: false,
            isRestoreInProgress: false,
            purchaseErrorMessage: null,
            message: source == 'restore'
                ? 'No active Premium purchase was restored for this account.'
                : 'No active Premium purchase was found on Google Play.',
          ),
        );
        if (source == 'restore' && restoreEntryPoint != null) {
          _analytics.track(
            PremiumAnalyticsEvent.premiumRestoreEmpty,
            fields: {'entry_point': restoreEntryPoint, 'screen_name': 'premium'},
          );
        }
        return;
      }

      if (activePurchase.pendingCompletePurchase) {
        await _billingService.completePurchase(activePurchase);
      }

      await _persistPremiumState(
        state.copyWith(
          entitlement: AppEntitlement.premium(),
          status: PremiumSubscriptionStatus.active,
          freshness: PremiumStateFreshness.verified,
          activePlanId: _planForProductId(activePurchase.productID)?.planId,
          activeProductId: activePurchase.productID,
          lastVerifiedAt: DateTime.now().toUtc(),
          isPurchaseInProgress: false,
          isRestoreInProgress: false,
          purchaseErrorMessage: null,
          message: source == 'restore'
              ? 'Premium restored successfully.'
              : 'Premium verified from Google Play.',
        ),
      );
      if (source == 'restore' && restoreEntryPoint != null) {
        _analytics.track(
          PremiumAnalyticsEvent.premiumRestoreSucceeded,
          fields: {'entry_point': restoreEntryPoint, 'screen_name': 'premium'},
        );
      }
    } catch (error) {
      if (source == 'restore') {
        rethrow;
      }
      if (!mounted) {
        return;
      }

      state = state.copyWith(
        status: state.isPremiumActive ? PremiumSubscriptionStatus.active : state.status,
        purchaseErrorMessage: error.toString(),
        message: state.isPremiumActive
            ? state.message
            : 'Premium status could not be verified from Google Play.',
      );
    }
  }

  PremiumPlanDefinition? _planForProductId(String productId) {
    for (final plan in _catalog) {
      if (plan.productId == productId) {
        return plan;
      }
    }

    return null;
  }

  PurchaseDetails? _selectLatestPurchase(Iterable<PurchaseDetails> purchases) {
    PurchaseDetails? latest;
    var latestTimestamp = -1;

    for (final purchase in purchases) {
      final timestamp = int.tryParse(purchase.transactionDate ?? '') ?? -1;
      if (latest == null || timestamp > latestTimestamp) {
        latest = purchase;
        latestTimestamp = timestamp;
      }
    }

    return latest;
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      final matchedPlan = _catalog
          .where((plan) => plan.productId == purchase.productID)
          .cast<PremiumPlanDefinition?>()
          .followedBy(const [null])
          .first;

      switch (purchase.status) {
        case PurchaseStatus.pending:
          state = state.copyWith(
            status: PremiumSubscriptionStatus.pending,
            isPurchaseInProgress: true,
            message: 'Your purchase is pending confirmation from Google Play.',
          );
          _analytics.track(
            PremiumAnalyticsEvent.premiumPurchasePending,
            fields: {'screen_name': 'premium', 'product_id': purchase.productID},
          );
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (purchase.pendingCompletePurchase) {
            await _billingService.completePurchase(purchase);
          }
          await _persistPremiumState(
            state.copyWith(
              entitlement: AppEntitlement.premium(),
              status: PremiumSubscriptionStatus.active,
              freshness: PremiumStateFreshness.verified,
              activePlanId: matchedPlan?.planId,
              activeProductId: purchase.productID,
              lastVerifiedAt: DateTime.now().toUtc(),
              isPurchaseInProgress: false,
              isRestoreInProgress: false,
              purchaseErrorMessage: null,
              message: purchase.status == PurchaseStatus.restored
                  ? 'Premium restored successfully.'
                  : 'Premium unlocked successfully.',
            ),
          );
          _analytics.track(
            PremiumAnalyticsEvent.premiumPurchaseVerified,
            fields: {
              'screen_name': 'premium',
              'product_id': purchase.productID,
              'plan_type': matchedPlan?.planType.name ?? 'unknown',
            },
          );
          break;
        case PurchaseStatus.error:
          state = state.copyWith(
            isPurchaseInProgress: false,
            isRestoreInProgress: false,
            status: state.isPremiumActive ? PremiumSubscriptionStatus.active : PremiumSubscriptionStatus.error,
            purchaseErrorMessage: purchase.error?.message ?? 'Unknown billing error',
            message: 'Google Play returned an error while processing your purchase.',
          );
          _analytics.track(
            PremiumAnalyticsEvent.premiumPurchaseFailed,
            fields: {
              'screen_name': 'premium',
              'product_id': purchase.productID,
              'error_family': purchase.error?.code ?? 'purchase_error',
            },
          );
          break;
        case PurchaseStatus.canceled:
          state = state.copyWith(
            isPurchaseInProgress: false,
            status: state.isPremiumActive
                ? PremiumSubscriptionStatus.active
                : PremiumSubscriptionStatus.cancelled,
            message: state.isPremiumActive
                ? state.message
                : 'Purchase cancelled before Google Play completed checkout.',
          );
          _analytics.track(
            PremiumAnalyticsEvent.premiumPurchaseCancelled,
            fields: {'screen_name': 'premium', 'product_id': purchase.productID},
          );
          break;
      }
    }
  }

  void _handlePurchaseStreamError(Object error) {
    state = state.copyWith(
      isPurchaseInProgress: false,
      isRestoreInProgress: false,
      status: state.isPremiumActive ? PremiumSubscriptionStatus.active : PremiumSubscriptionStatus.error,
      purchaseErrorMessage: error.toString(),
      message: 'The Google Play purchase listener failed.',
    );
    _analytics.track(
      PremiumAnalyticsEvent.premiumPurchaseFailed,
      fields: {'screen_name': 'premium', 'error_family': 'purchase_stream'},
    );
  }

  Future<void> _persistPremiumState(PremiumState nextState) async {
    state = nextState;
    await _preferences.setPremiumUnlocked(nextState.entitlement.premium);
    await _preferences.setPremiumStateSnapshotJson(nextState.toJsonString());
  }

  @override
  void dispose() {
    unawaited(_purchaseSubscription?.cancel());
    super.dispose();
  }
}
