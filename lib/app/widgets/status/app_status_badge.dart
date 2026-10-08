import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

// ─────────────────────────────────────────────────────────────
//  AppStatusBadge — compact colored badge for status labels.
//
//  Semantic: Automatically picks colors from AppColors.
//  Shape is a pill (borderRadius: full).
// ─────────────────────────────────────────────────────────────
enum AppBadgeVariant { success, warning, error, info, neutral }

class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.neutral,
  });

  final String label;
  final AppBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final Color fg;
    final Color bg;

    switch (variant) {
      case AppBadgeVariant.success:
        fg = AppColors.success;
        bg = AppColors.successTint;
        break;
      case AppBadgeVariant.warning:
        fg = AppColors.warning;
        bg = AppColors.warningTint;
        break;
      case AppBadgeVariant.error:
        fg = AppColors.error;
        bg = AppColors.errorTint;
        break;
      case AppBadgeVariant.info:
        fg = AppColors.info;
        bg = AppColors.infoTint;
        break;
      case AppBadgeVariant.neutral:
        final isLight = Theme.of(context).brightness == Brightness.light;
        fg = isLight
            ? AppColors.textSecondaryLight
            : AppColors.textSecondaryDark;
        bg = isLight ? AppColors.surface1Light : AppColors.surface1Dark;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.brFull,
      ),
      child: Text(
        label,
        style: AppTypography.textTheme.labelSmall!.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
