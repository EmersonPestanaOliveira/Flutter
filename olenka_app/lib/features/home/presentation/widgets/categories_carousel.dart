import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';

class Category {
  const Category(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Carrossel horizontal de categorias de servicos.
/// Largura dos itens fixa em px, container cresce no eixo disponivel,
/// ListView horizontal garante scroll em qualquer device.
class CategoriesCarousel extends StatelessWidget {
  const CategoriesCarousel({
    this.onCategoryTap,
    this.onMoreTap,
    super.key,
  });

  final ValueChanged<Category>? onCategoryTap;
  final VoidCallback? onMoreTap;

  static const _items = [
    Category('Faciais', Icons.face_retouching_natural),
    Category('Corporais', Icons.accessibility_new),
    Category('Lasers', Icons.flash_on),
    Category('Tecnologia', Icons.auto_awesome),
    Category('Massagens', Icons.spa),
    Category('Spa', Icons.hot_tub),
    Category('Depilacao', Icons.waves),
    Category('Estetica', Icons.auto_fix_high),
  ];

  static const double _itemWidth = 76;
  static const double _itemHeight = 96;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _itemHeight + AppSpacing.md * 2,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandPink.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        itemCount: _items.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (_, i) {
          if (i == _items.length) {
            return _MoreButton(width: _itemWidth, onTap: onMoreTap ?? () {});
          }
          final c = _items[i];
          return _CategoryItem(
            category: c,
            width: _itemWidth,
            onTap: () => onCategoryTap?.call(c),
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.category,
    required this.width,
    required this.onTap,
  });

  final Category category;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, color: AppColors.brandPink, size: 34),
            const SizedBox(height: AppSpacing.xs),
            Text(
              category.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({required this.width, required this.onTap});

  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 34,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.brandPink,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Ver mais',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
