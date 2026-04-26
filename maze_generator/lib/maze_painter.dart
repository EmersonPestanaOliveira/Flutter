import 'dart:math';
import 'package:flutter/material.dart';
import 'cell.dart';

class MazePainter extends CustomPainter {
  final List<List<Cell>> grid;
  final Point<int> start;
  final Point<int> end;

  // estilo paredes
  final double wall;
  final double glowSigma;
  final Color color;

  // marcações
  final Color startColor;
  final Color endColor;

  // ---- NOVO: caminho/animação ----
  final List<Point<int>>? path; // caminho de células
  final double pathT; // 0..1 (progresso)
  // --------------------------------

  MazePainter({
    required this.grid,
    required this.start,
    required this.end,
    required this.wall,
    required this.glowSigma,
    required this.color,
    required this.startColor,
    required this.endColor,
    this.path,
    this.pathT = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rows = grid.length;
    final cols = grid.first.length;

    final cell = min(size.width / cols, size.height / rows);
    final mazeW = cell * cols;
    final mazeH = cell * rows;
    final dx = (size.width - mazeW) / 2;
    final dy = (size.height - mazeH) / 2;

    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter;

    final glow = base
      ..strokeWidth = wall + glowSigma * 0.9
      ..color = color.withOpacity(0.85)
      ..maskFilter = glowSigma > 0
          ? MaskFilter.blur(BlurStyle.outer, glowSigma)
          : null;

    final line = Paint()
      ..strokeWidth = wall
      ..color = color;

    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);

    // Paredes
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final x = dx + c * cell;
        final y = dy + r * cell;
        final cellObj = grid[r][c];
        if (cellObj.top) {
          _seg(canvas, glow, line, Offset(x, y), Offset(x + cell, y));
        }
        if (cellObj.right) {
          _seg(
            canvas,
            glow,
            line,
            Offset(x + cell, y),
            Offset(x + cell, y + cell),
          );
        }
        if (cellObj.bottom) {
          _seg(
            canvas,
            glow,
            line,
            Offset(x + cell, y + cell),
            Offset(x, y + cell),
          );
        }
        if (cellObj.left) {
          _seg(canvas, glow, line, Offset(x, y + cell), Offset(x, y));
        }
      }
    }

    // Entrada/Saída (pontos com glow)
    final markerRadius = max(2.0, cell * 0.18);
    final startCenter = Offset(
      dx + (start.y + 0.5) * cell,
      dy + (start.x + 0.5) * cell,
    );
    final endCenter = Offset(
      dx + (end.y + 0.5) * cell,
      dy + (end.x + 0.5) * cell,
    );
    _dot(canvas, startCenter, startColor, markerRadius);
    _dot(canvas, endCenter, endColor, markerRadius);

    // ---- DESENHO DO CAMINHO (animado) ----
    if (path != null && path!.length >= 2 && pathT > 0) {
      final centers = path!
          .map((p) => Offset(dx + (p.y + 0.5) * cell, dy + (p.x + 0.5) * cell))
          .toList();

      final totalSeg = (centers.length - 1).toDouble();
      final pos = (pathT.clamp(0.0, 1.0)) * totalSeg;
      final full = pos.floor();
      final frac = pos - full;

      // pincéis do caminho (verde durante animação, azul quando termina)
      final pathColor = (pathT >= 1.0) ? endColor : Colors.greenAccent;
      final glowP = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = max(wall * 1.4, cell * 0.18) + 4
        ..color = pathColor.withOpacity(0.9)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);
      final lineP = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = max(wall * 1.4, cell * 0.18)
        ..color = pathColor;

      // linhas completas
      for (int i = 0; i < full; i++) {
        canvas.drawLine(centers[i], centers[i + 1], glowP);
        canvas.drawLine(centers[i], centers[i + 1], lineP);
      }
      // segmento parcial
      if (full < centers.length - 1) {
        final a = centers[full];
        final b = centers[full + 1];
        final partial = Offset(
          a.dx + (b.dx - a.dx) * frac,
          a.dy + (b.dy - a.dy) * frac,
        );
        canvas.drawLine(a, partial, glowP);
        canvas.drawLine(a, partial, lineP);
      }
    }
  }

  void _seg(Canvas c, Paint glow, Paint line, Offset a, Offset b) {
    c.drawLine(a, b, glow);
    c.drawLine(a, b, line);
  }

  void _dot(Canvas c, Offset center, Color color, double r) {
    final glow = Paint()
      ..color = color.withOpacity(0.9)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 1.8);
    final core = Paint()..color = color;
    c.drawCircle(center, r * 1.6, glow);
    c.drawCircle(center, r, core);
  }

  @override
  bool shouldRepaint(covariant MazePainter old) =>
      old.grid != grid ||
      old.wall != wall ||
      old.glowSigma != glowSigma ||
      old.color != color ||
      old.start != start ||
      old.end != end ||
      old.pathT != pathT ||
      old.path != path;
}
