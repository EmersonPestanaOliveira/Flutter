import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_colors.dart';
import '../../../../../core/design_system/app_spacing.dart';

class RegisterTextField extends StatelessWidget {
  const RegisterTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.helpIcon = false,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool helpIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.headerBlue,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (helpIcon) ...[
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.help_outline,
                color: AppColors.headerBlue,
                size: 22,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: const Color(0xFFF0F1F4),
            suffixIcon: suffixIcon,
            hintStyle: const TextStyle(color: Color(0xFFC4C7CF)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.neutral300),
            ),
          ),
        ),
      ],
    );
  }
}
