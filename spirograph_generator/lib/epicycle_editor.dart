import 'package:flutter/material.dart';
import 'package:spirograph_generator/epicycle.dart';
import 'package:spirograph_generator/labeled_slider.dart';

class EpicycleEditor extends StatelessWidget {
  const EpicycleEditor({
    required this.index,
    required this.value,
    required this.onChanged,
  });

  final int index;
  final Epicycle value;
  final ValueChanged<Epicycle> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vetor ${index + 1}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            LabeledSlider(
              label: 'Speed',
              min: 0,
              max: 60,
              value: value.speed,
              onChanged: (v) => onChanged(value.copyWith(speed: v)),
            ),
            LabeledSlider(
              label: 'Length',
              min: 0,
              max: 200,
              value: value.length,
              onChanged: (v) => onChanged(value.copyWith(length: v)),
            ),

            // Direction – responsivo
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Direction'),
                const SizedBox(width: 8),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final isCompact = c.maxWidth < 340; // breakpoint

                      if (isCompact) {
                        // MOBILE/estreito: usa Dropdown compacto
                        return DropdownButtonFormField<int>(
                          value: value.direction,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: -1,
                              child: Text('−1 (horário)'),
                            ),
                            DropdownMenuItem(
                              value: 1,
                              child: Text('+1 (anti-horário)'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null)
                              onChanged(value.copyWith(direction: v));
                          },
                        );
                      }

                      // LARGO: mantém SegmentedButton; envolto em scroll horizontal
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SegmentedButton<int>(
                          segments: const [
                            ButtonSegment(
                              value: -1,
                              label: Text('−1 (horário)'),
                            ),
                            ButtonSegment(
                              value: 1,
                              label: Text('+1 (anti-horário)'),
                            ),
                          ],
                          selected: {value.direction},
                          onSelectionChanged: (s) =>
                              onChanged(value.copyWith(direction: s.first)),
                          showSelectedIcon: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),
            LabeledSlider(
              label: 'Phase',
              min: -3.1416,
              max: 3.1416,
              value: value.phase,
              onChanged: (v) => onChanged(value.copyWith(phase: v)),
            ),
          ],
        ),
      ),
    );
  }
}
