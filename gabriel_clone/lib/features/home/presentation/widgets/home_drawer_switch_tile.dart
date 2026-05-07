import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';

class AlertMapSwitchTile extends StatelessWidget {
  const AlertMapSwitchTile({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.headerBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Switch(
              value: value,
              activeThumbColor: const Color(0xFF00C48C),
              activeTrackColor: const Color(0xFF41F2A7),
              inactiveThumbColor: AppColors.neutral600,
              inactiveTrackColor: AppColors.neutral300,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
