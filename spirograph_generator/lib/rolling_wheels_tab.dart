import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spirograph_generator/background_style.dart'; // BackgroundConfig
import 'package:spirograph_generator/labeled_slider.dart';
import 'package:spirograph_generator/responsive_two_pane.dart';
import 'package:spirograph_generator/rolling_painter.dart';

// novos imports:
import 'package:spirograph_generator/line_style_sheet.dart';
import 'package:spirograph_generator/stroke_style.dart';
import 'package:spirograph_generator/zoomable_canvas.dart'; // zoom

/// =============================================================
/// MÉTODO A — Rodas rolando (hipo/epi trocóides)
/// =============================================================
class RollingWheelsTab extends StatefulWidget {
  const RollingWheelsTab({
    super.key,
    required this.background, // BackgroundConfig universal
  });

  final BackgroundConfig background;

  @override
  State<RollingWheelsTab> createState() => _RollingWheelsTabState();
}

class _RollingWheelsTabState extends State<RollingWheelsTab>
    with SingleTickerProviderStateMixin {
  bool outside =
      false; // false = dentro (hipotrocoide), true = fora (epitrocoide)
  double bigR = 120;
  double smallr = 35;
  double d = 50;
  double turns = 10;

  late final AnimationController _controller;
  double get progress => _controller.value; // 0..1

  // estilo da linha (cor/espessura/sombra/modo)
  StrokeConfig _stroke = const StrokeConfig(); // default

  // zoom
  final _zoomKey = GlobalKey<ZoomableCanvasState>();

  // captura
  final _captureKey = GlobalKey(); // RepaintBoundary
  bool _hideHud = false; // esconde controles do zoom ao capturar
  bool _showGuides = true;

  // ======= NOVOS CONTROLES DE ANIMAÇÃO =======
  double _durationSec = 8; // tempo base em segundos (1x)
  double _speed = 1.0; // fator de velocidade (0.2x .. 3x)

  Duration get _effectiveDuration =>
      Duration(milliseconds: (_durationSec * 1000 / _speed).round());

  void _applyDuration({bool keepProgress = true}) {
    final wasAnimating = _controller.isAnimating;
    final current = _controller.value;
    _controller.duration = _effectiveDuration;
    if (wasAnimating) {
      // recomeça sem perder o ponto atual
      _controller.forward(from: keepProgress ? current : 0);
    }
  }
  // ===========================================

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _effectiveDuration)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _applyDuration(keepProgress: true); // garante duração/velocidade atual
      _controller.forward(from: progress); // segue do ponto atual
    }
  }

  void _reset() {
    _controller.stop();
    _controller.value = 0;
    _zoomKey.currentState?.resetZoom(); // reseta zoom também
    setState(() {});
  }

  Future<void> _editLine() async {
    final picked = await showModalBottomSheet<StrokeConfig>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        minChildSize: 0.55,
        maxChildSize: 0.9,
        builder: (context, controller) => SingleChildScrollView(
          controller: controller,
          child: LineStyleSheet(initial: _stroke),
        ),
      ),
    );
    if (picked != null) setState(() => _stroke = picked);
  }

  // ======= Captura / Salvar / Compartilhar =======
  Future<Uint8List?> _capturePng() async {
    try {
      setState(() => _hideHud = true);
      await WidgetsBinding.instance.endOfFrame;

      final boundary =
          _captureKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final ui.Image img = await boundary.toImage(pixelRatio: 3.0);
      final data = await img.toByteData(format: ui.ImageByteFormat.png);
      return data?.buffer.asUint8List();
    } finally {
      if (mounted) setState(() => _hideHud = false);
    }
  }

  Future<void> _saveImage() async {
    final bytes = await _capturePng();
    if (bytes == null) return;

    // nome base do arquivo (sem extensão)
    final name = 'spiro_${DateTime.now().millisecondsSinceEpoch}';

    final res = await SaverGallery.saveImage(
      bytes,
      quality: 100, // opcional (default 100)
      extension: 'png', // png/jpg etc.
      fileName: name, // OBRIGATÓRIO (sem .ext)
      androidRelativePath: 'Pictures/Spirograph', // opcional (Android)
      skipIfExists: false, // OBRIGATÓRIO: false = sobrescreve se existir
    );

    final ok = res.isSuccess;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Imagem salva na galeria' : 'Falha ao salvar'),
      ),
    );
  }

  Future<void> _shareImage() async {
    final bytes = await _capturePng();
    if (bytes == null) return;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/spiro_share.png');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)], text: 'Meu spirograph ✨');
  }

  // ======= Modo randômico =======
  double _randDouble(math.Random r, double min, double max) =>
      min + r.nextDouble() * (max - min);

  Color _randAccent(math.Random r) {
    final h = r.nextDouble() * 360;
    return HSVColor.fromAHSV(1, h, 0.75, 0.95).toColor();
  }

  void _randomizeRolling() {
    final r = math.Random();

    // R entre 60..240
    final newR = _randDouble(r, 60, 240);

    // r entre 5..min(120, R-8) pra não "colar" quando dentro
    final newSmall = _randDouble(r, 5, math.min(120, math.max(20, newR - 8)));

    final newOutside = r.nextBool();

    // d limitado pelo raio efetivo
    final rr = newOutside ? (newR + newSmall) : (newR - newSmall).abs();
    final newD = _randDouble(r, 0, math.min(160, math.max(8, rr)));

    final newTurns = _randDouble(r, 6, 30);

    // stroke randômico
    final rainbow = r.nextDouble() < 0.25; // 25% de chance de arco-íris
    final newStroke = StrokeConfig(
      color: rainbow ? Colors.white : _randAccent(r),
      width: _randDouble(r, 0.8, 5.0),
      shadow: r.nextDouble() < 0.35, // 35% sombra
      shadowSigma: _randDouble(r, 6, 16),
      mode: rainbow ? StrokeMode.rainbow : StrokeMode.solid,
    );

    setState(() {
      bigR = newR;
      smallr = newSmall;
      d = newD;
      turns = newTurns;
      outside = newOutside;
      _stroke = newStroke;
    });

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    // PREVIEW (canvas + botões flutuantes)
    final preview = Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // ====== TUDO que entra na captura ======
            RepaintBoundary(
              key: _captureKey,
              child: Stack(
                children: [
                  // fundo
                  DecoratedBox(
                    decoration: widget.background.decoration,
                    child: const SizedBox.expand(),
                  ),
                  // desenho com ZOOM (HUD oculto ao capturar)
                  ZoomableCanvas(
                    key: _zoomKey,
                    anchor: ZoomControlsAnchor.topRight,
                    showControls: !_hideHud,
                    child: CustomPaint(
                      painter: RollingPainter(
                        outside: outside,
                        R: bigR,
                        r: smallr,
                        d: d,
                        turns: turns,
                        progress: progress,
                        showPen: true,
                        strokeColor: _stroke.color,
                        strokeWidth: _stroke.width,
                        shadow: _stroke.shadow,
                        shadowSigma: _stroke.shadowSigma,
                        mode: _stroke.mode,
                        showGuides: _showGuides, // ⬅️ guias
                        guideOpacity: 0.18,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
            // ====== Controles fora da captura ======

            // play / reset (canto inferior esquerdo)
            Positioned(
              left: 12,
              bottom: 12,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _togglePlay,
                    icon: Icon(
                      _controller.isAnimating ? Icons.pause : Icons.play_arrow,
                    ),
                    label: Text(_controller.isAnimating ? 'Pausar' : 'Animar'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.replay),
                    label: const Text('Resetar'),
                  ),
                ],
              ),
            ),

            // salvar / compartilhar (topo esquerdo)
            Positioned(
              left: 12,
              top: 12,
              child: Material(
                color: Colors.black.withOpacity(0.22),
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Salvar imagem',
                      icon: const Icon(Icons.download),
                      onPressed: _saveImage,
                    ),
                    IconButton(
                      tooltip: 'Compartilhar',
                      icon: const Icon(Icons.share),
                      onPressed: _shareImage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // CONTROLES (sliders e switches)
    final controls = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Guias + Dentro/Fora
          Row(
            children: [
              const Text('Guias'),
              const SizedBox(width: 8),
              Switch(
                value: _showGuides,
                onChanged: (v) => setState(() => _showGuides = v),
              ),
              const SizedBox(width: 16),
              const Text('Dentro'),
              const SizedBox(width: 8),
              Switch(
                value: outside,
                onChanged: (v) => setState(() => outside = v),
              ),
              const SizedBox(width: 8),
              const Text('Fora'),
            ],
          ),

          // botão de estilo de linha + resumo
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _editLine,
                icon: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                    gradient: _stroke.mode == StrokeMode.rainbow
                        ? const SweepGradient(
                            colors: [
                              Colors.red,
                              Colors.orange,
                              Colors.yellow,
                              Colors.green,
                              Colors.cyan,
                              Colors.blue,
                              Colors.indigo,
                              Colors.purple,
                              Colors.red,
                            ],
                          )
                        : null,
                    color: _stroke.mode == StrokeMode.rainbow
                        ? null
                        : _stroke.color,
                  ),
                ),
                label: const Text('Linha'),
              ),
              const SizedBox(width: 12),
              Text(
                '${_stroke.width.toStringAsFixed(1)} px'
                '${_stroke.shadow ? ' · sombra' : ''}'
                '${_stroke.mode == StrokeMode.rainbow ? ' · arco-íris' : ''}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Aleatório
          OutlinedButton.icon(
            onPressed: _randomizeRolling,
            icon: const Icon(Icons.casino),
            label: const Text('Aleatório'),
          ),

          const SizedBox(height: 12),

          // ======= NOVOS: Duração e Velocidade =======
          LabeledSlider(
            label: 'Duração total (s)',
            min: 2,
            max: 30,
            value: _durationSec,
            onChanged: (v) {
              setState(() {
                _durationSec = v;
                _applyDuration(keepProgress: true);
              });
            },
          ),
          LabeledSlider(
            label: 'Velocidade (x)',
            min: 0.2,
            max: 3.0,
            value: _speed,
            onChanged: (v) {
              setState(() {
                _speed = v;
                _applyDuration(keepProgress: true);
              });
            },
          ),
          Text(
            'Efetiva: ${(_effectiveDuration.inMilliseconds / 1000).toStringAsFixed(2)} s',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 12),

          // ============================================
          LabeledSlider(
            label: 'R (raio grande)',
            min: 40,
            max: 240,
            value: bigR,
            onChanged: (v) => setState(() => bigR = v),
          ),
          LabeledSlider(
            label: 'r (raio pequeno)',
            min: 5,
            max: 120,
            value: smallr,
            onChanged: (v) => setState(() => smallr = v),
          ),
          LabeledSlider(
            label: 'd (distância do lápis)',
            min: 0,
            max: 160,
            value: d,
            onChanged: (v) => setState(() => d = v),
          ),
          LabeledSlider(
            label: 'voltas (t)',
            min: 1,
            max: 40,
            value: turns,
            onChanged: (v) => setState(() => turns = v),
          ),
          const SizedBox(height: 6),
          Text(
            'Animação: ${(progress * 100).toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Slider(
            value: progress,
            onChanged: (v) => setState(() => _controller.value = v),
          ),
          Text(
            'Dica: a curva fecha melhor quando R/r é uma fração simples.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );

    // LAYOUT RESPONSIVO
    return ResponsiveTwoPane(preview: preview, controls: controls);
  }
}
