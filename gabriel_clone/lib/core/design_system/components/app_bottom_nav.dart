import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app_colors.dart';
import '../../router/app_routes.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  static const _items = [
    _BottomNavItem(
      label: 'Resultados',
      icon: Icons.article_outlined,
      activeIcon: Icons.article,
      route: AppRoutes.home,
    ),
    _BottomNavItem(
      label: 'Ocorrências',
      icon: Icons.security_outlined,
      activeIcon: Icons.security,
      route: AppRoutes.ocorrencias,
    ),
    _BottomNavItem(
      label: 'Placas',
      icon: Icons.directions_car_outlined,
      activeIcon: Icons.directions_car,
      route: AppRoutes.placas,
    ),
    _BottomNavItem(
      label: 'Imagens',
      icon: Icons.videocam_outlined,
      activeIcon: Icons.videocam,
      route: AppRoutes.imagens,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = _items.indexWhere(
      (item) => currentLocation == item.route,
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            color: Color(0x1F000000),
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.transparent,
            elevation: 0,
            indicatorColor: Colors.transparent,
            labelTextStyle: WidgetStateProperty.all(
              Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.neutral900,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            iconTheme: WidgetStateProperty.all(
              const IconThemeData(color: AppColors.neutral900, size: 28),
            ),
          ),
          child: NavigationBar(
            height: 86,
            selectedIndex: currentIndex < 0 ? 0 : currentIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: (index) => context.go(_items[index].route),
            destinations: [
              for (final item in _items)
                NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.activeIcon),
                  label: item.label,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem {
  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
}