import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:splash_degrade/login_page.dart';
import 'package:splash_degrade/logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Timer de 3s → LoginPage (sem flicker).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final textScaler = mq.textScaler;
    final isPortrait = mq.orientation == Orientation.portrait;
    final theme = Theme.of(context);

    // Paletas do degradê por tema
    final lightGradient = const [Color(0xFF0A84FF), Color(0xFF5AC8FA)];
    final darkGradient = const [Color(0xFF0B132B), Color(0xFF1C2541)];
    final isDark = theme.brightness == Brightness.dark;

    // Contraste AA simples: no claro, texto/ícone escuros; no escuro, claros.
    final onGradient = isDark
        ? Colors.white.withOpacity(0.90)
        : Colors.black.withOpacity(0.87);

    return Scaffold(
      body: Container(
        // Degradê cobre 100% da tela em qualquer orientação.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark ? darkGradient : lightGradient,
            begin: isPortrait ? Alignment.topCenter : Alignment.topLeft,
            end: isPortrait ? Alignment.bottomCenter : Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxW = constraints.maxWidth;
              final maxH = constraints.maxHeight;

              // Breakpoints
              final isCompact = maxW <= 360; // ≤ 360 px: reduzir logo/fonte
              final isUltraWide = maxW >= 900; // ≥ 900 px: letterbox (600–720)

              // Letterbox: limitar a coluna central
              final letterboxMin = 600.0;
              final letterboxMax = 720.0;
              final columnMaxWidth = isUltraWide
                  ? math.min(letterboxMax, math.max(letterboxMin, maxW * 0.6))
                  : double.infinity;

              // Largura do logo = min(240, maxWidth * 0.5)
              double logoTargetW = math.min(240.0, maxW * 0.5);
              if (isCompact)
                logoTargetW *= 0.85; // redução em telas muito estreitas

              // Espaços verticais proporcionais (3–6% do maxHeight)
              double vSpace = (maxH * 0.04).clamp(maxH * 0.03, maxH * 0.06);

              // Tamanho da fonte proporcional + clamps
              double baseFont = (maxW * 0.055).clamp(14.0, 22.0);
              if (isCompact) baseFont = (baseFont * 0.92).clamp(12.0, 20.0);

              // Card translúcido opcional (true para demonstrar).
              const useTranslucentCard = true;
              final cardColor = isDark
                  ? Colors.white.withOpacity(0.12)
                  : Colors.black.withOpacity(0.08);

              final content = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LOGO: FittedBox + ConstrainedBox
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: logoTargetW),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: useTranslucentCard
                          ? Card(
                              color: cardColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Logo(onColor: onGradient),
                              ),
                            )
                          // ignore: dead_code
                          : Logo(onColor: onGradient),
                    ),
                  ),
                  SizedBox(height: vSpace),
                  // TEXTO "Carregando…"
                  // Garantir que não quebre e respeitar TextScale.
                  Text(
                    'Carregando…',
                    textScaler: textScaler,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 1, // evita quebra visual
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: onGradient.withOpacity(0.80), // opacidade ~80%
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      fontSize: baseFont,
                    ),
                  ),
                  SizedBox(height: vSpace),
                ],
              );

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // Letterbox opcional nos ≥900px
                    maxWidth: columnMaxWidth,
                  ),
                  child: Padding(
                    // Pequeno padding lateral para respirabilidade.
                    padding: EdgeInsets.symmetric(
                      horizontal: (maxW * 0.06).clamp(16.0, 32.0),
                    ),
                    child: content,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
