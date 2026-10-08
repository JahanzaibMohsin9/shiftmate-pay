import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PremiumAnalyticsEvent {
  premiumPaywallViewed,
  premiumFeatureInterestTracked,
  premiumPromptViewed,
  premiumPromptTapped,
  premiumPricingPresented,
  premiumPlanSelected,
  premiumPurchaseStarted,
  premiumPurchasePending,
  premiumPurchaseCancelled,
  premiumPurchaseFailed,
  premiumPurchaseVerified,
  premiumRestoreStarted,
  premiumRestoreSucceeded,
  premiumRestoreEmpty,
  premiumRestoreFailed,
  premiumEntitlementRefreshStarted,
  premiumEntitlementRefreshSucceeded,
  premiumEntitlementRefreshFailed,
  premiumGateEncountered,
}

enum PremiumPromptKind { educational, transactional }

abstract interface class PremiumAnalyticsTracker {
  void track(
    PremiumAnalyticsEvent event, {
    Map<String, Object?> fields = const {},
  });
}

class DebugPremiumAnalyticsTracker implements PremiumAnalyticsTracker {
  const DebugPremiumAnalyticsTracker();

  static const bool _analyticsLoggingEnabled = bool.fromEnvironment(
    'SHIFTMATE_LOG_ANALYTICS',
    defaultValue: false,
  );

  @override
  void track(
    PremiumAnalyticsEvent event, {
    Map<String, Object?> fields = const {},
  }) {
    if (kReleaseMode || !_analyticsLoggingEnabled) {
      return;
    }

    debugPrint('[PremiumAnalytics] ${event.name} $fields');
  }
}

final premiumAnalyticsTrackerProvider = Provider<PremiumAnalyticsTracker>(
  (ref) => const DebugPremiumAnalyticsTracker(),
);
