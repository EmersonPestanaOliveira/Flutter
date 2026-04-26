import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';

/// Card de depoimento de cliente.
class TestimonialCard extends StatelessWidget {
  const TestimonialCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandPink.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Depoimentos dos clientes',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.brandBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text(
                      'Ver todos',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.brandPurple,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.brandPurple,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Fernanda',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.brandBlue,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              ...List.generate(
                5,
                (_) => const Icon(
                  Icons.star,
                  color: AppColors.accent,
                  size: 16,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '(45)',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Otima clinica! Se voce busca atendimento personalizado e '
            'tratamentos esteticos de alto nivel e confianca, esse e o '
            'lugar certo. Fiquei muito satisfeita com os resultados e '
            'atendimento impecavel. Super indico!',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}