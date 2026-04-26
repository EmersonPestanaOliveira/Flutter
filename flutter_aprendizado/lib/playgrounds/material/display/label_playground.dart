import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class LabelPlayground extends StatefulWidget {
  const LabelPlayground({super.key});

  @override
  State<LabelPlayground> createState() => _LabelPlaygroundState();
}

class _LabelPlaygroundState extends State<LabelPlayground> {
  String text = 'Premium';
  double fontSize = 16;
  double radius = 20;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Label',
      preview: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      controls: [
        TextControl(
          label: 'Texto',
          initialValue: text,
          onChanged: (value) => setState(() => text = value),
        ),
        SliderControl(
          label: 'Font size',
          value: fontSize,
          min: 10,
          max: 28,
          onChanged: (value) => setState(() => fontSize = value),
        ),
        SliderControl(
          label: 'Radius',
          value: radius,
          min: 0,
          max: 40,
          onChanged: (value) => setState(() => radius = value),
        ),
      ],
    );
  }
}
