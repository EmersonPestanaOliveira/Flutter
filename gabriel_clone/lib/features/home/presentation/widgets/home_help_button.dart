import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/components/app_button.dart';

class HomeHelpButton extends StatelessWidget {
  const HomeHelpButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 340),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width < 430 ? 184 : 340,
        height: 56,
        child: AppButton(
          label: 'Pedir Ajuda',
          leadingIcon: Icons.phone_in_talk_outlined,
          backgroundColor: AppColors.accentRed,
          borderRadius: 16,
          iconSize: 26,
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.neutral0,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
