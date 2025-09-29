import 'package:flutter/material.dart';
import 'package:splash_basic/home_page.dart';

/// SplashPage
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Navegação após ~2.4s, sem flicker (transição zero).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 2400), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomePage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const fbBlue = Color(0xFF1877F2);

    return Scaffold(
      backgroundColor: fbBlue,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            final maxH = constraints.maxHeight;

            // Limite de largura do conteúdo em landscape / telas grandes
            const maxContentWidth = 600.0;

            // Tipografia: base relativa à largura, com clamp superior 48.
            final baseFont = (maxW * 0.08).clamp(
              16.0,
              48.0,
            ); // evita texto gigante/pequeno
            // Respeitar escalonamento do usuário (MediaQuery.textScaler)
            final textScaler = MediaQuery.textScalerOf(context);

            // Padding adaptativo (clamp para não esmagar nas menores telas)
            final horizontalPadding = (maxW * 0.08).clamp(
              16.0,
              48.0,
            ); // responsivo e seguro

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: maxContentWidth),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: SizedBox(
                    width: double.infinity,
                    height: maxH,
                    child: FittedBox(
                      // Mantém central e visível inclusive em landscape
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        'Facebook',
                        textScaler: textScaler, // respeita acessibilidade
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: baseFont,
                          letterSpacing: 0.5,
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
    );
  }
}
