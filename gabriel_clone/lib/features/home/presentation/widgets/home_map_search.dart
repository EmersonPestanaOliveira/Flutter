import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';

class MapSearchAndFilters extends StatelessWidget {
  const MapSearchAndFilters({
    required this.controller,
    required this.hintText,
    required this.hasActiveFilters,
    required this.onSearchChanged,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final bool hasActiveFilters;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.neutral0,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46,
                child: TextField(
                  controller: controller,
                  onChanged: onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: hintText,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.headerBlue,
                    ),
                    filled: true,
                    fillColor: AppColors.neutral50,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            if (hasActiveFilters) ...[
              const SizedBox(width: AppSpacing.sm),
              Tooltip(
                message: 'Limpar filtros',
                child: IconButton(
                  onPressed: onClear,
                  color: AppColors.accentRed,
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
