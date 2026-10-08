import 'package:in_app_purchase/in_app_purchase.dart';

enum PremiumPlanType { monthly, annual }

class PremiumPlanDefinition {
  const PremiumPlanDefinition({
    required this.planId,
    required this.productId,
    required this.planType,
    required this.billingPeriodLabel,
    required this.featureHighlight,
    required this.launchOfferBadge,
    required this.regularPriceLabel,
    required this.billingDetail,
    required this.purchaseCta,
  });

  final String planId;
  final String productId;
  final PremiumPlanType planType;
  final String billingPeriodLabel;
  final String featureHighlight;
  final String launchOfferBadge;
  final String regularPriceLabel;
  final String billingDetail;
  final String purchaseCta;
}

/// Product id convention:
/// `shiftmate_premium_<billing_period>`
///
/// Keeping ids stable and descriptive makes Play Console setup and support
/// triage easier once internal testing starts.
const premiumPlanCatalog = <PremiumPlanDefinition>[
  PremiumPlanDefinition(
    planId: 'premium_monthly',
    productId: 'shiftmate_premium_monthly',
    planType: PremiumPlanType.monthly,
    billingPeriodLabel: 'Monthly',
    featureHighlight:
        'Best if you want the lowest commitment while trying Premium.',
    launchOfferBadge: 'Launch offer',
    regularPriceLabel: 'Regular price later: \$2.99/month',
    billingDetail:
        'Starts at a lower launch price, then renews at the regular monthly price.',
    purchaseCta: 'Start monthly',
  ),
  PremiumPlanDefinition(
    planId: 'premium_annual',
    productId: 'shiftmate_premium_annual',
    planType: PremiumPlanType.annual,
    billingPeriodLabel: 'Annual',
    featureHighlight:
        'Best value if you want one lower yearly payment and fewer renewal decisions.',
    launchOfferBadge: 'Best launch value',
    regularPriceLabel: 'Regular price later: \$19.99/year',
    billingDetail:
        'Lower first-year launch price. Best value if Premium saves you time or catches one payroll issue.',
    purchaseCta: 'Start annual',
  ),
];

class PremiumStoreProduct {
  const PremiumStoreProduct({required this.plan, required this.productDetails});

  final PremiumPlanDefinition plan;
  final ProductDetails productDetails;
}

class PremiumProductCatalogResult {
  const PremiumProductCatalogResult({
    required this.billingAvailable,
    required this.products,
    required this.notFoundProductIds,
    this.errorMessage,
  });

  final bool billingAvailable;
  final List<PremiumStoreProduct> products;
  final List<String> notFoundProductIds;
  final String? errorMessage;

  bool get hasProducts => products.isNotEmpty;
  bool get hasConfigurationGap => notFoundProductIds.isNotEmpty;
}
