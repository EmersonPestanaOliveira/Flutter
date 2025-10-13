// lib/background_style.dart
import 'package:flutter/material.dart';

/// ============================
/// Modelo de configuração
/// ============================
enum BackgroundMode { original, custom }

class BackgroundConfig {
  final BackgroundMode mode;
  final Color? color; // usado quando mode == custom

  const BackgroundConfig._(this.mode, this.color);

  /// Default: o gradiente original
  const BackgroundConfig.original() : this._(BackgroundMode.original, null);

  /// Custom: qualquer cor
  const BackgroundConfig.custom(Color c) : this._(BackgroundMode.custom, c);

  String get label => switch (mode) {
    BackgroundMode.original => 'Original',
    BackgroundMode.custom => 'Personalizada',
  };

  /// Decoração aplicada ao preview/canvas
  BoxDecoration get decoration {
    switch (mode) {
      case BackgroundMode.original:
        return const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0E0E12), Color(0xFF1A1A22)],
          ),
        );
      case BackgroundMode.custom:
        final base = color ?? const Color(0xFF101010);
        final hsl = HSLColor.fromColor(base);
        final darker = hsl
            .withLightness((hsl.lightness * 0.6).clamp(0.0, 1.0))
            .toColor();
        final lighter = hsl
            .withLightness((hsl.lightness * 1.2).clamp(0.0, 1.0))
            .toColor();
        return BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [darker, base, lighter],
          ),
        );
    }
  }

  /// Helper: troca a cor mantendo modo custom
  BackgroundConfig copyWithColor(Color c) =>
      BackgroundConfig._(BackgroundMode.custom, c);
}

/// ===============================================================
/// BottomSheet: seletor simples de BACKGROUND (mesmo padrão do de linha)
/// ===============================================================
class BackgroundStyleSheet extends StatefulWidget {
  const BackgroundStyleSheet({super.key, required this.initial});
  final BackgroundConfig initial;

  @override
  State<BackgroundStyleSheet> createState() => _BackgroundStyleSheetState();
}

class _BackgroundStyleSheetState extends State<BackgroundStyleSheet> {
  late bool _useDefault;
  late HSVColor _hsv;
  late double _alpha;

  // Paleta rápida
  static const _presets = <Color>[
    Color(0xFF0E0E12),
    Color(0xFF1A1A22),
    Color(0xFFF48FB1), // rosa do app
    Colors.black,
    Colors.white,
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.amber,
    Colors.lightGreenAccent,
    Colors.cyanAccent,
    Colors.lightBlueAccent,
    Colors.indigoAccent,
    Colors.purpleAccent,
  ];

  @override
  void initState() {
    super.initState();
    _useDefault = widget.initial.mode == BackgroundMode.original;

    final base = switch (widget.initial.mode) {
      BackgroundMode.original => const Color(0xFF1A1A22),
      BackgroundMode.custom => widget.initial.color ?? const Color(0xFF1A1A22),
    };

    _hsv = HSVColor.fromColor(base);
    _alpha = base.opacity;
  }

  Color get _color => _hsv.toColor().withOpacity(_alpha);

  Widget _slider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // usar ternário (corrigido)
    final Decoration previewDecoration = _useDefault
        ? const BackgroundConfig.original().decoration
        : BackgroundConfig.custom(_color).decoration;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header + toggle "Usar padrão"
            Row(
              children: [
                Expanded(child: Text('Fundo', style: textTheme.titleMedium)),
                Switch.adaptive(
                  value: _useDefault,
                  onChanged: (v) => setState(() => _useDefault = v),
                ),
                const SizedBox(width: 8),
                const Text('Usar padrão'),
              ],
            ),
            const SizedBox(height: 12),

            // Preview do background
            Container(height: 72, decoration: previewDecoration),
            const SizedBox(height: 12),

            if (!_useDefault) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Cores rápidas', style: textTheme.labelMedium),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _presets.map((c) {
                  final selected = (c.value == _color.withOpacity(1).value);
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
                        _alpha = c.opacity == 1 ? 1.0 : c.opacity;
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

              _slider(
                label: 'Hue (matiz)',
                value: _hsv.hue,
                min: 0,
                max: 360,
                onChanged: (v) => setState(() => _hsv = _hsv.withHue(v)),
              ),
              _slider(
                label: 'Saturation',
                value: _hsv.saturation,
                min: 0,
                max: 1,
                onChanged: (v) => setState(() => _hsv = _hsv.withSaturation(v)),
              ),
              _slider(
                label: 'Brightness',
                value: _hsv.value,
                min: 0,
                max: 1,
                onChanged: (v) => setState(() => _hsv = _hsv.withValue(v)),
              ),
              _slider(
                label: 'Opacity',
                value: _alpha,
                min: 0,
                max: 1,
                onChanged: (v) => setState(() => _alpha = v),
              ),
            ],

            Row(
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_useDefault) {
                      Navigator.pop(context, const BackgroundConfig.original());
                    } else {
                      Navigator.pop(context, BackgroundConfig.custom(_color));
                    }
                  },
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
