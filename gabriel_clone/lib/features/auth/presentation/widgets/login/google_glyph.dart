import 'package:flutter/material.dart';

class GoogleGlyph extends StatelessWidget {
  const GoogleGlyph({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 24,
      child: CustomPaint(painter: _GoogleGlyphPainter()),
    );
  }
}

class _GoogleGlyphPainter extends CustomPainter {
  const _GoogleGlyphPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.16;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: size.width * 0.32,
    );

    Paint arcPaint(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    canvas
      ..drawArc(rect, -0.16, 1.34, false, arcPaint(const Color(0xFF4285F4)))
      ..drawArc(rect, 1.18, 1.34, false, arcPaint(const Color(0xFF34A853)))
      ..drawArc(rect, 2.52, 0.92, false, arcPaint(const Color(0xFFFBBC05)))
      ..drawArc(rect, 3.44, 1.54, false, arcPaint(const Color(0xFFEA4335)));

    final center = size.center(Offset.zero);
    final bluePaint = arcPaint(const Color(0xFF4285F4));
    canvas
      ..drawLine(
        Offset(center.dx, center.dy),
        Offset(size.width * 0.82, center.dy),
        bluePaint,
      )
      ..drawLine(
        Offset(size.width * 0.68, center.dy),
        Offset(size.width * 0.68, size.height * 0.62),
        bluePaint,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
