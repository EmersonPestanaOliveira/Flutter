import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/widgets/buttons/gradient_button.dart';
import '../../../../design_system/widgets/inputs/app_text_field.dart';
import '../../data/auth_service.dart';
import '../widgets/auth_error_mapper.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      await AuthService.instance.sendPasswordResetEmail(_emailController.text);
      if (mounted) setState(() => _sent = true);
    } catch (e) {
      _showError(mapAuthError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash_background.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.brandBlue,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppSpacing.xl),
                          Icon(
                            _sent
                                ? Icons.mark_email_read_outlined
                                : Icons.lock_reset,
                            size: 64,
                            color: AppColors.brandPurple,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            _sent ? 'E-mail enviado!' : 'Recuperar senha',
                            textAlign: TextAlign.center,
                            style: AppTypography.displayMedium.copyWith(
                              color: AppColors.brandBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            _sent
                                ? 'Enviamos um link de recuperacao para\n${_emailController.text.trim()}'
                                : 'Informe seu e-mail e enviaremos um link\npara voce redefinir sua senha.',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          if (!_sent) ...[
                            AppTextField(
                              hint: 'Seu e-mail',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.mail_outline,
                              textInputAction: TextInputAction.done,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Informe seu e-mail';
                                }
                                if (!v.contains('@')) return 'E-mail invalido';
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            GradientButton(
                              label: _loading ? 'Enviando...' : 'Enviar link',
                              onPressed: _loading ? null : _handleSend,
                            ),
                          ] else ...[
                            GradientButton(
                              label: 'Voltar ao login',
                              onPressed: () => context.pop(),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _sent = false;
                                  _emailController.clear();
                                });
                              },
                              child: Text(
                                'Enviar para outro e-mail',
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.brandPurple,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}