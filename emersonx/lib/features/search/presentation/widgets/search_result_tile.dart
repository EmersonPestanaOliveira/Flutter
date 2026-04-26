import 'package:flutter/material.dart';
import '../../domain/entities/search_result.dart';
import '../../../../design_system/tokens/tokens.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
    required this.result,
    required this.query,
    required this.onTap,
  });

  final SearchResult result;
  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            // Icone colorido
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: result.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(result.icon, color: result.color, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HighlightText(
                    text: result.title,
                    query: query,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: isDark ? AppColors.white : AppColors.neutral900,
                    ),
                    highlightColor: result.color,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    result.breadcrumb,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isDark ? AppColors.neutral400 : AppColors.neutral600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: isDark ? AppColors.neutral400 : AppColors.neutral400,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget que destaca a query no texto
class _HighlightText extends StatelessWidget {
  const _HighlightText({
    required this.text,
    required this.query,
    required this.style,
    required this.highlightColor,
  });

  final String text;
  final String query;
  final TextStyle style;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) return Text(text, style: style);

    final lower = text.toLowerCase();
    final q = query.toLowerCase();
    final idx = lower.indexOf(q);

    if (idx == -1) return Text(text, style: style);

    return RichText(
      text: TextSpan(
        children: [
          if (idx > 0)
            TextSpan(text: text.substring(0, idx), style: style),
          TextSpan(
            text: text.substring(idx, idx + q.length),
            style: style.copyWith(
              color: highlightColor,
              fontWeight: FontWeight.w700,
              backgroundColor: highlightColor.withOpacity(0.1),
            ),
          ),
          TextSpan(
            text: text.substring(idx + q.length),
            style: style,
          ),
        ],
      ),
    );
  }
}