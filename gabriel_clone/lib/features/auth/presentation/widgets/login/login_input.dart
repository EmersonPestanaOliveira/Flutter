import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_colors.dart';
import '../../../../../core/design_system/app_spacing.dart';
import 'login_colors.dart';

class LoginInput extends StatelessWidget {
  const LoginInput({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.height,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: const TextStyle(
          color: AppColors.neutral0,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        cursorColor: LoginColors.green,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0x99FFFFFF),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 20, right: 12),
            child: Icon(icon, color: LoginColors.icon, size: 28),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 66),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: const Color(0x3D001510),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
          ),
          border: _inputBorder(LoginColors.border),
          enabledBorder: _inputBorder(LoginColors.border),
          focusedBorder: _inputBorder(LoginColors.green, width: 1.5),
          errorBorder: _inputBorder(AppColors.accentRed),
          focusedErrorBorder: _inputBorder(AppColors.accentRed, width: 1.5),
          errorStyle: const TextStyle(height: 0, fontSize: 0),
        ),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
