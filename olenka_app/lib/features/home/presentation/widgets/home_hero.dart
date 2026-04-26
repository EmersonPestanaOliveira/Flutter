import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/widgets/buttons/gradient_button.dart';

/// Secao hero: saudacao, titulo, estrelas, descricao, CTA e imagem.
class HomeHero extends StatelessWidget {
  const HomeHero({
    required this.userName,
    required this.onSchedulePressed,
    super.key,
  });

  final String userName;
  final VoidCallback onSchedulePressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: -40,
          top: -10,
          child: Opacity(
            opacity: 0.85,
            child: Image.asset(
              'assets/images/home_carrossel.png',
              width: 480,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ola, $userName',
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.brandBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: 250,
              child: Text(
                'CUIDADOS DE ALTA\nPERFORMANCE PARA\nSUA BELEZA',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.brandBlue,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const _StarsRow(),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: 260,
              child: Text(
                'Venha descobrir o tratamento\npersonalizado ideal para voce!',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: 280,
              child: GradientButton(
                label: 'Agendar avaliacao gratuita',
                onPressed: onSchedulePressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StarsRow extends StatelessWidget {
  const _StarsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.star, color: AppColors.accent, size: 22),
        Icon(Icons.star, color: AppColors.accent, size: 22),
        Icon(Icons.star, color: AppColors.accent, size: 22),
        Icon(Icons.star, color: AppColors.accent, size: 22),
        Icon(Icons.star, color: AppColors.accent, size: 22),
      ],
    );
  }
}
