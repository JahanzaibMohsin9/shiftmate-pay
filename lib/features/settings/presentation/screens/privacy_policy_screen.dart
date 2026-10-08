import 'package:flutter/material.dart';

import '../../../../app/widgets/cards/app_card.dart';
import '../../../../app/widgets/layout/page_scaffold.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PageScaffold(
      title: 'Privacy policy',
      body: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ShiftMate Pay Privacy Policy', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'ShiftMate Pay is designed to keep your job, schedule, reminder, and pay-estimate data on your device.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _PolicySection(
            title: 'What the app stores',
            body:
                'The app stores the jobs, templates, patterns, reminders, notes, exports, and premium-state information you create so it can work offline and restore your experience between launches.',
          ),
          const SizedBox(height: 12),
          const _PolicySection(
            title: 'What is not collected by default',
            body:
                'ShiftMate Pay does not require an account, does not track your location, and does not upload your schedules or notes to ShiftMate Pay servers as part of the current offline-first release.',
          ),
          const SizedBox(height: 12),
          const _PolicySection(
            title: 'Notifications',
            body:
                'If you grant notification permission, the app can schedule local reminders on your device for upcoming shifts and sleep routines. Reminder content is generated from the schedule data you entered.',
          ),
          const SizedBox(height: 12),
          const _PolicySection(
            title: 'Premium purchases',
            body:
                'Premium subscriptions are handled through Google Play Billing. Purchase processing, payment methods, renewals, and refunds are managed by Google Play under Google policies.',
          ),
          const SizedBox(height: 12),
          const _PolicySection(
            title: 'Exports and backups',
            body:
                'When you create a PDF or JSON backup, the app writes that file to local device storage that you control. You decide whether to keep, move, share, or delete those files.',
          ),
          const SizedBox(height: 12),
          const _PolicySection(
            title: 'Contact',
            body:
                'For privacy or support questions, use the Contact support option from Settings.',
          ),
          const SizedBox(height: 12),
          Text(
            'Last updated: March 28, 2026',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  const _PolicySection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

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
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
