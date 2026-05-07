import 'package:flutter/material.dart';

import '../app_colors.dart';

class AppLoadingIndicator extends StatefulWidget {
  const AppLoadingIndicator({super.key});

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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
    return Center(
      child: SizedBox.square(
        dimension: 132,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _LoadingPainter(progress: _controller.value),
            );
          },
        ),
      ),
    );
  }
}

class _LoadingPainter extends CustomPainter {
  const _LoadingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * 0.28;
    final bluePaint = Paint()
      ..color = AppColors.headerBlue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;
    final redPaint = Paint()
      ..color = AppColors.accentRed
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * 6.283185307179586);
    canvas.translate(-center.dx, -center.dy);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.3,
      4.8,
      false,
      bluePaint,
    );
    canvas.drawCircle(
      Offset(center.dx - radius * 0.52, center.dy - radius * 0.86),
      13,
      redPaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LoadingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
