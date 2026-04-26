import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class CircularProgressPlayground extends StatefulWidget {
  const CircularProgressPlayground({super.key});

  @override
  State<CircularProgressPlayground> createState() =>
      _CircularProgressPlaygroundState();
}

class _CircularProgressPlaygroundState
    extends State<CircularProgressPlayground> {
  double progress = 0.7;
  double strokeWidth = 6;
  bool determinate = true;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Circular Progress',
      preview: CircularProgressIndicator(
        value: determinate ? progress : null,
        strokeWidth: strokeWidth,
      ),
      controls: [
        SwitchListTile(
          title: const Text('Determinate'),
          value: determinate,
          onChanged: (value) => setState(() => determinate = value),
        ),
        if (determinate)
          SliderControl(
            label: 'Progress',
            value: progress,
            min: 0,
            max: 1,
            fractionDigits: 2,
            onChanged: (value) => setState(() => progress = value),
          ),
        SliderControl(
          label: 'Stroke width',
          value: strokeWidth,
          min: 2,
          max: 16,
          onChanged: (value) => setState(() => strokeWidth = value),
        ),
      ],
    );
  }
}
