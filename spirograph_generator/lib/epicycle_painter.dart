import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:spirograph_generator/epicycle.dart';
import 'package:spirograph_generator/stroke_style.dart'; // <- usa o mesmo StrokeMode

class EpicyclePainter extends CustomPainter {
  EpicyclePainter({
    required this.epicycles,
    required this.turns,
    required this.progress,
    this.showPen = false,

    // estilo
    this.strokeColor = const Color(0xFFF48FB1),
    this.strokeWidth = 1.6,
    this.shadow = false,
    this.shadowSigma = 8.0,
    this.mode = StrokeMode.solid,
  });

  final List<Epicycle> epicycles;
  final double turns;
  final double progress;
  final bool showPen;

  final Color strokeColor;
  final double strokeWidth;
  final bool shadow;
  final double shadowSigma;
  final StrokeMode mode;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas.translate(center.dx, center.dy);

    final paintPath = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (mode == StrokeMode.solid) {
      paintPath.color = strokeColor;
    } else {
      paintPath.color = Colors.white;
    }

    if (shadow) {
      paintPath.maskFilter = MaskFilter.blur(BlurStyle.normal, shadowSigma);
    }

    const steps = 7000;
    final totalT = 2 * math.pi * turns;
    final maxI = (steps * progress).clamp(0, steps).toInt();

    Offset eval(double t) {
      double x = 0, y = 0;
      for (final e in epicycles) {
        final dir = e.direction.toDouble();
        x += e.length * math.cos(dir * e.speed * t + e.phase);
        y += e.length * math.sin(dir * e.speed * t + e.phase);
      }
      return Offset(x, y);
    }

    final path = Path();
    Offset? last;
    for (int i = 0; i <= maxI; i++) {
      final t = totalT * (i / steps);
      final p = eval(t);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
      last = p;
    }

    if (mode == StrokeMode.solid) {
      canvas.drawPath(path, paintPath);
    } else {
      final metrics = path.computeMetrics();
      for (final m in metrics) {
        const segs = 180;
        for (int i = 0; i < segs; i++) {
          final t0 = m.length * (i / segs);
          final t1 = m.length * ((i + 1) / segs);
          final hue = (360.0 * i / segs);
          final segPaint = paintPath
            ..color = HSVColor.fromAHSV(1, hue, 0.9, 1).toColor();
          canvas.drawPath(m.extractPath(t0, t1), segPaint);
        }
      }
    }

    if (showPen && last != null) {
      canvas.drawCircle(last, 3.5, Paint()..color = strokeColor);
    }
  }

  @override
  bool shouldRepaint(covariant EpicyclePainter old) {
    if (turns != old.turns ||
        progress != old.progress ||
        showPen != old.showPen ||
        strokeColor != old.strokeColor ||
        strokeWidth != old.strokeWidth ||
        shadow != old.shadow ||
        shadowSigma != old.shadowSigma ||
        mode != old.mode ||
        epicycles.length != old.epicycles.length)
      return true;

    for (int i = 0; i < epicycles.length; i++) {
      final a = epicycles[i], b = old.epicycles[i];
      if (a.speed != b.speed ||
          a.length != b.length ||
          a.direction != b.direction ||
          a.phase != b.phase)
        return true;
    }
    return false;
  }
}
