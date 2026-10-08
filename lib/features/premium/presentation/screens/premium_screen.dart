import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/widgets/cards/app_card.dart';
import '../../../../core/common/app_scope.dart';
import '../../application/premium_analytics.dart';
import '../../application/premium_billing_providers.dart';
import '../../domain/premium_billing_models.dart';
import '../../domain/premium_state.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({
    this.entryPoint = 'premium_screen',
    this.highlightFeature,
    super.key,
  });

  final String entryPoint;
  final String? highlightFeature;

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  bool _pricingTracked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref
          .read(premiumAnalyticsTrackerProvider)
          .track(
            PremiumAnalyticsEvent.premiumPaywallViewed,
            fields: {
              'screen_name': 'premium',
              'entry_point': widget.entryPoint,
              if (widget.highlightFeature != null)
                'feature': widget.highlightFeature,
            },
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final premiumState = ref.watch(premiumStateProvider);
    final premiumController = ref.read(premiumStateProvider.notifier);
    _trackPricingPresentationIfNeeded(premiumState);

    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.pagePaddingWithSafeBottom(context),
          children: [
            _PremiumHeroCard(premiumState: premiumState),
            AppSpacing.gapMd,
            _ValuePromiseCard(
              highlightFeature: widget.highlightFeature,
              entryPoint: widget.entryPoint,
            ),
            AppSpacing.gapMd,
            _SubscriptionStatusCard(
              premiumState: premiumState,
              onRestore: () => premiumController.restorePurchases(
                entryPoint: widget.entryPoint,
              ),
            ),
            AppSpacing.gapMd,
            _CatalogSection(
              premiumState: premiumState,
              onPurchase: (product) => premiumController.purchaseProduct(
                product,
                entryPoint: widget.entryPoint,
              ),
            ),
            AppSpacing.gapMd,
            _FeatureListCard(
              title: 'Included with Free',
              subtitle: 'Core tools available on every device.',
              features: AppScope.current.freeFeatures,
              icon: Icons.check_circle_outline,
            ),
            AppSpacing.gapMd,
            _FeatureListCard(
              title: 'Included with Premium',
              subtitle: 'Advanced tools available with an active Premium plan.',
              features: AppScope.current.premiumFeatures,
              icon: Icons.star_border,
            ),
            AppCard(
              child: Text(
                'Premium is for workers whose rota complexity can cost real money. The promise is simple: protect income when payroll gets messy, save setup time when rotas move around, and make it easier to trust the numbers before payday.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _trackPricingPresentationIfNeeded(PremiumState premiumState) {
    if (_pricingTracked || premiumState.products.isEmpty) {
      return;
    }

    _pricingTracked = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref
          .read(premiumAnalyticsTrackerProvider)
          .track(
            PremiumAnalyticsEvent.premiumPricingPresented,
            fields: {
              'screen_name': 'premium',
              'entry_point': widget.entryPoint,
              'presentation': 'annual_recommended_monthly_secondary',
              'product_count': premiumState.products.length,
            },
          );
    });
  }
}

class _PremiumHeroCard extends StatelessWidget {
  const _PremiumHeroCard({required this.premiumState});

  final PremiumState premiumState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = switch (premiumState.status) {
      PremiumSubscriptionStatus.active =>
        'Premium access is active on this device. Your plan status and restore options are available below.',
      PremiumSubscriptionStatus.pending =>
        'Your purchase is pending Google Play confirmation. Premium stays locked until the purchase is verified.',
      _ =>
        'Protect complex pay, shorten rota setup, and keep real payslip checks grounded in the same schedule data you already trust.',
    };

    return AppCard(
      child: Column(
        children: [
          Icon(
            Icons.workspace_premium_outlined,
            size: 52,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Protect your pay, not just your schedule',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ValuePromiseCard extends StatelessWidget {
  const _ValuePromiseCard({
    required this.highlightFeature,
    required this.entryPoint,
  });

  final String? highlightFeature;
  final String entryPoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headline = switch (highlightFeature) {
      'advancedPayRules' => 'Why people upgrade when pay gets complicated',
      'forecasting' => 'Why people upgrade when they need income visibility',
      'import' => 'Why people upgrade when rota entry starts wasting time',
      'export' =>
        'Why people upgrade when schedule changes need to follow them',
      'payVerification' => 'Why people upgrade before payday feels wrong',
      'multipleJobs' => 'Why Premium matters once one job is no longer enough',
      _ => 'What Premium is meant to solve',
    };

    final bullets = switch (highlightFeature) {
      'advancedPayRules' => const [
        'Catch more of the pay your contract promises with overtime tiers, night windows, weekend uplifts, allowances, and break overrides.',
        'See Premium where intent is strongest, right when basic hourly rules stop matching real payslips.',
        'Build toward verification and discrepancy checks without relearning your setup later.',
      ],
      'payVerification' => const [
        'Compare expected pay against a real payslip when something looks off.',
        'Get calm, plain-language explanations instead of a raw mismatch number.',
        'Use discrepancy checks to spot missing overtime, allowances, or likely shift gaps faster.',
      ],
      'forecasting' => const [
        'Project 30, 60, and 90 day earnings from the schedule you already have.',
        'See coverage and confidence clearly when the future rota is only partially known.',
        'Track earnings and overtime targets with nudges that stay grounded in real schedule coverage.',
      ],
      'import' => const [
        'Preview a CSV rota before anything is saved so trust stays high.',
        'Import accepted rows in one step instead of rebuilding every shift by hand.',
        'Catch duplicates, skipped rows, and conflicts before they clutter the calendar.',
      ],
      'export' => const [
        'Create a personal-calendar friendly .ics file from the same saved schedule you already trust in the app.',
        'Refresh the export after rota edits so overnight shifts and off days stay readable outside the app.',
        'Keep schedule-sharing tools close to real workflow moments instead of hiding them behind generic settings.',
      ],
      'multipleJobs' => const [
        'Separate jobs cleanly when rates, reminders, and templates differ.',
        'Keep each rota easier to maintain without collapsing everything into one workaround.',
        'Carry Premium pay-accuracy tools into every saved job.',
      ],
      _ => const [
        'Model the situations where spreadsheets and notes usually break down.',
        'Reduce money stress by making complex pay rules easier to set up and review.',
        'Unlock time-saving and income-protection features near real workflow moments.',
      ],
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(headline, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            _entryPointLabel(entryPoint),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          for (final bullet in bullets) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(bullet)),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

String _entryPointLabel(String entryPoint) {
  return switch (entryPoint) {
    'pay_advanced_rules_prompt' =>
      'Opened from the Pay screen while reviewing a real estimate.',
    'pay_verification_compare_attempt' =>
      'Opened from the Pay screen while trying to compare a real payslip.',
    'pay_verification_discrepancy_details' =>
      'Opened while trying to read full discrepancy explanations.',
    'pay_forecast_insight' =>
      'Opened from the Pay screen while trying to use forecast insights.',
    'calendar_sync_action' =>
      'Opened from the Calendar screen while trying to export schedule changes.',
    'calendar_sync_export' =>
      'Opened from Export while trying to create a personal calendar file.',
    'jobs_csv_import_teaser' =>
      'Opened from the Jobs screen while trying to save rota setup time.',
    'jobs_csv_import_confirm' =>
      'Opened after previewing a CSV import and trying to save accepted rows.',
    'jobs_advanced_rules_teaser' =>
      'Opened from the Jobs screen while reviewing saved setup.',
    'jobs_new_job_limit' => 'Opened after the free-tier job limit was reached.',
    _ => 'Opened from the Premium screen.',
  };
}

class _CatalogSection extends StatelessWidget {
  const _CatalogSection({required this.premiumState, required this.onPurchase});

  final PremiumState premiumState;
  final ValueChanged<PremiumStoreProduct> onPurchase;

  @override
  Widget build(BuildContext context) {
    if (premiumState.status == PremiumSubscriptionStatus.loading &&
        premiumState.products.isEmpty) {
      return const _CatalogLoadingCard();
    }

    if (!premiumState.billingAvailable) {
      return const _CatalogUnavailableCard(
        title: 'Premium plans unavailable',
        message:
            'Premium plans cannot be loaded on this device right now. If you already subscribed, you can still restore your purchases below.',
      );
    }

    if (premiumState.products.isEmpty) {
      return const _CatalogUnavailableCard(
        title: 'Premium plans not available yet',
        message:
            'Google Play has not returned any Premium plans for this device yet. Please try again a little later. If you already subscribed, use restore purchases.',
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available plans',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Start with launch pricing while we keep improving Premium for shift workers with more complex rota and pay setups.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          const _LaunchOfferCard(),
          if (premiumState.catalogErrorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              'Store note: ${premiumState.catalogErrorMessage}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 16),
          for (final product
              in premiumState.products.cast<PremiumStoreProduct>()) ...[
            _PlanCard(
              product: product,
              purchaseEnabled:
                  !premiumState.isPurchaseInProgress &&
                  !premiumState.isRestoreInProgress,
              onPurchase: () => onPurchase(product),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _SubscriptionStatusCard extends StatelessWidget {
  const _SubscriptionStatusCard({
    required this.premiumState,
    required this.onRestore,
  });

  final PremiumState premiumState;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subscription', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusChip(label: premiumState.status.label),
              _StatusChip(label: premiumState.freshness.name),
              _StatusChip(
                label: premiumState.entitlement.premium ? 'Premium' : 'Free',
              ),
            ],
          ),
          if (premiumState.lastVerifiedAt != null) ...[
            const SizedBox(height: 12),
            Text(
              'Last verified: ${premiumState.lastVerifiedAt!.toLocal()}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (premiumState.message != null) ...[
            const SizedBox(height: 12),
            Text(
              premiumState.message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (premiumState.purchaseErrorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              premiumState.purchaseErrorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: premiumState.isRestoreInProgress ? null : onRestore,
            icon: const Icon(Icons.restore),
            label: Text(
              premiumState.isRestoreInProgress
                  ? 'Restoring...'
                  : 'Restore purchases',
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogLoadingCard extends StatelessWidget {
  const _CatalogLoadingCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loading Premium plans',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          const LinearProgressIndicator(),
          const SizedBox(height: 12),
          Text(
            'Fetching the latest Premium plan details for this device.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.product,
    required this.purchaseEnabled,
    required this.onPurchase,
  });

  final PremiumStoreProduct product;
  final bool purchaseEnabled;
  final VoidCallback onPurchase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRecommended = product.plan.planType == PremiumPlanType.annual;

    return AppCard(
      variant: AppCardVariant.flat,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.plan.billingPeriodLabel,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: isRecommended
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainerHighest,
                ),
                child: Text(
                  product.plan.launchOfferBadge,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isRecommended
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isRecommended) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: theme.colorScheme.primaryContainer,
                  ),
                  child: Text(
                    'Recommended',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              Text(
                product.productDetails.price,
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            product.plan.featureHighlight,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.plan.regularPriceLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.plan.billingDetail,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: purchaseEnabled ? onPurchase : null,
            child: Text(product.plan.purchaseCta),
          ),
        ],
      ),
    );
  }
}

class _LaunchOfferCard extends StatelessWidget {
  const _LaunchOfferCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Launch offer',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Monthly starts at \$1.99 and annual starts at \$14.99 during launch. Later pricing is planned at \$2.99/month and \$19.99/year.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose annual if you already know Premium will help with payroll checks, imports, or complex pay rules.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Text(label),
    );
  }
}

class _CatalogUnavailableCard extends StatelessWidget {
  const _CatalogUnavailableCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureListCard extends StatelessWidget {
  const _FeatureListCard({
    required this.title,
    required this.subtitle,
    required this.features,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final List<String> features;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          for (final feature in features)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(feature, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
