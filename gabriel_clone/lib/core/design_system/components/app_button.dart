import 'package:flutter/material.dart';

import '../app_spacing.dart';

enum AppButtonVariant { primary, secondary }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.leadingIcon,
    this.isLoading = false,
    this.backgroundColor,
    this.borderRadius,
    this.iconSize,
    this.textStyle,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? leadingIcon;
  final bool isLoading;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? iconSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (leadingIcon != null) ...[
          Icon(leadingIcon, size: iconSize),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(label, overflow: TextOverflow.ellipsis, style: textStyle),
        ),
      ],
    );

    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: borderRadius == null
                ? null
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                  ),
          ),
          child: child,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
    };
  }
}
