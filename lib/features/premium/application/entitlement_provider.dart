import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/app_entitlement.dart';
import 'premium_billing_providers.dart';

/// The single source of truth for the current user's entitlement tier.
///
/// In the MVP, entitlement is resolved from persisted local preferences so the
/// same value can be respected by all feature gates and action handlers.
final entitlementProvider = Provider<AppEntitlement>((ref) {
  return ref.watch(premiumStateProvider).entitlement;
});
