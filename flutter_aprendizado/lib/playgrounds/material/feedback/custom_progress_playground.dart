import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class CustomProgressPlayground extends StatefulWidget {
  const CustomProgressPlayground({super.key});

  @override
  State<CustomProgressPlayground> createState() =>
      _CustomProgressPlaygroundState();
}

class _CustomProgressPlaygroundState extends State<CustomProgressPlayground> {
  double progress = 0.6;
  double height = 16;
  double radius = 20;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Custom Progress',
      preview: SizedBox(
        width: 280,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            children: [
              Container(
                height: height,
                color: Colors.grey.shade300,
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: height,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
      controls: [
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
          value: height,
          min: 6,
          max: 30,
          onChanged: (value) => setState(() => height = value),
        ),
        SliderControl(
          label: 'Radius',
          value: radius,
          min: 0,
          max: 30,
          onChanged: (value) => setState(() => radius = value),
        ),
      ],
    );
  }
}
