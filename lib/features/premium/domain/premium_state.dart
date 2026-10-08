import 'dart:convert';

import '../../../domain/entities/app_entitlement.dart';

enum PremiumSubscriptionStatus {
  unknown,
  loading,
  notPurchased,
  pending,
  active,
  gracePeriod,
  expired,
  cancelled,
  error,
}

enum PremiumStateFreshness { cached, verified, stale }

class PremiumState {
  const PremiumState({
    required this.entitlement,
    required this.status,
    required this.freshness,
    required this.billingAvailable,
    required this.products,
    required this.missingProductIds,
    this.activePlanId,
    this.activeProductId,
    this.lastVerifiedAt,
    this.message,
    this.catalogErrorMessage,
    this.purchaseErrorMessage,
    this.isPurchaseInProgress = false,
    this.isRestoreInProgress = false,
  });

  factory PremiumState.initial() => PremiumState(
        entitlement: AppEntitlement.free(),
        status: PremiumSubscriptionStatus.unknown,
        freshness: PremiumStateFreshness.stale,
        billingAvailable: false,
        products: [],
        missingProductIds: [],
      );

  factory PremiumState.fromJsonString(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return PremiumState(
      entitlement: (json['premium'] as bool? ?? false)
          ? AppEntitlement.premium()
          : AppEntitlement.free(),
      status: PremiumSubscriptionStatus.values.byName(
        json['status'] as String? ?? PremiumSubscriptionStatus.unknown.name,
      ),
      freshness: PremiumStateFreshness.values.byName(
        json['freshness'] as String? ?? PremiumStateFreshness.cached.name,
      ),
      billingAvailable: json['billingAvailable'] as bool? ?? false,
      products: const [],
      missingProductIds: const [],
      activePlanId: json['activePlanId'] as String?,
      activeProductId: json['activeProductId'] as String?,
      lastVerifiedAt: json['lastVerifiedAt'] == null
          ? null
          : DateTime.tryParse(json['lastVerifiedAt'] as String),
      message: json['message'] as String?,
    );
  }

  static const _unset = Object();

  final AppEntitlement entitlement;
  final PremiumSubscriptionStatus status;
  final String? activePlanId;
  final String? activeProductId;
  final PremiumStateFreshness freshness;
  final DateTime? lastVerifiedAt;
  final String? message;
  final bool billingAvailable;
  final List<dynamic> products;
  final List<String> missingProductIds;
  final String? catalogErrorMessage;
  final String? purchaseErrorMessage;
  final bool isPurchaseInProgress;
  final bool isRestoreInProgress;

  bool get isPremiumActive => entitlement.premium && status == PremiumSubscriptionStatus.active;

  PremiumState copyWith({
    AppEntitlement? entitlement,
    PremiumSubscriptionStatus? status,
    Object? activePlanId = _unset,
    Object? activeProductId = _unset,
    PremiumStateFreshness? freshness,
    Object? lastVerifiedAt = _unset,
    Object? message = _unset,
    bool? billingAvailable,
    List<dynamic>? products,
    List<String>? missingProductIds,
    Object? catalogErrorMessage = _unset,
    Object? purchaseErrorMessage = _unset,
    bool? isPurchaseInProgress,
    bool? isRestoreInProgress,
  }) {
    return PremiumState(
      entitlement: entitlement ?? this.entitlement,
      status: status ?? this.status,
      activePlanId: identical(activePlanId, _unset) ? this.activePlanId : activePlanId as String?,
      activeProductId: identical(activeProductId, _unset)
          ? this.activeProductId
          : activeProductId as String?,
      freshness: freshness ?? this.freshness,
      lastVerifiedAt:
          identical(lastVerifiedAt, _unset) ? this.lastVerifiedAt : lastVerifiedAt as DateTime?,
      message: identical(message, _unset) ? this.message : message as String?,
      billingAvailable: billingAvailable ?? this.billingAvailable,
      products: products ?? this.products,
      missingProductIds: missingProductIds ?? this.missingProductIds,
      catalogErrorMessage: identical(catalogErrorMessage, _unset)
          ? this.catalogErrorMessage
          : catalogErrorMessage as String?,
      purchaseErrorMessage: identical(purchaseErrorMessage, _unset)
          ? this.purchaseErrorMessage
          : purchaseErrorMessage as String?,
      isPurchaseInProgress: isPurchaseInProgress ?? this.isPurchaseInProgress,
      isRestoreInProgress: isRestoreInProgress ?? this.isRestoreInProgress,
    );
  }

  String toJsonString() {
    return jsonEncode({
      'premium': entitlement.premium,
      'status': status.name,
      'activePlanId': activePlanId,
      'activeProductId': activeProductId,
      'freshness': freshness.name,
      'lastVerifiedAt': lastVerifiedAt?.toIso8601String(),
      'message': message,
      'billingAvailable': billingAvailable,
    });
  }
}

extension PremiumSubscriptionStatusPresentation on PremiumSubscriptionStatus {
  String get label {
    switch (this) {
      case PremiumSubscriptionStatus.unknown:
        return 'Unknown';
      case PremiumSubscriptionStatus.loading:
        return 'Refreshing';
      case PremiumSubscriptionStatus.notPurchased:
        return 'Free';
      case PremiumSubscriptionStatus.pending:
        return 'Pending';
      case PremiumSubscriptionStatus.active:
        return 'Active';
      case PremiumSubscriptionStatus.gracePeriod:
        return 'Grace period';
      case PremiumSubscriptionStatus.expired:
        return 'Expired';
      case PremiumSubscriptionStatus.cancelled:
        return 'Cancelled';
      case PremiumSubscriptionStatus.error:
        return 'Error';
    }
  }
}
