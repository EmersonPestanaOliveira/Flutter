import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_colors.dart';

class RegisterTermsCheckbox extends StatelessWidget {
  const RegisterTermsCheckbox({
    required this.value,
    required this.isLoading,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final bool isLoading;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: isLoading ? null : (value) => onChanged(value ?? false),
          activeColor: const Color(0xFF00C982),
          side: const BorderSide(color: Color(0xFF00C982), width: 2),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Wrap(
              children: [
                Text('Aceito e concordo com os ', style: _termsStyle(context)),
                Text('Termos de Uso', style: _termsLinkStyle(context)),
                Text(' e ', style: _termsStyle(context)),
                Text(
                  'Política de Privacidade.',
                  style: _termsLinkStyle(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TextStyle? _termsStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: AppColors.neutral600,
      fontSize: 18,
      height: 1.35,
    );
  }

  TextStyle? _termsLinkStyle(BuildContext context) {
    return _termsStyle(context)?.copyWith(
      color: const Color(0xFF00A878),
      decoration: TextDecoration.underline,
      decorationColor: const Color(0xFF00A878),
    );
  }
}
