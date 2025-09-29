import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PongApp());
}

class PongApp extends StatelessWidget {
  const PongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pong — 2 Jogadores',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F1A),
      ),
      home: const Scaffold(
        body: SafeArea(
          child: Center(
            child: AspectRatio(aspectRatio: 900 / 520, child: PongGame()),
          ),
        ),
      ),
    );
  }
}

class PongGame extends StatefulWidget {
  const PongGame({super.key});

  @override
  State<PongGame> createState() => _PongGameState();
}

class _PongGameState extends State<PongGame>
    with SingleTickerProviderStateMixin {
  // Dimensões de referência (desenho é escalável via CustomPainter)
  static const double W = 900;
  static const double H = 520;
  static const double paddleW = 12;
  static const double paddleH = 96;
  static const double margin = 24;
  static const double ballR = 8;

  // Estado
  double leftY = H / 2 - paddleH / 2;
  double rightY = H / 2 - paddleH / 2;
  double leftVy = 0, rightVy = 0;
  int leftScore = 0, rightScore = 0;

  double ballX = W / 2, ballY = H / 2;
  double ballVx = 0, ballVy = 0;
  double ballSpeed = 5.0;

  bool paused = false;
  bool waitingServe = true;
  bool serveToLeft = Random().nextBool();
  int level = 1;

  // Controles
  bool lUp = false, lDown = false, rUp = false, rDown = false;

  // Loop
  late final AnimationController _ticker;

  // Focus para teclado no Flutter Web
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _ticker = AnimationController.unbounded(vsync: this)
      ..addListener(_tick)
      ..repeat(min: 0, max: 1, period: const Duration(milliseconds: 16));
  }

  @override
  void dispose() {
    _ticker.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _tick() {
    if (!mounted) return;
    if (paused) return;

    const acc = 35.0; // aceleração das raquetes
    const fri = 0.85; // atrito

    // controla raquetes (W/S e setas)
    if (lUp) leftVy -= acc;
    if (lDown) leftVy += acc;
    if (rUp) rightVy -= acc;
    if (rDown) rightVy += acc;

    leftVy *= fri;
    rightVy *= fri;

    leftY = _clamp(leftY + leftVy * 0.016, 0, H - paddleH);
    rightY = _clamp(rightY + rightVy * 0.016, 0, H - paddleH);

    if (waitingServe) {
      setState(() {});
      return;
    }

    // movimenta bola
    ballX += ballVx;
    ballY += ballVy;

    // colisão topo/base
    if (ballY < ballR) {
      ballY = ballR;
      ballVy *= -1;
    }
    if (ballY > H - ballR) {
      ballY = H - ballR;
      ballVy *= -1;
    }

    // colisão com raquetes
    _checkPaddleCollision(isLeft: true, px: margin, py: leftY);
    _checkPaddleCollision(isLeft: false, px: W - margin - paddleW, py: rightY);

    // ponto
    if (ballX < -ballR * 2) {
      rightScore++;
      _onScore(leftServes: false);
    }
    if (ballX > W + ballR * 2) {
      leftScore++;
      _onScore(leftServes: true);
    }

    setState(() {});
  }

  double _clamp(double v, double a, double b) => v < a ? a : (v > b ? b : v);

  void _checkPaddleCollision({
    required bool isLeft,
    required double px,
    required double py,
  }) {
    // bounding-box vertical
    if (ballY + ballR < py || ballY - ballR > py + paddleH) return;

    if (isLeft) {
      if (ballX - ballR > px + paddleW) return;
      if (ballX - ballR < px + paddleW) {
        ballX = px + paddleW + ballR;
      }
    } else {
      if (ballX + ballR < px) return;
      if (ballX + ballR > px) {
        ballX = px - ballR;
      }
    }

    // Calcula ângulo pelo ponto do impacto
    final rel = (ballY - (py + paddleH / 2)) / (paddleH / 2);
    const maxAng = pi / 3; // 60°
    final ang = rel * maxAng;
    final dir = isLeft ? 1 : -1;

    ballSpeed = (ballSpeed + 0.25).clamp(0, 18);
    ballVx = cos(ang) * ballSpeed * dir;
    ballVy = sin(ang) * ballSpeed;
  }

  void _serve() {
    final ang = (Random().nextDouble() * (pi / 3)) - (pi / 6);
    final dir = serveToLeft ? -1 : 1;
    ballVx = cos(ang) * ballSpeed * dir;
    ballVy = sin(ang) * ballSpeed;
    waitingServe = false;
  }

  void _resetPositions() {
    leftY = H / 2 - paddleH / 2;
    rightY = H / 2 - paddleH / 2;
    leftVy = rightVy = 0;
    ballX = W / 2;
    ballY = H / 2;
    ballSpeed = 5.0 + (level - 1) * 0.6;
    ballVx = ballVy = 0;
    waitingServe = true;
    serveToLeft = !serveToLeft;
  }

  void _hardReset() {
    leftScore = rightScore = 0;
    level = 1;
    paused = false;
    _resetPositions();
  }

  void _onScore({required bool leftServes}) {
    if (leftScore >= 11 || rightScore >= 11) {
      paused = true;
    } else {
      final total = leftScore + rightScore;
      if (total > 0 && total % 2 == 0) {
        level = min(9, 1 + (total ~/ 2));
      }
      serveToLeft = leftServes;
      _resetPositions();
    }
  }

  void _onKey(RawKeyEvent e) {
    final down = e is RawKeyDownEvent;
    final key = e.logicalKey;

    // Controles dois jogadores
    if (key == LogicalKeyboardKey.keyW) lUp = down;
    if (key == LogicalKeyboardKey.keyS) lDown = down;
    if (key == LogicalKeyboardKey.arrowUp) rUp = down;
    if (key == LogicalKeyboardKey.arrowDown) rDown = down;

    // Sistema
    if (down && key == LogicalKeyboardKey.space && waitingServe && !paused)
      _serve();
    if (down && key == LogicalKeyboardKey.keyP) paused = !paused;
    if (down && key == LogicalKeyboardKey.keyR) _hardReset();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (_, e) {
        _onKey(e);
        // evita scroll da página no web ao usar setas/espaço
        return KeyEventResult.handled;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _focusNode.requestFocus(),
        child: Stack(
          children: [
            CustomPaint(
              painter: _PongPainter(
                leftY: leftY,
                rightY: rightY,
                leftScore: leftScore,
                rightScore: rightScore,
                ballX: ballX,
                ballY: ballY,
                level: level,
              ),
              child: const SizedBox.expand(),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w600,
                ),
                child: Text(
                  paused
                      ? 'PAUSADO — P retoma | R reinicia'
                      : (waitingServe
                            ? 'Espaço para sacar — Controles: Esquerda W/S • Direita ↑/↓'
                            : 'Controles: Esquerda W/S • Direita ↑/↓  |  P: pausa  •  R: reinicia'),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PongPainter extends CustomPainter {
  final double leftY, rightY, ballX, ballY;
  final int leftScore, rightScore, level;
  const _PongPainter({
    required this.leftY,
    required this.rightY,
    required this.ballX,
    required this.ballY,
    required this.leftScore,
    required this.rightScore,
    required this.level,
  });

  static const double W = _PongGameState.W;
  static const double H = _PongGameState.H;
  static const double paddleW = _PongGameState.paddleW;
  static const double paddleH = _PongGameState.paddleH;
  static const double margin = _PongGameState.margin;
  static const double ballR = _PongGameState.ballR;

  @override
  void paint(Canvas canvas, Size size) {
    // Ajuste de escala para caber no Size disponível
    final sx = size.width / W;
    final sy = size.height / H;
    final s = min(sx, sy);
    final tx = (size.width - W * s) / 2;
    final ty = (size.height - H * s) / 2;

    canvas.save();
    canvas.translate(tx, ty);
    canvas.scale(s, s);

    final bg = Paint()..color = const Color(0xFF0A0A0A);
    canvas.drawRect(const Rect.fromLTWH(0, 0, W, H), bg);

    // rede tracejada
    final netPaint = Paint()
      ..color = const Color(0xFF374151)
      ..style = PaintingStyle.fill;
    const dash = 16.0;
    for (double y = 0; y < H; y += dash * 2) {
      canvas.drawRect(Rect.fromLTWH(W / 2 - 2, y, 4, dash), netPaint);
    }

    // placar
    final scoreStyle = const TextStyle(
      color: Color(0xFFE5E7EB),
      fontWeight: FontWeight.w700,
      fontSize: 44,
    );
    _drawText(
      canvas,
      '${leftScore}',
      Offset(W / 2 - 80, 60),
      scoreStyle,
      align: TextAlign.center,
    );
    _drawText(
      canvas,
      '${rightScore}',
      Offset(W / 2 + 80, 60),
      scoreStyle,
      align: TextAlign.center,
    );

    // nível
    _drawText(
      canvas,
      'Nível $level',
      const Offset(W / 2, 90),
      const TextStyle(
        color: Color(0xFF94A3B8),
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      align: TextAlign.center,
    );

    // paddles
    final paddlePaint = Paint()..color = const Color(0xFFE5E7EB);
    canvas.drawRect(
      Rect.fromLTWH(margin, leftY, paddleW, paddleH),
      paddlePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(W - margin - paddleW, rightY, paddleW, paddleH),
      paddlePaint,
    );

    // bola
    final ballPaint = Paint()..color = const Color(0xFFFACC15);
    canvas.drawCircle(Offset(ballX, ballY), ballR, ballPaint);

    canvas.restore();
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset pos,
    TextStyle style, {
    TextAlign align = TextAlign.left,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: align,
      textDirection: TextDirection.ltr,
    )..layout();
    final dx = align == TextAlign.center ? pos.dx - tp.width / 2 : pos.dx;
    final dy = pos.dy - tp.height / 2;
    tp.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant _PongPainter old) {
    return old.leftY != leftY ||
        old.rightY != rightY ||
        old.ballX != ballX ||
        old.ballY != ballY ||
        old.leftScore != leftScore ||
        old.rightScore != rightScore ||
        old.level != level;
  }
}
