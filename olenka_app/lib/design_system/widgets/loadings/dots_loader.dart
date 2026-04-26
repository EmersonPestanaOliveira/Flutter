import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';

/// Indicador de loading com 3 pontos pulsando em sequencia.
/// Usado na splash e em estados de carregamento da marca.
class DotsLoader extends StatefulWidget {
  const DotsLoader({
    this.size = 10,
    this.spacing = 12,
    super.key,
  });

  final double size;
  final double spacing;

  @override
  State<DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<DotsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Cores alinhadas ao logo: azul profundo, rosa, rose claro.
  static const _colors = [
    Color(0xFF1E3A8A),
    Color(0xFFD98AA0),
    Color(0xFFE8C6C6),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // Cada dot comeca em um offset diferente da animacao.
            final phase = (_controller.value - i * 0.2) % 1.0;
            final scale = 0.7 + 0.3 * _bump(phase);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: _colors[i],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  /// Curva que sobe rapido e volta suave — cria o efeito de pulso.
  double _bump(double t) {
    if (t < 0) return 0;
    if (t > 0.5) return 0;
    return (1 - (2 * t - 0.5).abs() * 2).clamp(0.0, 1.0);
  }
}
