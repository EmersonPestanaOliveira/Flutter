import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_colors.dart';
import '../../../../../core/design_system/app_spacing.dart';
import 'divider_label.dart';
import 'google_glyph.dart';
import 'login_colors.dart';
import 'login_metrics.dart';

class LoginActions extends StatelessWidget {
  const LoginActions({
    required this.metrics,
    required this.isLoading,
    required this.onSignIn,
    required this.onGoogleSignIn,
    required this.onRegister,
    super.key,
  });

  final LoginMetrics metrics;
  final bool isLoading;
  final VoidCallback onSignIn;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: metrics.primaryButtonHeight,
          child: FilledButton(
            onPressed: isLoading ? null : onSignIn,
            style: FilledButton.styleFrom(
              backgroundColor: LoginColors.green,
              foregroundColor: const Color(0xFF001510),
              disabledBackgroundColor: LoginColors.green.withValues(
                alpha: 0.55,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? const _ButtonLoader(color: Color(0xFF001510))
                : const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
          ),
        ),
        SizedBox(height: metrics.actionsGap),
        const DividerLabel(),
        SizedBox(height: metrics.actionsGap),
        SizedBox(
          height: metrics.googleButtonHeight,
          child: FilledButton(
            onPressed: isLoading ? null : onGoogleSignIn,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.neutral0,
              foregroundColor: AppColors.neutral900,
              disabledBackgroundColor: AppColors.neutral0.withValues(
                alpha: 0.7,
              ),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const _GoogleButtonContent(),
          ),
        ),
        SizedBox(height: metrics.actionsGap),
        _RegisterPrompt(isLoading: isLoading, onRegister: onRegister),
      ],
    );
  }
}

class _ButtonLoader extends StatelessWidget {
  const _ButtonLoader({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 22,
      child: CircularProgressIndicator(strokeWidth: 2, color: color),
    );
  }
}

class _GoogleButtonContent extends StatelessWidget {
  const _GoogleButtonContent();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GoogleGlyph(),
        SizedBox(width: AppSpacing.lg),
        Flexible(
          child: Text(
            'Entrar com Google',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _RegisterPrompt extends StatelessWidget {
  const _RegisterPrompt({required this.isLoading, required this.onRegister});

  final bool isLoading;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          'Não tem uma conta? ',
          style: TextStyle(
            color: Color(0xCCFFFFFF),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: isLoading ? null : onRegister,
          child: const Text(
            'Cadastre-se',
            style: TextStyle(
              color: LoginColors.green,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
