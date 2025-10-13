import 'package:flutter/material.dart';
import 'stroke_style.dart';

class LineStyleSheet extends StatefulWidget {
  const LineStyleSheet({super.key, required this.initial});
  final StrokeConfig initial;

  @override
  State<LineStyleSheet> createState() => _LineStyleSheetState();
}

class _LineStyleSheetState extends State<LineStyleSheet> {
  late HSVColor _hsv;
  late double _alpha;
  late double _width;
  late bool _shadow;
  late double _shadowSigma;
  late StrokeMode _mode; // <-- NOVO

  static const _presets = <Color>[
    Color(0xFFF48FB1),
    Colors.white,
    Colors.black,
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.amber,
    Colors.lime,
    Colors.lightGreenAccent,
    Colors.cyanAccent,
    Colors.lightBlueAccent,
    Colors.indigoAccent,
    Colors.purpleAccent,
  ];

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.initial.color);
    _alpha = widget.initial.color.opacity;
    _width = widget.initial.width;
    _shadow = widget.initial.shadow;
    _shadowSigma = widget.initial.shadowSigma;
    _mode = widget.initial.mode; // <-- NOVO
  }

  Color get _color => _hsv.toColor().withOpacity(_alpha);

  Widget _slider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: IgnorePointer(
        ignoring: !enabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label),
                Text(
                  value.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            Slider(value: value, min: min, max: max, onChanged: onChanged),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final t = Theme.of(context).textTheme;
    final rainbowOn = _mode == StrokeMode.rainbow;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Linha 1: preview + seletor de modo
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                    // quando arco-íris, mostra gradiente no preview
                    gradient: rainbowOn
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
                    color: rainbowOn ? null : color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SegmentedButton<StrokeMode>(
                    segments: const [
                      ButtonSegment(
                        value: StrokeMode.solid,
                        icon: Icon(Icons.circle),
                        label: Text('Sólida'),
                      ),
                      ButtonSegment(
                        value: StrokeMode.rainbow,
                        icon: Icon(Icons.gradient),
                        label: Text('Arco-íris'),
                      ),
                    ],
                    selected: {_mode},
                    onSelectionChanged: (s) => setState(() => _mode = s.first),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Paleta rápida (somente quando sólido)
            if (!rainbowOn) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Cores rápidas', style: t.labelMedium),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _presets.map((c) {
                  final selected = (c.value == color.withOpacity(1).value);
                  return InkWell(
                    onTap: () {
                      final hsv = HSVColor.fromColor(c);
                      setState(() {
                        _hsv = HSVColor.fromAHSV(
                          _hsv.alpha,
                          hsv.hue,
                          hsv.saturation,
                          hsv.value,
                        );
                        _alpha = 1.0;
                      });
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c,
                        border: Border.all(
                          color: selected ? Colors.white : Colors.white24,
                          width: selected ? 2 : 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Sliders HSV (desativados quando arco-íris)
            _slider(
              label: 'Hue (matiz)',
              value: _hsv.hue,
              min: 0,
              max: 360,
              onChanged: (v) => setState(() => _hsv = _hsv.withHue(v)),
              enabled: !rainbowOn,
            ),
            _slider(
              label: 'Saturation',
              value: _hsv.saturation,
              min: 0,
              max: 1,
              onChanged: (v) => setState(() => _hsv = _hsv.withSaturation(v)),
              enabled: !rainbowOn,
            ),
            _slider(
              label: 'Brightness',
              value: _hsv.value,
              min: 0,
              max: 1,
              onChanged: (v) => setState(() => _hsv = _hsv.withValue(v)),
              enabled: !rainbowOn,
            ),

            // Opacity e Espessura sempre ativas
            _slider(
              label: 'Opacity',
              value: _alpha,
              min: 0,
              max: 1,
              onChanged: (v) => setState(() => _alpha = v),
            ),
            _slider(
              label: 'Espessura da linha',
              value: _width,
              min: 0.5,
              max: 8,
              onChanged: (v) => setState(() => _width = v),
            ),

            // Sombra
            Row(
              children: [
                Switch.adaptive(
                  value: _shadow,
                  onChanged: (v) => setState(() => _shadow = v),
                ),
                const SizedBox(width: 8),
                const Text('Sombra'),
                const Spacer(),
                if (_shadow)
                  Text(
                    '${_shadowSigma.toStringAsFixed(1)}',
                    style: t.labelSmall,
                  ),
              ],
            ),
            if (_shadow)
              _slider(
                label: 'Intensidade da sombra',
                value: _shadowSigma,
                min: 1.5,
                max: 16,
                onChanged: (v) => setState(() => _shadowSigma = v),
              ),

            Row(
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(
                    context,
                    StrokeConfig(
                      color: _color, // ignorado no modo rainbow
                      width: _width,
                      shadow: _shadow,
                      shadowSigma: _shadowSigma,
                      mode: _mode, // <-- devolve o modo
                    ),
                  ),
                  icon: const Icon(Icons.check),
                  label: const Text('Aplicar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
