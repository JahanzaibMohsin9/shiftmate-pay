import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/routing/app_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/widgets/cards/app_card.dart';
import '../../../../data/local/database/database_providers.dart';
import '../../../jobs/application/jobs_providers.dart';
import '../../../premium/application/premium_analytics.dart';
import '../../../premium/application/premium_billing_providers.dart';
import '../../../premium/domain/premium_state.dart';
import '../../application/theme_mode_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeControllerProvider);
    final premiumState = ref.watch(premiumStateProvider);
    final entitlement = premiumState.entitlement;
    final jobsAsync = ref.watch(jobsProvider);
    final preferences = ref.watch(appPreferencesProvider);
    final exportHistoryCount = preferences.exportHistory.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.pagePadding,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Appearance', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Choose how ShiftMate Pay should look on this device.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ThemeModeTile(
                    title: 'Use system setting',
                    subtitle: 'Follow the phone theme automatically.',
                    value: ThemeMode.system,
                    groupValue: themeMode,
                    onSelected: () => ref
                        .read(themeModeControllerProvider.notifier)
                        .setThemeMode(ThemeMode.system),
                  ),
                  const SizedBox(height: 10),
                  _ThemeModeTile(
                    title: 'Light mode',
                    subtitle: 'Always use the light theme.',
                    value: ThemeMode.light,
                    groupValue: themeMode,
                    onSelected: () => ref
                        .read(themeModeControllerProvider.notifier)
                        .setThemeMode(ThemeMode.light),
                  ),
                  const SizedBox(height: 10),
                  _ThemeModeTile(
                    title: 'Dark mode',
                    subtitle: 'Always use the dark theme.',
                    value: ThemeMode.dark,
                    groupValue: themeMode,
                    onSelected: () => ref
                        .read(themeModeControllerProvider.notifier)
                        .setThemeMode(ThemeMode.dark),
                  ),
                ],
              ),
            ),
            AppSpacing.gapMd,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium subscription',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Premium is positioned around three outcomes: protect income when pay rules get messy, save time when rotas change, and make payslip checks feel calmer.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _InfoPill(
                        label: 'Plan',
                        value: entitlement.premium ? 'Premium' : 'Free',
                      ),
                      _InfoPill(
                        label: 'Status',
                        value: premiumState.status.label,
                      ),
                      _InfoPill(
                        label: 'Freshness',
                        value: premiumState.freshness.name,
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
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                        onPressed: premiumState.isRestoreInProgress
                            ? null
                            : () {
                                ref
                                    .read(premiumAnalyticsTrackerProvider)
                                    .track(
                                      PremiumAnalyticsEvent
                                          .premiumPaywallViewed,
                                      fields: {
                                        'screen_name': 'settings',
                                        'entry_point': 'settings_premium_card',
                                      },
                                    );
                                ref
                                    .read(premiumStateProvider.notifier)
                                    .restorePurchases(entryPoint: 'settings');
                              },
                        icon: const Icon(Icons.restore),
                        label: Text(
                          premiumState.isRestoreInProgress
                              ? 'Restoring...'
                              : 'Restore purchases',
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.push(
                          AppRoutes.premiumWithContext(
                            entryPoint: 'settings_premium_card',
                          ),
                        ),
                        icon: const Icon(Icons.workspace_premium_outlined),
                        label: const Text('Open Premium'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapMd,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shortcuts', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Quick access to reminders, backup, and the Premium surfaces tied to real workflow value.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SettingsLinkTile(
                    icon: Icons.notifications_outlined,
                    title: 'Reminders',
                    subtitle: 'Manage shift and sleep alerts.',
                    onTap: () => context.push(AppRoutes.reminders),
                  ),
                  const SizedBox(height: 10),
                  _SettingsLinkTile(
                    icon: Icons.ios_share_outlined,
                    title: 'Export & backup',
                    subtitle: 'Create PDF or JSON exports of your data.',
                    onTap: () => context.push(AppRoutes.export),
                  ),
                  const SizedBox(height: 10),
                  _SettingsLinkTile(
                    icon: Icons.workspace_premium_outlined,
                    title: 'Premium',
                    subtitle:
                        'Review the current plan, pricing presentation, and trust-focused Premium benefits.',
                    onTap: () => context.push(
                      AppRoutes.premiumWithContext(
                        entryPoint: 'settings_shortcuts',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapMd,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current app state', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'A quick snapshot of what is available on this device.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  jobsAsync.when(
                    data: (jobs) => Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _InfoPill(
                          label: 'Plan',
                          value: entitlement.premium ? 'Premium' : 'Free',
                        ),
                        _InfoPill(label: 'Jobs', value: '${jobs.length}'),
                        _InfoPill(
                          label: 'Exports',
                          value: '$exportHistoryCount',
                        ),
                        _InfoPill(
                          label: 'Onboarding',
                          value: preferences.onboardingCompleted
                              ? 'Complete'
                              : 'Not finished',
                        ),
                      ],
                    ),
                    loading: () =>
                        const _InlineLoadingState(label: 'Loading app info...'),
                    error: (error, _) => _InlineErrorState(
                      label: 'Unable to load app info',
                      message: error.toString(),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapMd,
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snap) {
                final version = snap.hasData
                    ? '${snap.data!.version} (${snap.data!.buildNumber})'
                    : '—';
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About & support',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ShiftMate Pay keeps your jobs, schedules, and pay estimates in one offline-first app built for shift workers.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InfoPill(label: 'Version', value: version),
                      const SizedBox(height: 16),
                      _SettingsLinkTile(
                        icon: Icons.email_outlined,
                        title: 'Contact support',
                        subtitle: 'support@shiftmatepay.com',
                        onTap: () => launchUrl(
                          Uri.parse(
                            'mailto:support@shiftmatepay.com'
                            '?subject=ShiftMate+Pay+Support+($version)',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _SettingsLinkTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy policy',
                        subtitle: 'View how your data is handled in the app.',
                        onTap: () => context.push(AppRoutes.privacyPolicy),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onSelected,
  });

  final String title;
  final String subtitle;
  final ThemeMode value;
  final ThemeMode groupValue;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.flat,
      onTap: onSelected,
      child: Row(
        children: [
          Icon(
            groupValue == value
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsLinkTile extends StatelessWidget {
  const _SettingsLinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.flat,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Text('$label: $value'),
    );
  }
}

class _InlineLoadingState extends StatelessWidget {
  const _InlineLoadingState({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
      ],
    );
  }
}

class _InlineErrorState extends StatelessWidget {
  const _InlineErrorState({required this.label, required this.message});

  final String label;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          message,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
}
