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
      route: AppRoutes.resultados,
      heroTag: 'resultados-label',
      usesPush: true,
    ),
    _BottomNavItem(
      label: 'Ocorrências',
      icon: Icons.security_outlined,
      activeIcon: Icons.security,
      route: AppRoutes.ocorrencias,
      heroTag: 'ocorrencias-label',
      usesPush: true,
    ),
    _BottomNavItem(
      label: 'Placas',
      icon: Icons.directions_car_outlined,
      activeIcon: Icons.directions_car,
      route: AppRoutes.placas,
      heroTag: 'placas-label',
      usesPush: true,
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
        maintainBottomViewPadding: true,
        child: SizedBox(
          height: 86,
          child: Row(
            children: [
              for (var index = 0; index < _items.length; index++)
                Expanded(
                  child: _BottomNavButton(
                    item: _items[index],
                    isSelected: (currentIndex < 0 ? 0 : currentIndex) == index,
                    onTap: () {
                      final item = _items[index];
                      if (currentLocation == item.route) {
                        return;
                      }

                      if (item.usesPush && currentLocation == AppRoutes.home) {
                        context.push(item.route);
                      } else {
                        context.go(item.route);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _BottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labelText = Text(
      item.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppColors.neutral900,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              color: AppColors.neutral900,
              size: 22,
            ),
            const SizedBox(height: 3),
            item.heroTag != null
                ? Hero(
                    tag: item.heroTag!,
                    flightShuttleBuilder:
                        (context, animation, direction, fromCtx, toCtx) {
                          return FadeTransition(
                            opacity: animation,
                            child: toCtx.widget,
                          );
                        },
                    child: Material(
                      color: Colors.transparent,
                      child: labelText,
                    ),
                  )
                : labelText,
          ],
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
    this.heroTag,
    this.usesPush = false,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  final String? heroTag;
  final bool usesPush;
}
