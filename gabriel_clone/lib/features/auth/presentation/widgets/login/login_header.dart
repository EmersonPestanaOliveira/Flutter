import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_colors.dart';
import 'login_colors.dart';
import 'login_metrics.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({required this.metrics, super.key});

  final LoginMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo_vazado.webp',
          height: metrics.logoHeight,
          fit: BoxFit.contain,
        ),
        SizedBox(height: metrics.headerGap * 1.7),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              color: AppColors.neutral0,
              fontSize: metrics.titleSize,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
            children: const [
              TextSpan(text: 'Bem-vindo '),
              TextSpan(
                text: 'de volta!',
                style: TextStyle(color: LoginColors.green),
              ),
            ],
          ),
        ),
        SizedBox(height: metrics.headerGap),
        Text(
          'Acesse sua conta e fique\nsempre protegido.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xCCFFFFFF),
            fontSize: metrics.subtitleSize,
            height: 1.28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
