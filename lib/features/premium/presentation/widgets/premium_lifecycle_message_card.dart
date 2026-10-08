import 'package:flutter/material.dart';

import '../../../../app/widgets/cards/app_card.dart';

class PremiumLifecycleMessageCard extends StatelessWidget {
  const PremiumLifecycleMessageCard({
    required this.icon,
    required this.title,
    required this.body,
    this.ctaLabel,
    this.onPressed,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? ctaLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (ctaLabel != null && onPressed != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.arrow_forward_outlined),
              label: Text(ctaLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
