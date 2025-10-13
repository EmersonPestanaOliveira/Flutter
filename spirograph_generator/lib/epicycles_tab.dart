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
import 'package:spirograph_generator/epicycle.dart';
import 'package:spirograph_generator/epicycle_editor.dart';
import 'package:spirograph_generator/epicycle_painter.dart';
import 'package:spirograph_generator/labeled_slider.dart';
import 'package:spirograph_generator/responsive_two_pane.dart';

// NOVOS imports:
import 'package:spirograph_generator/line_style_sheet.dart';
import 'package:spirograph_generator/stroke_style.dart';
import 'package:spirograph_generator/zoomable_canvas.dart';

/// =============================================================
/// MÉTODO B — Epiciclos (soma de vetores rotativos)
/// =============================================================
class EpicyclesTab extends StatefulWidget {
  const EpicyclesTab({super.key, required this.background});

  final BackgroundConfig background;

  @override
  State<EpicyclesTab> createState() => _EpicyclesTabState();
}

class _EpicyclesTabState extends State<EpicyclesTab>
    with SingleTickerProviderStateMixin {
  final List<Epicycle> epicycles = [
    Epicycle(speed: 20, length: 93, direction: 1, phase: 0),
    Epicycle(speed: 16, length: 15, direction: 1, phase: 0),
    Epicycle(speed: 5, length: 136, direction: 1, phase: 0),
  ];

  double turns = 12; // duração do t

  late final AnimationController _controller;
  double get progress => _controller.value; // 0..1

  // estilo da linha (cor/espessura/sombra/modo)
  StrokeConfig _stroke = const StrokeConfig();

  // controle do zoom
  final _zoomKey = GlobalKey<ZoomableCanvasState>();

  // captura
  final _captureKey = GlobalKey();
  bool _hideHud = false;

  // ======= NOVOS CONTROLES DE ANIMAÇÃO =======
  double _durationSec = 10; // duração base (1x)
  double _speed = 1.0; // fator de velocidade (0.2x..3x)

  Duration get _effectiveDuration =>
      Duration(milliseconds: (_durationSec * 1000 / _speed).round());

  void _applyDuration({bool keepProgress = true}) {
    final wasAnimating = _controller.isAnimating;
    final current = _controller.value;
    _controller.duration = _effectiveDuration;
    if (wasAnimating) {
      _controller.forward(from: keepProgress ? current : 0);
    }
  }
  // ============================================

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
      _applyDuration(keepProgress: true);
      _controller.forward(from: progress);
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

  // ---------- captura / salvar / compartilhar ----------
  Future<Uint8List?> _capturePng() async {
    try {
      setState(() => _hideHud = true); // esconde HUD do zoom
      await WidgetsBinding.instance.endOfFrame;

      final boundary =
          _captureKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      return data?.buffer.asUint8List();
    } finally {
      if (mounted) setState(() => _hideHud = false);
    }
  }

  Future<void> _saveImage() async {
    final bytes = await _capturePng();
    if (bytes == null) return;

    final name = 'spiro_${DateTime.now().millisecondsSinceEpoch}';

    final res = await SaverGallery.saveImage(
      bytes,
      quality: 100,
      extension: 'png',
      fileName: name,
      androidRelativePath: 'Pictures/Spirograph',
      skipIfExists: false,
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

  // ---------- Modo randômico ----------
  double _randDouble(math.Random r, double min, double max) =>
      min + r.nextDouble() * (max - min);

  Color _randAccent(math.Random r) {
    final h = r.nextDouble() * 360;
    return HSVColor.fromAHSV(1, h, 0.75, 0.95).toColor();
  }

  void _randomizeEpicycles() {
    final r = math.Random();

    // quantidade de vetores: 2..6
    final n = r.nextInt(5) + 2;
    final list = <Epicycle>[];

    for (int i = 0; i < n; i++) {
      final speed = _randDouble(r, 2, 24); // velocidade razoável
      final length = _randDouble(r, 18, 150);
      final dir = r.nextBool() ? 1 : -1;
      final phase = _randDouble(r, -math.pi, math.pi);

      list.add(
        Epicycle(speed: speed, length: length, direction: dir, phase: phase),
      );
    }

    final newTurns = _randDouble(r, 8, 40);

    final rainbow = r.nextDouble() < 0.35; // 35% arco-íris
    final newStroke = StrokeConfig(
      color: rainbow ? Colors.white : _randAccent(r),
      width: _randDouble(r, 0.9, 4.5),
      shadow: r.nextDouble() < 0.30,
      shadowSigma: _randDouble(r, 6, 16),
      mode: rainbow ? StrokeMode.rainbow : StrokeMode.solid,
    );

    setState(() {
      epicycles
        ..clear()
        ..addAll(list);
      turns = newTurns;
      _stroke = newStroke;
    });

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    // ---------- PREVIEW ----------
    final preview = Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // ====== Área que entra na captura ======
            RepaintBoundary(
              key: _captureKey,
              child: Stack(
                children: [
                  // fundo selecionado (default = Original no BackgroundConfig)
                  DecoratedBox(
                    decoration: widget.background.decoration,
                    child: const SizedBox.expand(),
                  ),
                  // desenho + ZOOM (HUD escondido na captura)
                  ZoomableCanvas(
                    key: _zoomKey,
                    anchor: ZoomControlsAnchor.topRight, // topo à direita
                    showControls: !_hideHud,
                    child: CustomPaint(
                      painter: EpicyclePainter(
                        epicycles: epicycles,
                        turns: turns,
                        progress: progress,
                        showPen: true,
                        strokeColor: _stroke.color,
                        strokeWidth: _stroke.width,
                        shadow: _stroke.shadow,
                        shadowSigma: _stroke.shadowSigma,
                        mode: _stroke.mode, // sólido / arco-íris
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),

            // ====== Controles fora da captura ======

            // play / reset
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

    // ---------- CONTROLES ----------
    final controls = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // botão de estilo de linha + Aleatório
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

          // novo: modo randômico
          OutlinedButton.icon(
            onPressed: _randomizeEpicycles,
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
            label: 'voltas (t)',
            min: 2,
            max: 50,
            value: turns,
            onChanged: (v) => setState(() => turns = v),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => setState(
                  () => epicycles.add(
                    Epicycle(speed: 10, length: 40, direction: 1, phase: 0),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Adicionar vetor'),
              ),
              const SizedBox(width: 12),
              if (epicycles.isNotEmpty)
                OutlinedButton.icon(
                  onPressed: () => setState(() => epicycles.removeLast()),
                  icon: const Icon(Icons.remove),
                  label: const Text('Remover último'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Animação: ${(progress * 100).toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Slider(
            value: progress,
            onChanged: (v) => setState(() => _controller.value = v),
          ),
          const SizedBox(height: 4),
          ...epicycles.asMap().entries.map(
            (e) => EpicycleEditor(
              index: e.key,
              value: e.value,
              onChanged: (newVal) => setState(() => epicycles[e.key] = newVal),
            ),
          ),
        ],
      ),
    );

    // ---------- LAYOUT RESPONSIVO ----------
    return ResponsiveTwoPane(preview: preview, controls: controls);
  }
}
