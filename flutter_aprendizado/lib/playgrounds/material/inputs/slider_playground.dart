import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class SliderPlayground extends StatefulWidget {
  const SliderPlayground({super.key});

  @override
  State<SliderPlayground> createState() => _SliderPlaygroundState();
}

class _SliderPlaygroundState extends State<SliderPlayground> {
  double value = 40;
  double min = 0;
  double max = 100;
  int divisions = 5;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Slider',
      preview: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 280,
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              label: value.round().toString(),
              onChanged: (newValue) => setState(() => value = newValue),
            ),
          ),
          Text('Valor: ${value.toStringAsFixed(0)}'),
        ],
      ),
      controls: [
        SliderControl(
          label: 'Value',
          value: value,
          min: min,
          max: max,
          onChanged: (newValue) => setState(() => value = newValue),
        ),
        SliderControl(
          label: 'Max',
          value: max,
          min: 10,
          max: 200,
          onChanged: (newValue) {
            setState(() {
              max = newValue;
              if (value > max) value = max;
            });
          },
        ),
        SliderControl(
          label: 'Divisions',
          value: divisions.toDouble(),
          min: 1,
          max: 20,
          onChanged: (newValue) {
            setState(() => divisions = newValue.round());
          },
        ),
      ],
    );
  }
}
