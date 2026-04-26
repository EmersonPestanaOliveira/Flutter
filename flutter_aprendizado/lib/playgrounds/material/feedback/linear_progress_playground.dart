import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class LinearProgressPlayground extends StatefulWidget {
  const LinearProgressPlayground({super.key});

  @override
  State<LinearProgressPlayground> createState() =>
      _LinearProgressPlaygroundState();
}

class _LinearProgressPlaygroundState extends State<LinearProgressPlayground> {
  double progress = 0.5;
  double minHeight = 8;
  bool determinate = true;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Linear Progressbar',
      preview: SizedBox(
        width: 280,
        child: LinearProgressIndicator(
          value: determinate ? progress : null,
          minHeight: minHeight,
          borderRadius: BorderRadius.circular(20),
        ),
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
          label: 'Height',
          value: minHeight,
          min: 4,
          max: 20,
          onChanged: (value) => setState(() => minHeight = value),
        ),
      ],
    );
  }
}
