import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../cubit/home_cubit.dart';

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({
    required this.tabIndex,
    required this.isAlertMapEnabled,
    super.key,
  });

  final int tabIndex;
  final bool isAlertMapEnabled;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final barWidth = isAlertMapEnabled
        ? (width - 172).clamp(188.0, 220.0)
        : (width - 220).clamp(132.0, 168.0);

    return Container(
      width: barWidth,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            color: Color(0x26000000),
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          _HomeTabButton(
            label: 'Camaleões',
            isSelected: tabIndex == 0,
            onTap: () => context.read<HomeCubit>().changeTab(0),
          ),
          if (isAlertMapEnabled)
            _HomeTabButton(
              label: 'Alertas',
              isSelected: tabIndex == 1,
              onTap: () => context.read<HomeCubit>().changeTab(1),
            ),
        ],
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: isSelected ? const Color(0xFF5A72C8) : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected ? AppColors.neutral0 : AppColors.neutral900,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
