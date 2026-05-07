import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/router/app_routes.dart';
import 'home_drawer_actions.dart';
import 'home_drawer_header.dart';
import 'home_drawer_switch_tile.dart';
import 'home_drawer_tiles.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    required this.isAlertMapVisible,
    required this.onAlertMapChanged,
    super.key,
  });

  final bool isAlertMapVisible;
  final ValueChanged<bool> onAlertMapChanged;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.8,
      backgroundColor: AppColors.neutral0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            const HomeDrawerHeader(),
            const SizedBox(height: AppSpacing.sm),
            Expanded(child: _DrawerList(isAlertMapVisible, onAlertMapChanged)),
            const Divider(height: 1),
            const _AppVersion(),
          ],
        ),
      ),
    );
  }
}

class _DrawerList extends StatelessWidget {
  const _DrawerList(this.isAlertMapVisible, this.onAlertMapChanged);

  final bool isAlertMapVisible;
  final ValueChanged<bool> onAlertMapChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerActionTile(
          icon: Icons.edit_outlined,
          label: 'Editar Perfil',
          onTap: () => goFromHomeDrawer(context, AppRoutes.editProfile),
        ),
        const Divider(height: 1),
        DrawerActionTile(
          icon: Icons.location_on_outlined,
          label: 'Adicionar Local',
          onTap: () => goFromHomeDrawer(context, AppRoutes.addPlace),
        ),
        const DrawerSectionHeader(label: 'Configurações'),
        AlertMapSwitchTile(
          label: 'Visualizar Mapa de Alertas',
          value: isAlertMapVisible,
          onChanged: (value) {
            Navigator.of(context).pop();
            onAlertMapChanged(value);
          },
        ),
        const Divider(height: 1),
        DrawerActionTile(
          icon: Icons.warning_amber_rounded,
          label: 'Solicitar Suporte Técnico',
          onTap: () => openTechnicalSupport(context),
        ),
        const Divider(height: 1),
        DrawerActionTile(
          icon: Icons.assignment_turned_in_outlined,
          label: 'Sobre o App',
          onTap: () => goFromHomeDrawer(context, AppRoutes.about),
        ),
        const Divider(height: 1),
        DrawerActionTile(
          icon: Icons.help_outline,
          label: 'Dúvidas Frequentes',
          onTap: () => goFromHomeDrawer(context, AppRoutes.faq),
        ),
        const Divider(height: 1),
        DrawerActionTile(
          icon: Icons.logout,
          label: 'Sair',
          onTap: () => confirmHomeLogout(context),
        ),
      ],
    );
  }
}

class _AppVersion extends StatelessWidget {
  const _AppVersion();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
    );
  }
}
