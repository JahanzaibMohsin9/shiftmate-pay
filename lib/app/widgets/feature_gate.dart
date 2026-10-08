import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_router.dart';
import '../../domain/entities/app_entitlement.dart';
import '../../features/premium/application/premium_analytics.dart';
import '../../features/premium/application/entitlement_provider.dart';

class FeatureGate extends ConsumerWidget {
  const FeatureGate({
    required this.feature,
    required this.child,
    this.lockedLabel,
    this.entryPoint = 'feature_gate',
    super.key,
  });

  final AppFeature feature;
  final Widget child;
  final String? lockedLabel;
  final String entryPoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitlement = ref.watch(entitlementProvider);
    if (entitlement.canAccess(feature)) {
      return child;
    }

    ref
        .read(premiumAnalyticsTrackerProvider)
        .track(
          PremiumAnalyticsEvent.premiumGateEncountered,
          fields: {
            'screen_name': ModalRoute.of(context)?.settings.name ?? 'unknown',
            'entry_point': entryPoint,
            'entitlement_state': entitlement.premium ? 'premium' : 'free',
            'result': feature.name,
          },
        );

    return _PremiumGateBanner(
      label: lockedLabel ?? _defaultLabel(feature),
      onTap: () => context.push(
        AppRoutes.premiumWithContext(
          entryPoint: entryPoint,
          feature: feature.name,
        ),
      ),
    );
  }

  String _defaultLabel(AppFeature feature) {
    switch (feature) {
      case AppFeature.multipleJobs:
        return 'Multiple jobs are reserved for Premium';
      case AppFeature.widgets:
        return 'Home screen widgets are included with Premium';
      case AppFeature.advancedPayRules:
        return 'Advanced pay rules are included with Premium';
      case AppFeature.payVerification:
        return 'Payslip verification is included with Premium';
      case AppFeature.forecasting:
        return 'Income forecasting is included with Premium';
      case AppFeature.import:
        return 'CSV rota import is included with Premium';
      case AppFeature.export:
        return 'PDF export is reserved for Premium';
      case AppFeature.reminders:
        return 'Personalized reminder templates are included with Premium';
    }
  }
}

class _PremiumGateBanner extends StatelessWidget {
  const _PremiumGateBanner({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
            ),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                theme.colorScheme.secondaryContainer.withValues(alpha: 0.2),
              ],
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lock_outline,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PremiumTeaserCard extends ConsumerStatefulWidget {
  const PremiumTeaserCard({
    required this.features,
    this.title = 'Premium',
    this.description,
    this.ctaLabel = 'See Premium options',
    this.entryPoint = 'premium_teaser_card',
    this.feature,
    this.promptKind = PremiumPromptKind.educational,
    super.key,
  });

  final String title;
  final List<String> features;
  final String? description;
  final String ctaLabel;
  final String entryPoint;
  final String? feature;
  final PremiumPromptKind promptKind;

  @override
  ConsumerState<PremiumTeaserCard> createState() => _PremiumTeaserCardState();
}

class _PremiumTeaserCardState extends ConsumerState<PremiumTeaserCard> {
  bool _viewTracked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewTracked) {
      return;
    }

    _viewTracked = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref
          .read(premiumAnalyticsTrackerProvider)
          .track(
            PremiumAnalyticsEvent.premiumPromptViewed,
            fields: {
              'screen_name': ModalRoute.of(context)?.settings.name ?? 'unknown',
              'entry_point': widget.entryPoint,
              'prompt_kind': widget.promptKind.name,
              if (widget.feature != null) 'feature': widget.feature,
            },
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          ref
              .read(premiumAnalyticsTrackerProvider)
              .track(
                PremiumAnalyticsEvent.premiumPromptTapped,
                fields: {
                  'screen_name':
                      ModalRoute.of(context)?.settings.name ?? 'unknown',
                  'entry_point': widget.entryPoint,
                  'prompt_kind': widget.promptKind.name,
                  if (widget.feature != null) 'feature': widget.feature,
                },
              );
          ref
              .read(premiumAnalyticsTrackerProvider)
              .track(
                PremiumAnalyticsEvent.premiumFeatureInterestTracked,
                fields: {
                  'screen_name':
                      ModalRoute.of(context)?.settings.name ?? 'unknown',
                  'entry_point': widget.entryPoint,
                  if (widget.feature != null) 'feature': widget.feature,
                },
              );
          context.push(
            AppRoutes.premiumWithContext(
              entryPoint: widget.entryPoint,
              feature: widget.feature,
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
                theme.colorScheme.secondaryContainer.withValues(alpha: 0.35),
              ],
            ),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.workspace_premium_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: theme.colorScheme.primary),
                ],
              ),
              const SizedBox(height: 12),
              if (widget.description != null) ...[
                Text(
                  widget.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              ...widget.features.map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.star_border,
                        size: 14,
                        color: theme.colorScheme.primary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.ctaLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
