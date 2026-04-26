import 'package:flutter/material.dart';
import '../../../../design_system/tokens/tokens.dart';
import '../../domain/entities/feature_module.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard({
    super.key,
    required this.module,
    required this.onTap,
  });

  final FeatureModule module;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.dark700 : AppColors.white;
    final borderColor = isDark ? AppColors.dark600 : AppColors.neutral200;

    return GestureDetector(
      onTap: module.isReady ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icone
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: module.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  module.icon,
                  color: module.color,
                  size: 22,
                ),
              ),
              const Spacer(),
              // Titulo
              Text(
                module.title,
                style: AppTextStyles.labelLarge.copyWith(
                  color: isDark ? AppColors.white : AppColors.neutral900,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xxs),
              // Subtitulo
              Text(
                module.subtitle,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isDark ? AppColors.neutral400 : AppColors.neutral600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              // Badge de status
              _StatusBadge(isReady: module.isReady),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isReady});
  final bool isReady;

  @override
  Widget build(BuildContext context) {
    final color = isReady ? AppColors.success : AppColors.neutral400;
    final label = isReady ? 'Pronto' : 'Em breve';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: color),
        ),
      ],
    );
  }
}