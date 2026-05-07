import 'package:flutter/material.dart';

import '../../validators/auth_validators.dart';
import 'login_colors.dart';
import 'login_input.dart';
import 'login_metrics.dart';

class LoginFormFields extends StatelessWidget {
  const LoginFormFields({
    required this.metrics,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onResetPassword,
    super.key,
  });

  final LoginMetrics metrics;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onResetPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LoginInput(
          controller: emailController,
          hintText: 'E-mail',
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          validator: AuthValidators.requiredEmail,
          height: metrics.fieldHeight,
        ),
        SizedBox(height: metrics.fieldGap),
        LoginInput(
          controller: passwordController,
          hintText: 'Senha',
          icon: Icons.lock_outline,
          obscureText: !isPasswordVisible,
          validator: AuthValidators.requiredPassword,
          height: metrics.fieldHeight,
          suffixIcon: IconButton(
            tooltip: isPasswordVisible ? 'Ocultar senha' : 'Mostrar senha',
            onPressed: onTogglePassword,
            icon: Icon(
              isPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: LoginColors.icon,
              size: 26,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: isLoading ? null : onResetPassword,
            style: TextButton.styleFrom(
              foregroundColor: LoginColors.green,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            ),
            child: const Text(
              'Esqueci minha senha',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}
