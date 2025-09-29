// lib/main.dart
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(const MatrixApp());

class MatrixApp extends StatelessWidget {
  const MatrixApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matrix Digital Rain',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'NotoSansJP', // precisa estar no pubspec.yaml
      ),
      home: const MatrixScreen(),
    );
  }
}

class MatrixScreen extends StatefulWidget {
  const MatrixScreen({super.key});
  @override
  State<MatrixScreen> createState() => _MatrixScreenState();
}

class _MatrixScreenState extends State<MatrixScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final _RainEngine _engine;
  Duration _last = Duration.zero;

  // presets para ficar bem “filme”
  final double cell = 18; // “tamanho do glyph”
  final double minSpeed = 140; // px/s
  final double maxSpeed = 260; // px/s
  final int minLen = 12; // mínimo de rastro
  final int maxLen = 34; // máximo de rastro
  final bool headGlow = true; // brilho sutil na cabeça
  final double colDensity = 1.0; // 1.0 = colunas coladas (estilo filme)

  @override
  void initState() {
    super.initState();
    _engine = _RainEngine(
      cell: cell,
      minSpeed: minSpeed,
      maxSpeed: maxSpeed,
      minLen: minLen,
      maxLen: maxLen,
      colDensity: colDensity,
      headGlow: headGlow,
    );
    _ticker = createTicker((elapsed) {
      if (_last == Duration.zero) {
        _last = elapsed;
        return;
      }
      final dt = (elapsed - _last).inMicroseconds / 1e6;
      _last = elapsed;
      _engine.update(dt);
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        _engine.configure(
          size: Size(c.maxWidth, c.maxHeight),
        ); // cria/ajusta colunas
        return CustomPaint(
          painter: _MatrixPainter(_engine),
          size: Size(c.maxWidth, c.maxHeight),
        );
      },
    );
  }
}

// =================== ENGINE (estado + lógica) ===================

class _RainEngine extends ChangeNotifier {
  _RainEngine({
    required this.cell,
    required this.minSpeed,
    required this.maxSpeed,
    required this.minLen,
    required this.maxLen,
    required this.colDensity,
    required this.headGlow,
  });

  final double cell;
  final double minSpeed, maxSpeed;
  final int minLen, maxLen;
  final double colDensity;
  final bool headGlow;

  final Random _rng = Random();
  final _GlyphCache _cache = _GlyphCache();
  Size _size = Size.zero;

  late List<_Col> _cols;
  int _rows = 0;

  // paleta “Matrix”
  static const Color headColor = Color(0xFFE7FFE7); // quase branco
  static const Color tailGreen = Color(0xFF00FF41); // verde “Matrix”
  static const Color tailDeep = Color(0xFF00B030); // verde mais escuro pro fim

  static const List<String> _kana = [
    // Katakana + Hiragana + ASCII/Dígitos (mix clássico)
    'ア', 'イ', 'ウ', 'エ', 'オ', 'カ', 'キ', 'ク', 'ケ', 'コ', 'サ', 'シ', 'ス', 'セ', 'ソ',
    'タ', 'チ', 'ツ', 'テ', 'ト', 'ナ', 'ニ', 'ヌ', 'ネ', 'ノ', 'ハ', 'ヒ', 'フ', 'ヘ', 'ホ',
    'マ', 'ミ', 'ム', 'メ', 'モ', 'ヤ', 'ユ', 'ヨ', 'ラ', 'リ', 'ル', 'レ', 'ロ', 'ワ', 'ン',
    'ぁ', 'あ', 'ぃ', 'い', 'ぅ', 'う', 'ぇ', 'え', 'ぉ', 'お', 'か', 'き', 'く', 'け', 'こ',
    'さ', 'し', 'す', 'せ', 'そ', 'た', 'ち', 'つ', 'て', 'と', 'な', 'に', 'ぬ', 'ね', 'の',
    'は',
    'ひ',
    'ふ',
    'へ',
    'ほ',
    'ま',
    'み',
    'む',
    'め',
    'も',
    'や',
    'ゆ',
    'よ',
    'ら',
    'り',
    'る',
    'れ',
    'ろ',
    'わ',
    'ん',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    '+', '-', '*', '/', '=', '<', '>', '[', ']', '{', '}', '#', '@', '%', '&',
  ];

  void configure({required Size size}) {
    if (size == _size && _cols.isNotEmpty) return;
    _size = size;

    final colW = (cell * colDensity).clamp(cell * 0.95, cell * 1.05);
    final colsCount = (_size.width / colW).floor().clamp(1, 9999);
    _rows = (_size.height / cell).ceil();

    _cols = List.generate(colsCount, (i) {
      return _spawnCol(i * colW);
    });
  }

  _Col _spawnCol(double x) {
    final speed = _rng.nextDouble() * (maxSpeed - minSpeed) + minSpeed;
    final len = _rng.nextInt(maxLen - minLen + 1) + minLen;
    final y0 = _rng.nextDouble() * _size.height;
    final seed = _rng.nextInt(1 << 31);

    // conteúdo inicial da coluna
    final buffer = List.generate(
      maxLen + 4,
      (_) => _kana[_rng.nextInt(_kana.length)],
    );

    return _Col(
      x: x,
      y: y0,
      speed: speed,
      len: len,
      seed: seed,
      buffer: buffer,
      // troca de caractere cadenciado, mas com jitter
      nextSwapAt: 0.04 + _rng.nextDouble() * 0.08, // 40–120ms
      swapTimer: 0.0,
    );
  }

  void update(double dt) {
    if (_size == Size.zero || _cols.isEmpty) return;

    for (var c in _cols) {
      // progresso vertical
      c.y += c.speed * dt;

      // recicla coluna ao sair da tela por “len” + margem (orgânico)
      if (c.y - c.len * cell > _size.height + cell * 2) {
        // respawn mantendo a mesma x (coluna fixa)
        final x = c.x;
        final newCol = _spawnCol(x);
        // aleatoriamente mude velocidade/comprimento para variar
        c.y = -_rng.nextDouble() * _size.height * 0.5;
        c.speed = newCol.speed;
        c.len = newCol.len;
        c.seed = newCol.seed;
        c.buffer.setAll(0, newCol.buffer);
        c.nextSwapAt = newCol.nextSwapAt;
        c.swapTimer = 0.0;
      }

      // troca de caracteres (cintilar)
      c.swapTimer += dt;
      if (c.swapTimer >= c.nextSwapAt) {
        c.swapTimer = 0.0;
        c.nextSwapAt = 0.04 + _rng.nextDouble() * 0.08;
        // troque alguns elementos aleatórios na “cauda”
        final swaps = 1 + _rng.nextInt(3);
        for (int s = 0; s < swaps; s++) {
          final idx = _rng.nextInt(min(c.len, c.buffer.length));
          c.buffer[idx] = _kana[_rng.nextInt(_kana.length)];
        }
      }
    }

    notifyListeners();
  }
}

class _Col {
  _Col({
    required this.x,
    required this.y,
    required this.speed,
    required this.len,
    required this.seed,
    required this.buffer,
    required this.nextSwapAt,
    required this.swapTimer,
  });

  final double x;
  double y; // posição da cabeça
  double speed; // px/s
  int len; // comprimento visível do rastro
  int seed;
  final List<String> buffer; // caracteres disponíveis para esta coluna

  double nextSwapAt; // intervalo alvo p/ troca de chars
  double swapTimer; // acumulador
}

// =================== PAINTER (render) ===================

class _MatrixPainter extends CustomPainter {
  _MatrixPainter(this.engine) : super(repaint: engine);
  final _RainEngine engine;

  // gradiente do rastro (forte → fraco) com leve variação de tom
  Color _tailColor(double t) {
    // t: 0 (head) → 1 (fim da cauda)
    final base =
        Color.lerp(_RainEngine.tailGreen, _RainEngine.tailDeep, t) ??
        _RainEngine.tailGreen;
    final a = ui.lerpDouble(1.0, 0.0, pow(t, 1.4).toDouble())!;
    return base.withOpacity(a);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // fundo puro + leve vinheta (estilo filme)
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);
    final vignette = Paint()
      ..shader = ui.Gradient.radial(
        size.center(Offset.zero),
        size.shortestSide,
        [Colors.transparent, Colors.black.withOpacity(0.35)],
      );
    canvas.drawRect(Offset.zero & size, vignette);

    final cell = engine.cell;

    for (final c in engine._cols) {
      // desenha de cabeça → cauda
      for (int i = 0; i < c.len; i++) {
        final y = c.y - i * cell;
        if (y < -cell) break;
        if (y > size.height + cell) continue;

        final isHead = i == 0;
        final color = isHead
            ? _RainEngine.headColor
            : _tailColor(i / (c.len - 1).clamp(1, 9999).toDouble());

        // brilho sutil no head
        if (isHead && engine.headGlow) {
          final glow = Paint()
            ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 7)
            ..color = color.withOpacity(0.9);
          canvas.drawRect(Rect.fromLTWH(c.x, y, cell, cell), glow);
        }

        // escolha de caractere: “escorrega” ao longo do buffer
        final idx = (i + ((y / cell).floor().abs())) % c.buffer.length;
        final ch = c.buffer[idx];

        _GlyphCache.paint(
          canvas: canvas,
          char: ch,
          x: c.x,
          y: y,
          cell: cell,
          bold: isHead, // cabeça mais pesada
          color: color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MatrixPainter oldDelegate) => false;
}

// =================== GLYPH CACHE ===================
// Cacheia layout do glyph em branco e aplica a cor via srcIn.
// Chave: (char, bold, cellSize)
class _GlyphCache {
  static final Map<String, TextPainter> _cache = {};

  static TextPainter _painter(String ch, bool bold, double cell) {
    final tp = TextPainter(
      text: TextSpan(
        text: ch,
        style: TextStyle(
          fontFamily: 'NotoSansJP',
          fontSize: cell * 0.95,
          height: 1.0,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          letterSpacing: 0.0,
          color: Colors.white, // será substituída via srcIn
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: cell * 1.4);
    return tp;
  }

  static void paint({
    required Canvas canvas,
    required String char,
    required double x,
    required double y,
    required double cell,
    required bool bold,
    required Color color,
  }) {
    final key = '$char|${bold ? 1 : 0}|${cell.toStringAsFixed(2)}';
    final tp = _cache.putIfAbsent(key, () => _painter(char, bold, cell));

    final rect = Rect.fromLTWH(x, y, cell, cell);
    canvas.saveLayer(rect, Paint());
    tp.paint(canvas, Offset(x, y));
    canvas.drawRect(
      rect,
      Paint()..colorFilter = ColorFilter.mode(color, BlendMode.srcIn),
    );
    canvas.restore();
  }
}
