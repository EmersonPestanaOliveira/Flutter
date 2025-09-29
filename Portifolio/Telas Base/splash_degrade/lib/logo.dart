import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, required this.onColor});
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    // Se o seu logo já tem cor própria, você pode remover o ColorFiltered.
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        Colors.transparent,
        BlendMode.srcOver,
      ),
      child: Image.asset(
        'assets/logo.png',
        fit: BoxFit.contain,
        // Dica: use imagens 2x/3x em assets para nitidez.
        // Ex.: assets/logo.png, assets/2.0x/logo.png, assets/3.0x/logo.png
      ),
    );
  }
}
