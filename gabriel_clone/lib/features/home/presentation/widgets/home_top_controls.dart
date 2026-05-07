import 'package:flutter/material.dart';

import '../../../../core/design_system/app_spacing.dart';
import '../cubit/home_state.dart';
import 'home_map_buttons.dart';
import 'home_tab_bar.dart';

class HomeTopControls extends StatelessWidget {
  const HomeTopControls({
    required this.state,
    required this.horizontalPadding,
    required this.topPadding,
    required this.hasActiveCameraFilters,
    required this.hasActiveAlertFilters,
    required this.onMenuPressed,
    required this.onCameraFiltersPressed,
    required this.onAlertFiltersPressed,
    super.key,
  });

  final HomeLoaded? state;
  final double horizontalPadding;
  final double topPadding;
  final bool hasActiveCameraFilters;
  final bool hasActiveAlertFilters;
  final VoidCallback onMenuPressed;
  final VoidCallback onCameraFiltersPressed;
  final VoidCallback onAlertFiltersPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: topPadding + AppSpacing.xl,
          left: horizontalPadding,
          child: MapCircleButton(icon: Icons.menu, onPressed: onMenuPressed),
        ),
        Positioned(
          top: topPadding + AppSpacing.xl,
          left: horizontalPadding + 64,
          right: horizontalPadding,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state != null)
                  HomeTabBar(
                    tabIndex: state!.tabIndex,
                    isAlertMapEnabled: state!.isAlertMapEnabled,
                  ),
                if (state != null &&
                    (state!.tabIndex == 0 || state!.tabIndex == 1)) ...[
                  const SizedBox(width: AppSpacing.sm),
                  MapFilterButton(
                    hasActiveFilters: state!.tabIndex == 0
                        ? hasActiveCameraFilters
                        : hasActiveAlertFilters,
                    onPressed: state!.tabIndex == 0
                        ? onCameraFiltersPressed
                        : onAlertFiltersPressed,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
