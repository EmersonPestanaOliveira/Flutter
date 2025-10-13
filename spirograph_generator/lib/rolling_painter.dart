import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:spirograph_generator/stroke_style.dart'; // <- usa o MESMO StrokeMode

class RollingPainter extends CustomPainter {
  RollingPainter({
    // spiro
    required this.outside,
    required this.R,
    required this.r,
    required this.d,
    required this.turns,
    required this.progress, // 0..1
    this.showPen = false,

    // estilo da linha
    this.strokeColor = const Color(0xFFF48FB1),
    this.strokeWidth = 1.6,
    this.shadow = false,
    this.shadowSigma = 8.0,
    this.mode = StrokeMode.solid,

    // guias
    this.showGuides = true,
    this.guideOpacity = 0.18,
  });

  // modelo
  final bool
  outside; // false = dentro (hipotrocoide), true = fora (epitrocoide)
  final double R, r, d, turns;
  final double progress; // 0..1
  final bool showPen;

  // estilo de traço
  final Color strokeColor;
  final double strokeWidth;
  final bool shadow;
  final double shadowSigma;
  final StrokeMode mode; // <- vem de stroke_style.dart

  // guias
  final bool showGuides;
  final double guideOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas.translate(center.dx, center.dy);

    // ---------- PAINTS ----------
    final pathPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (mode == StrokeMode.solid) {
      pathPaint.color = strokeColor;
    } else {
      // arco-íris: vamos pintar “segmentado”
      pathPaint.color = Colors.white; // base irrelevante
    }

    if (shadow) {
      pathPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, shadowSigma);
    }

    final guideColor = Colors.white.withOpacity(guideOpacity);
    final guideStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = guideColor;

    final dotPaint = Paint()..color = strokeColor;

    // ---------- PARÂMETROS ----------
    const steps = 6000; // resolução
    final totalT = 2 * math.pi * turns;
    final maxI = (steps * progress).clamp(0, steps).toInt();

    // funções paramétricas
    Offset eval(double t) {
      final rr = outside ? (R + r) : (R - r);
      final k = rr / r;
      final double x = outside
          ? rr * math.cos(t) - d * math.cos(k * t)
          : rr * math.cos(t) + d * math.cos(k * t);
      final double y = outside
          ? rr * math.sin(t) - d * math.sin(k * t)
          : rr * math.sin(t) - d * math.sin(k * t);
      return Offset(x, y);
    }

    Offset smallCenter(double t) {
      final cx = (outside ? (R + r) : (R - r)) * math.cos(t);
      final cy = (outside ? (R + r) : (R - r)) * math.sin(t);
      return Offset(cx, cy);
    }

    double wheelAngle(double t) {
      final rr = outside ? (R + r) : (R - r);
      return (rr / r) * t;
    }

    // ---------- TRAÇAR O CAMINHO ----------
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

    // ---------- DESENHAR GUIAS ----------
    if (showGuides) {
      // círculo base
      canvas.drawCircle(
        Offset.zero,
        outside ? (R + r) : (R - r).abs(),
        guideStroke,
      );

      final tNow = totalT * progress;
      final c = smallCenter(tNow);

      // círculo pequeno
      canvas.drawCircle(c, r, guideStroke);

      // “risquinho” de orientação
      final theta = wheelAngle(tNow);
      final ori = Offset(math.cos(theta), math.sin(theta));
      canvas.drawLine(c + ori * (r - 6), c + ori * r, guideStroke);

      // haste do lápis + caneta
      final k = (outside ? (R + r) : (R - r)) / r;
      final pen = outside
          ? Offset(c.dx - d * math.cos(k * tNow), c.dy - d * math.sin(k * tNow))
          : Offset(
              c.dx + d * math.cos(k * tNow),
              c.dy + d * math.sin(k * tNow),
            );

      canvas.drawLine(c, pen, guideStroke);
      canvas.drawCircle(c, 2.5, Paint()..color = guideColor);
      canvas.drawCircle(
        pen,
        3.5,
        Paint()..color = strokeColor.withOpacity(0.95),
      );
    }

    // ---------- DESENHAR TRAÇO ----------
    if (mode == StrokeMode.solid) {
      canvas.drawPath(path, pathPaint);
    } else {
      // arco-íris: colorir por segmentos ao longo do PathMetric
      final metrics = path.computeMetrics();
      for (final m in metrics) {
        const segs = 180;
        for (int i = 0; i < segs; i++) {
          final t0 = m.length * (i / segs);
          final t1 = m.length * ((i + 1) / segs);
          final hue = (360.0 * i / segs);
          final segPaint = pathPaint
            ..color = HSVColor.fromAHSV(1, hue, 0.9, 1).toColor();
          canvas.drawPath(m.extractPath(t0, t1), segPaint);
        }
      }
    }

    // caneta animada (quando guias desligadas)
    if (showPen && last != null && !showGuides) {
      canvas.drawCircle(last, 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant RollingPainter old) {
    return outside != old.outside ||
        R != old.R ||
        r != old.r ||
        d != old.d ||
        turns != old.turns ||
        progress != old.progress ||
        showPen != old.showPen ||
        strokeColor != old.strokeColor ||
        strokeWidth != old.strokeWidth ||
        shadow != old.shadow ||
        shadowSigma != old.shadowSigma ||
        mode != old.mode ||
        showGuides != old.showGuides ||
        guideOpacity != old.guideOpacity;
  }
}
