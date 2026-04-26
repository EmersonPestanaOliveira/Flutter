import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';

class Treatment {
  const Treatment({
    required this.name,
    required this.imageUrl,
    this.fallbackIcon = Icons.spa,
  });

  final String name;

  /// URL remota ou caminho do asset.
  /// Se comecar com http/https usa Image.network,
  /// senao assume Image.asset.
  final String imageUrl;
  final IconData fallbackIcon;
}

/// Carrossel horizontal de tratamentos em destaque.
/// Cards responsivos (usam fracao da largura da tela), imagem
/// preenche todo o topo do card com BoxFit.cover.
class FeaturedTreatments extends StatelessWidget {
  const FeaturedTreatments({
    this.onTreatmentTap,
    this.onSeeAllTap,
    super.key,
  });

  final ValueChanged<Treatment>? onTreatmentTap;
  final VoidCallback? onSeeAllTap;

  static const _items = [
    Treatment(
      name: 'Harmonizacao Facial',
      imageUrl:
          'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=400&q=80',
      fallbackIcon: Icons.face_3,
    ),
    Treatment(
      name: 'PEIM',
      imageUrl:
          'https://images.unsplash.com/photo-1618944913480-b67ee15bcde2?w=400&q=80',
      fallbackIcon: Icons.healing,
    ),
    Treatment(
      name: 'Bioestimuladores de Colageno',
      imageUrl:
          'https://images.unsplash.com/photo-1596704017254-9b121068fb31?w=400&q=80',
      fallbackIcon: Icons.biotech,
    ),
    Treatment(
      name: 'Massagem Relaxante',
      imageUrl:
          'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=400&q=80',
      fallbackIcon: Icons.spa,
    ),
    Treatment(
      name: 'Botox',
      imageUrl:
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400&q=80',
      fallbackIcon: Icons.auto_fix_high,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Card ocupa ~45% da largura da tela, no maximo 180px.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = (screenWidth * 0.45).clamp(140.0, 180.0);
    final cardHeight = cardWidth * 1.35;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Tratamentos em destaque',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.brandBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: onSeeAllTap ?? () {},
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
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: _items.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (_, i) => _TreatmentCard(
              treatment: _items[i],
              width: cardWidth,
              onTap: () => onTreatmentTap?.call(_items[i]),
            ),
          ),
        ),
      ],
    );
  }
}

class _TreatmentCard extends StatelessWidget {
  const _TreatmentCard({
    required this.treatment,
    required this.width,
    required this.onTap,
  });

  final Treatment treatment;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandPink.withValues(alpha: 0.15),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagem ocupa a maior parte do card.
            Expanded(
              flex: 4,
              child: _TreatmentImage(treatment: treatment),
            ),
            // Nome do tratamento em uma faixa branca embaixo.
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    treatment.name,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.brandBlue,
                      fontSize: 13,
                      height: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TreatmentImage extends StatelessWidget {
  const _TreatmentImage({required this.treatment});

  final Treatment treatment;

  @override
  Widget build(BuildContext context) {
    final isNetwork = treatment.imageUrl.startsWith('http');

    final placeholder = Container(
      color: AppColors.primaryLight.withValues(alpha: 0.5),
      child: Icon(
        treatment.fallbackIcon,
        size: 48,
        color: AppColors.brandPink.withValues(alpha: 0.7),
      ),
    );

    if (isNetwork) {
      return Image.network(
        treatment.imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: AppColors.primaryLight.withValues(alpha: 0.3),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(AppColors.brandPink),
                ),
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) => placeholder,
      );
    }

    return Image.asset(
      treatment.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}
