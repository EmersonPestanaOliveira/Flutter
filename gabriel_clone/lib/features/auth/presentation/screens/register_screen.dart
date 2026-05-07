import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/backend_error_mapper.dart';
import '../widgets/register/register_actions.dart';
import '../widgets/register/register_form_fields.dart';
import '../widgets/register/register_header.dart';
import '../widgets/register/register_terms_checkbox.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = sl<AuthService>();

  final _acceptedTerms = ValueNotifier<bool>(false);
  final _isPasswordVisible = ValueNotifier<bool>(false);
  final _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _acceptedTerms.dispose();
    _isPasswordVisible.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral0,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: _isLoading,
                      builder: (context, isLoading, _) {
                        return RegisterHeader(
                          isLoading: isLoading,
                          onBack: () => context.pop(),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    ValueListenableBuilder<bool>(
                      valueListenable: _isPasswordVisible,
                      builder: (context, isPasswordVisible, _) {
                        return RegisterFormFields(
                          nameController: _nameController,
                          birthDateController: _birthDateController,
                          cpfController: _cpfController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          isPasswordVisible: isPasswordVisible,
                          onTogglePassword: _togglePasswordVisibility,
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    ValueListenableBuilder<bool>(
                      valueListenable: _acceptedTerms,
                      builder: (context, acceptedTerms, _) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: _isLoading,
                          builder: (context, isLoading, _) {
                            return RegisterTermsCheckbox(
                              value: acceptedTerms,
                              isLoading: isLoading,
                              onChanged: _setAcceptedTerms,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    ValueListenableBuilder<bool>(
                      valueListenable: _isLoading,
                      builder: (context, isLoading, _) {
                        return RegisterActions(
                          isLoading: isLoading,
                          onRegister: _register,
                          onBackToLogin: () => context.pop(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  void _setAcceptedTerms(bool value) {
    _acceptedTerms.value = value;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptedTerms.value) {
      _showMessage('Aceite os termos para continuar.');
      return;
    }

    _isLoading.value = true;
    try {
      await _authService.registerWithEmail(
        name: _nameController.text,
        birthDate: _birthDateController.text,
        cpf: _cpfController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (error) {
      if (mounted) {
        _showMessage(BackendErrorMapper.message(error));
      }
    } finally {
      if (mounted) {
        _isLoading.value = false;
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
