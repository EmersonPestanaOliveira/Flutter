import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';

class SettingsPanel extends StatelessWidget {
  final int rows, cols, seed;
  final double wallThickness, glowSigma;
  final ValueChanged<int> onRows, onCols;
  final ValueChanged<double> onWall, onGlow;
  final VoidCallback onApply, onNewSeed, onClose;

  const SettingsPanel({
    super.key,
    required this.rows,
    required this.cols,
    required this.seed,
    required this.wallThickness,
    required this.glowSigma,
    required this.onRows,
    required this.onCols,
    required this.onWall,
    required this.onGlow,
    required this.onApply,
    required this.onNewSeed,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.85),
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tune),
                const SizedBox(width: 8),
                const Text(
                  'Configurações',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  'Seed: $seed',
                  style: const TextStyle(
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Fechar',
                  onPressed: onClose, // <-- botão fechar
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _Labeled(
              'Linhas',
              Slider(
                value: rows.toDouble(),
                min: 5,
                max: 80,
                divisions: 75,
                label: '$rows',
                onChanged: (v) => onRows(v.round()),
              ),
            ),
            _Labeled(
              'Colunas',
              Slider(
                value: cols.toDouble(),
                min: 5,
                max: 120,
                divisions: 115,
                label: '$cols',
                onChanged: (v) => onCols(v.round()),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _Labeled(
                    'Espessura do traço',
                    Slider(
                      value: wallThickness,
                      min: 1,
                      max: 8,
                      divisions: 28,
                      label: wallThickness.toStringAsFixed(1),
                      onChanged: onWall,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Labeled(
                    'Brilho (glow)',
                    Slider(
                      value: glowSigma,
                      min: 0,
                      max: 14,
                      divisions: 28,
                      label: glowSigma.toStringAsFixed(1),
                      onChanged: onGlow,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onApply, // <-- agora funciona
                    icon: const Icon(Icons.check),
                    label: const Text('Aplicar'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: onNewSeed,
                  icon: const Icon(Icons.casino),
                  label: const Text('Nova semente'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Labeled extends StatelessWidget {
  final String label;
  final Widget child;
  const _Labeled(this.label, this.child);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        child,
      ],
    );
  }
}
