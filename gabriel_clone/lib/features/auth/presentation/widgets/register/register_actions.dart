import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_colors.dart';
import '../../../../../core/design_system/app_spacing.dart';

class RegisterActions extends StatelessWidget {
  const RegisterActions({
    required this.isLoading,
    required this.onRegister,
    required this.onBackToLogin,
    super.key,
  });

  final bool isLoading;
  final VoidCallback onRegister;
  final VoidCallback onBackToLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: isLoading ? null : onRegister,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(64),
            backgroundColor: const Color(0xFF00C982),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isLoading
              ? const SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.neutral0,
                  ),
                )
              : const Text(
                  'Próximo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextButton(
          onPressed: isLoading ? null : onBackToLogin,
          child: const Text('Já sou cadastrado. Entrar'),
        ),
      ],
    );
  }
}
