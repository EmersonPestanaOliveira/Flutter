import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';

class MapCircleButton extends StatelessWidget {
  const MapCircleButton({required this.icon, required this.onPressed, super.key});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.neutral0,
      shape: const CircleBorder(),
      elevation: 8,
      shadowColor: const Color(0x33000000),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox.square(
          dimension: 56,
          child: Icon(icon, color: AppColors.headerBlue, size: 32),
        ),
      ),
    );
  }
}

class MapFilterButton extends StatelessWidget {
  const MapFilterButton({
    required this.hasActiveFilters,
    required this.onPressed,
    super.key,
  });

  final bool hasActiveFilters;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Filtros',
      child: Material(
        color: hasActiveFilters ? AppColors.brandGreen : AppColors.neutral0,
        shape: const CircleBorder(),
        elevation: 8,
        shadowColor: const Color(0x33000000),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: 42,
            child: Icon(
              Icons.tune,
              color: hasActiveFilters
                  ? AppColors.neutral0
                  : AppColors.headerBlue,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
