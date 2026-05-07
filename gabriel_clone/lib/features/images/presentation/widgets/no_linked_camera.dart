import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';

class NoLinkedCamera extends StatelessWidget {
  const NoLinkedCamera({required this.onAddPlace, super.key});

  final VoidCallback onAddPlace;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.videocam_off_outlined, size: 56),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Nenhuma câmera atrelada ao seu perfil.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.headerBlue,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: onAddPlace,
              child: const Text('Adicionar localidade'),
            ),
          ],
        ),
      ),
    );
  }
}
