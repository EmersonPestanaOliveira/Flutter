import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/playground/control_widgets.dart';
import '../../widgets/playground/playground_page.dart';

class CupertinoButtonPlayground extends StatefulWidget {
  const CupertinoButtonPlayground({super.key});

  @override
  State<CupertinoButtonPlayground> createState() =>
      _CupertinoButtonPlaygroundState();
}

class _CupertinoButtonPlaygroundState extends State<CupertinoButtonPlayground> {
  String label = 'Cupertino Button';
  double padding = 16;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'CupertinoButton',
      preview: CupertinoButton(
        color: CupertinoColors.activeBlue,
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
        onPressed: () {},
        child: Text(label),
      ),
      controls: [
        TextControl(
          label: 'Texto',
          initialValue: label,
          onChanged: (value) {
            setState(() => label = value.isEmpty ? 'Cupertino Button' : value);
          },
        ),
        SliderControl(
          label: 'Padding',
          value: padding,
          min: 8,
          max: 40,
          onChanged: (value) => setState(() => padding = value),
        ),
      ],
    );
  }
}
