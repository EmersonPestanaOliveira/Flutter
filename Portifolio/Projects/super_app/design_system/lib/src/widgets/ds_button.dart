import 'package:flutter/material.dart';
import '../tokens/brand_theme.dart';

class DsButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const DsButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>()!;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: brand.primary,
        foregroundColor: brand.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: brand.radiusMd),
        padding: EdgeInsets.all(brand.spacingMd),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
