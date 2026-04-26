import 'package:flutter/material.dart';

class GoogleIcon extends StatelessWidget {
  const GoogleIcon({this.size = 24, super.key});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 48;
    final blue = Paint()..color = const Color(0xFF4285F4);
    final green = Paint()..color = const Color(0xFF34A853);
    final yellow = Paint()..color = const Color(0xFFFBBC05);
    final red = Paint()..color = const Color(0xFFEA4335);

    final pathBlue = Path()
      ..moveTo(46.9 * scale, 24.5 * scale)
      ..cubicTo(46.9 * scale, 22.8 * scale, 46.7 * scale, 21.2 * scale,
          46.5 * scale, 19.7 * scale)
      ..lineTo(24 * scale, 19.7 * scale)
      ..lineTo(24 * scale, 28.8 * scale)
      ..lineTo(36.9 * scale, 28.8 * scale)
      ..cubicTo(36.4 * scale, 31.7 * scale, 34.7 * scale, 34.2 * scale,
          32.1 * scale, 35.9 * scale)
      ..lineTo(32.1 * scale, 41.9 * scale)
      ..lineTo(39.9 * scale, 41.9 * scale)
      ..cubicTo(44.5 * scale, 37.7 * scale, 46.9 * scale, 31.6 * scale,
          46.9 * scale, 24.5 * scale)
      ..close();
    canvas.drawPath(pathBlue, blue);

    final pathGreen = Path()
      ..moveTo(24 * scale, 48 * scale)
      ..cubicTo(30.5 * scale, 48 * scale, 35.9 * scale, 45.9 * scale,
          39.9 * scale, 41.9 * scale)
      ..lineTo(32.1 * scale, 35.9 * scale)
      ..cubicTo(29.9 * scale, 37.4 * scale, 27.2 * scale, 38.3 * scale,
          24 * scale, 38.3 * scale)
      ..cubicTo(17.7 * scale, 38.3 * scale, 12.4 * scale, 34 * scale,
          10.5 * scale, 28.3 * scale)
      ..lineTo(2.5 * scale, 28.3 * scale)
      ..lineTo(2.5 * scale, 34.4 * scale)
      ..cubicTo(6.5 * scale, 42.3 * scale, 14.6 * scale, 48 * scale,
          24 * scale, 48 * scale)
      ..close();
    canvas.drawPath(pathGreen, green);

    final pathYellow = Path()
      ..moveTo(10.5 * scale, 28.3 * scale)
      ..cubicTo(10 * scale, 26.8 * scale, 9.7 * scale, 25.2 * scale,
          9.7 * scale, 23.5 * scale)
      ..cubicTo(9.7 * scale, 21.8 * scale, 10 * scale, 20.2 * scale,
          10.5 * scale, 18.7 * scale)
      ..lineTo(10.5 * scale, 12.6 * scale)
      ..lineTo(2.5 * scale, 12.6 * scale)
      ..cubicTo(0.9 * scale, 15.8 * scale, 0 * scale, 19.5 * scale,
          0 * scale, 23.5 * scale)
      ..cubicTo(0 * scale, 27.5 * scale, 0.9 * scale, 31.2 * scale,
          2.5 * scale, 34.4 * scale)
      ..lineTo(10.5 * scale, 28.3 * scale)
      ..close();
    canvas.drawPath(pathYellow, yellow);

    final pathRed = Path()
      ..moveTo(24 * scale, 9.5 * scale)
      ..cubicTo(27.5 * scale, 9.5 * scale, 30.7 * scale, 10.7 * scale,
          33.2 * scale, 13.1 * scale)
      ..lineTo(40 * scale, 6.3 * scale)
      ..cubicTo(35.9 * scale, 2.4 * scale, 30.5 * scale, 0 * scale,
          24 * scale, 0 * scale)
      ..cubicTo(14.6 * scale, 0 * scale, 6.5 * scale, 5.7 * scale,
          2.5 * scale, 13.6 * scale)
      ..lineTo(10.5 * scale, 19.7 * scale)
      ..cubicTo(12.4 * scale, 14 * scale, 17.7 * scale, 9.5 * scale,
          24 * scale, 9.5 * scale)
      ..close();
    canvas.drawPath(pathRed, red);
  }

  @override
  bool shouldRepaint(_) => false;
}