import 'package:flutter/material.dart';
import '../../widgets/playground/control_widgets.dart';
import '../../widgets/playground/playground_page.dart';

class ContainerPlayground extends StatefulWidget {
  const ContainerPlayground({super.key});

  @override
  State<ContainerPlayground> createState() => _ContainerPlaygroundState();
}

class _ContainerPlaygroundState extends State<ContainerPlayground> {
  double width = 160;
  double height = 120;
  double radius = 16;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Container',
      preview: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      controls: [
        SliderControl(
          label: 'Width',
          value: width,
          min: 50,
          max: 300,
          onChanged: (value) => setState(() => width = value),
        ),
        SliderControl(
          label: 'Height',
          value: height,
          min: 50,
          max: 300,
          onChanged: (value) => setState(() => height = value),
        ),
        SliderControl(
          label: 'Border radius',
          value: radius,
          min: 0,
          max: 50,
          onChanged: (value) => setState(() => radius = value),
        ),
      ],
    );
  }
}
