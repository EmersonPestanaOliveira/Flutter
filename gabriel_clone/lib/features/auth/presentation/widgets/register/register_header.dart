import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_colors.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({
    required this.isLoading,
    required this.onBack,
    super.key,
  });

  final bool isLoading;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: isLoading ? null : onBack,
          icon: const Icon(
            Icons.chevron_left,
            color: Color(0xFF00C982),
            size: 42,
          ),
        ),
        Expanded(
          child: Text(
            'Cadastro',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.headerBlue,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 58),
      ],
    );
  }
}
