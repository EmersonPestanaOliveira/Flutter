import 'package:flutter/material.dart';
import '../../widgets/playground/control_widgets.dart';
import '../../widgets/playground/playground_page.dart';

class RowPlayground extends StatefulWidget {
  const RowPlayground({super.key});

  @override
  State<RowPlayground> createState() => _RowPlaygroundState();
}

class _RowPlaygroundState extends State<RowPlayground> {
  double spacing = 8;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Row',
      preview: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _box(),
          SizedBox(width: spacing),
          _box(),
          SizedBox(width: spacing),
          _box(),
        ],
      ),
      controls: [
        SliderControl(
          label: 'Spacing',
          value: spacing,
          min: 0,
          max: 40,
          onChanged: (value) => setState(() => spacing = value),
        ),
      ],
    );
  }

  Widget _box() {
    return Container(
      width: 50,
      height: 50,
      color: Colors.blue,
    );
  }
}
