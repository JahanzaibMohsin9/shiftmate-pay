import 'package:flutter/material.dart';

/// Full-width primary action button.
/// Uses the FilledButton theme from AppTheme automatically.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
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

  /// Optional leading icon.
  final Widget? icon;

  /// Defaults to full width. Pass a value to constrain.
  final double width;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon!,
                  const SizedBox(width: 8),
                  Text(text),
                ],
              )
            : Text(text);

    return SizedBox(
      width: width,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
    );
  }
}

