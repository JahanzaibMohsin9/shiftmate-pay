import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';

/// Secondary (outlined) action button.
/// Uses OutlinedButton theme from AppTheme.
class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width = double.infinity,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double width;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
              strokeWidth: 2,
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [icon!, const SizedBox(width: 8), Text(text)],
              )
            : Text(text);

    return SizedBox(
      width: width,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
    );
  }
}

/// Destructive / text-link action button.
class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: c,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
      ),
      child: Text(text),
    );
  }
}
