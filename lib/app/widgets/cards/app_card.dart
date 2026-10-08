import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

// ─────────────────────────────────────────────────────────────
//  AppCard — flat, border-only surface container.
//
//  Variants:
//   • surface  (default) — white card on off-white bg
//   • tinted   — primary-tinted background, no border
//   • flat     — only background, no border, no shadow
// ─────────────────────────────────────────────────────────────
enum AppCardVariant { surface, tinted, flat }

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.cardPadding,
    this.onTap,
    this.color,
    this.variant = AppCardVariant.surface,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  /// Override the background color explicitly.
  final Color? color;

  final AppCardVariant variant;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final br = borderRadius ?? AppRadius.brMd;

    final Color bg;
    final Border? border;

    switch (variant) {
      case AppCardVariant.tinted:
        bg = color ??
            (isLight
                ? AppColors.primaryContainer
                : AppColors.primaryContainerDark);
        border = null;
        break;
      case AppCardVariant.flat:
        bg = color ??
            (isLight ? AppColors.surface1Light : AppColors.surface1Dark);
        border = null;
        break;
      case AppCardVariant.surface:
        bg = color ??
            (isLight ? AppColors.surface0Light : AppColors.surface0Dark);
        border = Border.all(
          color: isLight ? AppColors.borderLight : AppColors.borderDark,
          width: 1,
        );
    }

    return ClipRRect(
      borderRadius: br,
      child: Material(
        color: bg,
        child: InkWell(
          onTap: onTap,
          borderRadius: br is BorderRadius ? br : null,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: br,
              border: border,
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
