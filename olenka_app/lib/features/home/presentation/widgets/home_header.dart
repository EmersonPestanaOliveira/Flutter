import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../auth/data/auth_service.dart';
import 'profile_menu_sheet.dart';

/// Cabecalho com logo a esquerda e avatar do usuario a direita.
/// Avatar abre o ProfileMenuSheet ao toque.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final photoUrl = user?.photoURL;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/logos/logo.webp',
          height: 48,
          fit: BoxFit.contain,
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => ProfileMenuSheet.show(context),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandBlue.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: photoUrl != null
                  ? Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        size: 32,
                        color: AppColors.textTertiary,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 32,
                      color: AppColors.textTertiary,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}