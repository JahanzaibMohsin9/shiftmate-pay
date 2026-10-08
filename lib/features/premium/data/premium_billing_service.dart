import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../domain/premium_billing_models.dart';

abstract interface class PremiumBillingService {
  Stream<List<PurchaseDetails>> get purchaseStream;

  Future<PremiumProductCatalogResult> queryCatalog();

  Future<void> purchase(PremiumStoreProduct product);

  Future<void> restorePurchases();

  Future<List<PurchaseDetails>> queryPastPurchases();

  Future<void> completePurchase(PurchaseDetails purchase);
}

class PlayPremiumBillingService implements PremiumBillingService {
  const PlayPremiumBillingService({
    required InAppPurchase inAppPurchase,
    required List<PremiumPlanDefinition> catalog,
  }) : _inAppPurchase = inAppPurchase,
       _catalog = catalog;

  final InAppPurchase _inAppPurchase;
  final List<PremiumPlanDefinition> _catalog;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _inAppPurchase.purchaseStream;

  @override
  Future<PremiumProductCatalogResult> queryCatalog() async {
    final billingAvailable = await _inAppPurchase.isAvailable();
    if (!billingAvailable) {
      return const PremiumProductCatalogResult(
        billingAvailable: false,
        products: [],
        notFoundProductIds: [],
        errorMessage: 'Google Play Billing is unavailable on this device right now.',
      );
    }

    final response = await _inAppPurchase.queryProductDetails(
      _catalog.map((plan) => plan.productId).toSet(),
    );

    final plansById = {for (final plan in _catalog) plan.productId: plan};
    final products = response.productDetails
        .where((details) => plansById.containsKey(details.id))
        .map(
          (details) => PremiumStoreProduct(
            plan: plansById[details.id]!,
            productDetails: details,
          ),
        )
        .toList(growable: false)
      ..sort(
        (left, right) => left.plan.planType.index.compareTo(right.plan.planType.index),
      );

    return PremiumProductCatalogResult(
      billingAvailable: true,
      products: products,
      notFoundProductIds: response.notFoundIDs.toList(growable: false),
      errorMessage: response.error?.message,
    );
  }

  @override
  Future<void> purchase(PremiumStoreProduct product) async {
    final purchaseStarted = await _inAppPurchase.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product.productDetails),
    );

    if (!purchaseStarted) {
      throw StateError('Google Play Billing did not start the purchase flow.');
    }
  }

  @override
  Future<void> restorePurchases() {
    return _inAppPurchase.restorePurchases();
  }

  @override
  Future<List<PurchaseDetails>> queryPastPurchases() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return const [];
    }

    final addition =
        _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
    final response = await addition.queryPastPurchases();

    if (response.error != null) {
      throw StateError(response.error!.message);
    }

    return response.pastPurchases;
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) {
    return _inAppPurchase.completePurchase(purchase);
  }
}
