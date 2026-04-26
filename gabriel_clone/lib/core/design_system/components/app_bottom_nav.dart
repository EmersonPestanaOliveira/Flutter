import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/app_routes.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  static const _items = [
    _BottomNavItem(
      label: 'Resultados',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      route: AppRoutes.home,
    ),
    _BottomNavItem(
      label: 'Ocorrencias',
      icon: Icons.report_outlined,
      activeIcon: Icons.report,
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
      icon: Icons.photo_library_outlined,
      activeIcon: Icons.photo_library,
      route: AppRoutes.imagens,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = _items.indexWhere(
      (item) => currentLocation == item.route,
    );

    return NavigationBar(
      selectedIndex: currentIndex < 0 ? 0 : currentIndex,
      onDestinationSelected: (index) => context.go(_items[index].route),
      destinations: [
        for (final item in _items)
          NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.activeIcon),
            label: item.label,
          ),
      ],
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