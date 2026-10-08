import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

// ─────────────────────────────────────────────────────────────
//  AppSectionHeader — labeled section header with optional
//  trailing action (e.g., "See all").
// ─────────────────────────────────────────────────────────────
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTrailingTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  });

  final String title;
  final String? subtitle;
  final String? trailing;
  final VoidCallback? onTrailingTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.textTheme.titleMedium!.copyWith(
                    color: isLight
                        ? AppColors.textPrimaryLight
                        : AppColors.textPrimaryDark,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: AppTypography.textTheme.bodySmall!.copyWith(
                      color: isLight
                          ? AppColors.textSecondaryLight
                          : AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null)
            GestureDetector(
              onTap: onTrailingTap,
              child: Text(
                trailing!,
                style: AppTypography.textTheme.labelMedium!.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
