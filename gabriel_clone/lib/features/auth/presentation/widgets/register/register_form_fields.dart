import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_spacing.dart';
import '../../validators/auth_validators.dart';
import 'register_text_field.dart';

class RegisterFormFields extends StatelessWidget {
  const RegisterFormFields({
    required this.nameController,
    required this.birthDateController,
    required this.cpfController,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onTogglePassword,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController birthDateController;
  final TextEditingController cpfController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final VoidCallback onTogglePassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RegisterTextField(
          controller: nameController,
          label: 'Nome Completo',
          hintText: 'Ex: Fernanda Aguiar',
          validator: AuthValidators.requiredText,
        ),
        const SizedBox(height: AppSpacing.xl),
        RegisterTextField(
          controller: birthDateController,
          label: 'Data de Nascimento',
          hintText: 'dd/mm/aaaa',
          keyboardType: TextInputType.datetime,
          validator: AuthValidators.requiredText,
        ),
        const SizedBox(height: AppSpacing.xl),
        RegisterTextField(
          controller: cpfController,
          label: 'CPF',
          hintText: '000.000.000-00',
          keyboardType: TextInputType.number,
          validator: AuthValidators.requiredText,
          helpIcon: true,
        ),
        const SizedBox(height: AppSpacing.xl),
        RegisterTextField(
          controller: emailController,
          label: 'E-mail',
          hintText: 'e-mail@email.com',
          keyboardType: TextInputType.emailAddress,
          validator: AuthValidators.requiredEmail,
          helpIcon: true,
        ),
        const SizedBox(height: AppSpacing.xl),
        RegisterTextField(
          controller: passwordController,
          label: 'Senha',
          hintText: 'Mínimo de 6 caracteres',
          obscureText: !isPasswordVisible,
          validator: AuthValidators.requiredPassword,
          suffixIcon: IconButton(
            onPressed: onTogglePassword,
            icon: Icon(
              isPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
      ],
    );
  }
}
