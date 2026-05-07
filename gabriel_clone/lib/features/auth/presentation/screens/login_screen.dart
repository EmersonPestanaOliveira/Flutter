import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/backend_error_mapper.dart';
import '../../../../core/router/app_routes.dart';
import '../widgets/login/login_actions.dart';
import '../widgets/login/login_background.dart';
import '../widgets/login/login_form_fields.dart';
import '../widgets/login/login_header.dart';
import '../widgets/login/login_metrics.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = sl<AuthService>();

  final _isPasswordVisible = ValueNotifier<bool>(false);
  final _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isPasswordVisible.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF001510),
        resizeToAvoidBottomInset: false,
        body: LoginBackground(
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final metrics = LoginMetrics.fromHeight(
                  constraints.maxHeight,
                );

                return Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      metrics.horizontalPadding,
                      metrics.topPadding,
                      metrics.horizontalPadding,
                      metrics.bottomPadding,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SizedBox(
                          width: constraints.maxWidth
                              .clamp(0.0, 440.0)
                              .toDouble(),
                          height: constraints.maxHeight,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                LoginHeader(metrics: metrics),
                                ValueListenableBuilder<bool>(
                                  valueListenable: _isPasswordVisible,
                                  builder: (context, isPasswordVisible, _) {
                                    return ValueListenableBuilder<bool>(
                                      valueListenable: _isLoading,
                                      builder: (context, isLoading, _) {
                                        return LoginFormFields(
                                          metrics: metrics,
                                          emailController: _emailController,
                                          passwordController:
                                              _passwordController,
                                          isPasswordVisible: isPasswordVisible,
                                          isLoading: isLoading,
                                          onTogglePassword:
                                              _togglePasswordVisibility,
                                          onResetPassword: _resetPassword,
                                        );
                                      },
                                    );
                                  },
                                ),
                                ValueListenableBuilder<bool>(
                                  valueListenable: _isLoading,
                                  builder: (context, isLoading, _) {
                                    return LoginActions(
                                      metrics: metrics,
                                      isLoading: isLoading,
                                      onSignIn: _signInWithEmail,
                                      onGoogleSignIn: _signInWithGoogle,
                                      onRegister: () =>
                                          context.push(AppRoutes.register),
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
              },
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _runAuthAction(
      () => _authService.signInWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    await _runAuthAction(_authService.signInWithGoogle);
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showMessage('Informe um e-mail válido.');
      return;
    }

    await _runAuthAction(() async {
      await _authService.sendPasswordResetEmail(email: email);
      if (mounted) {
        _showMessage('Enviamos as instruções para seu e-mail.');
      }
    });
  }

  Future<void> _runAuthAction(Future<void> Function() action) async {
    _isLoading.value = true;
    try {
      await action();
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
