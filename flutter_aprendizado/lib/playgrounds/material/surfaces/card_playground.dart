import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class CardPlayground extends StatefulWidget {
  const CardPlayground({super.key});

  @override
  State<CardPlayground> createState() => _CardPlaygroundState();
}

class _CardPlaygroundState extends State<CardPlayground> {
  String title = 'TÃ­tulo do Card';
  String subtitle = 'DescriÃ§Ã£o do componente';
  double elevation = 4;
  double radius = 16;
  double padding = 16;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Card',
      preview: Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: SizedBox(
          width: 300,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(subtitle),
              ],
            ),
          ),
        ),
      ),
      controls: [
        TextControl(
          label: 'TÃ­tulo',
          initialValue: title,
          onChanged: (value) => setState(() => title = value),
        ),
        TextControl(
          label: 'SubtÃ­tulo',
          initialValue: subtitle,
          onChanged: (value) => setState(() => subtitle = value),
        ),
        SliderControl(
          label: 'Elevation',
          value: elevation,
          min: 0,
          max: 20,
          fractionDigits: 1,
          onChanged: (value) => setState(() => elevation = value),
        ),
        SliderControl(
          label: 'Radius',
          value: radius,
          min: 0,
          max: 40,
          onChanged: (value) => setState(() => radius = value),
        ),
        SliderControl(
          label: 'Padding',
          value: padding,
          min: 0,
          max: 40,
          onChanged: (value) => setState(() => padding = value),
        ),
      ],
    );
  }
}
