import 'package:flutter/material.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/di/injection_container.dart';

class HomeDrawerHeader extends StatelessWidget {
  const HomeDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = sl<AuthService>().currentUser;
    final name = user?.displayName ?? 'Usuário';
    final photoUrl = sl<AuthService>().cachedProfilePhotoUrl;
    final hasPhoto = photoUrl != null && photoUrl.isNotEmpty;

    return Column(
      children: [
        CircleAvatar(
          radius: 42,
          backgroundColor: AppColors.neutral300,
          backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
          child: hasPhoto
              ? null
              : const Icon(Icons.person, color: AppColors.neutral0, size: 42),
        ),
        Text(
          'Olá, $name',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.headerBlue,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
