import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_options.dart';
import '../../../widgets/playground/playground_page.dart';

class ElevatedButtonPlayground extends StatefulWidget {
  const ElevatedButtonPlayground({super.key});

  @override
  State<ElevatedButtonPlayground> createState() =>
      _ElevatedButtonPlaygroundState();
}

class _ElevatedButtonPlaygroundState extends State<ElevatedButtonPlayground> {
  String label = 'ElevatedButton';
  bool enabled = true;
  bool showIcon = false;
  bool useMinimumSize = true;
  bool useFixedSize = false;

  double fontSize = 16;
  double borderRadius = 12;
  double elevation = 1;
  double horizontalPadding = 20;
  double verticalPadding = 14;
  double minWidth = 180;
  double minHeight = 48;
  double fixedWidth = 220;
  double fixedHeight = 52;
  double borderWidth = 0;

  Color backgroundColor = Colors.blue;
  Color foregroundColor = Colors.white;
  Color borderColor = Colors.blue;
  AlignmentGeometry alignment = Alignment.center;
  Clip clipBehavior = Clip.none;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(backgroundColor),
      foregroundColor: MaterialStatePropertyAll(foregroundColor),
      elevation: MaterialStatePropertyAll(elevation),
      //alignment: MaterialStatePropertyAll(alignment),
      padding: MaterialStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
      ),
      minimumSize: useMinimumSize
          ? MaterialStatePropertyAll(Size(minWidth, minHeight))
          : null,
      fixedSize: useFixedSize
          ? MaterialStatePropertyAll(Size(fixedWidth, fixedHeight))
          : null,
      side: MaterialStatePropertyAll(
        BorderSide(color: borderColor, width: borderWidth),
      ),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );

    final previewButton = showIcon
        ? ElevatedButton.icon(
            onPressed: enabled ? () {} : null,
            icon: const Icon(Icons.fitness_center),
            label: Text(label, style: TextStyle(fontSize: fontSize)),
            clipBehavior: clipBehavior,
            style: style,
          )
        : ElevatedButton(
            onPressed: enabled ? () {} : null,
            clipBehavior: clipBehavior,
            style: style,
            child: Text(label, style: TextStyle(fontSize: fontSize)),
          );

    return PlaygroundPage(
      title: 'ElevatedButton',
      preview: previewButton,
      controls: [
        TextControl(
          label: 'Texto',
          initialValue: label,
          onChanged: (value) {
            setState(() {
              label = value.isEmpty ? 'ElevatedButton' : value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Habilitado'),
          value: enabled,
          onChanged: (value) => setState(() => enabled = value),
        ),
        SwitchListTile(
          title: const Text('Mostrar Ã­cone'),
          value: showIcon,
          onChanged: (value) => setState(() => showIcon = value),
        ),
        SwitchListTile(
          title: const Text('Usar minimumSize'),
          value: useMinimumSize,
          onChanged: (value) => setState(() => useMinimumSize = value),
        ),
        SwitchListTile(
          title: const Text('Usar fixedSize'),
          value: useFixedSize,
          onChanged: (value) => setState(() => useFixedSize = value),
        ),
        SliderControl(
          label: 'Font size',
          value: fontSize,
          min: 10,
          max: 32,
          onChanged: (value) => setState(() => fontSize = value),
        ),
        SliderControl(
          label: 'Border radius',
          value: borderRadius,
          min: 0,
          max: 40,
          onChanged: (value) => setState(() => borderRadius = value),
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
          label: 'Padding horizontal',
          value: horizontalPadding,
          min: 0,
          max: 40,
          onChanged: (value) => setState(() => horizontalPadding = value),
        ),
        SliderControl(
          label: 'Padding vertical',
          value: verticalPadding,
          min: 0,
          max: 30,
          onChanged: (value) => setState(() => verticalPadding = value),
        ),
        SliderControl(
          label: 'Border width',
          value: borderWidth,
          min: 0,
          max: 6,
          fractionDigits: 1,
          onChanged: (value) => setState(() => borderWidth = value),
        ),
        if (useMinimumSize) ...[
          SliderControl(
            label: 'Minimum width',
            value: minWidth,
            min: 80,
            max: 320,
            onChanged: (value) => setState(() => minWidth = value),
          ),
          SliderControl(
            label: 'Minimum height',
            value: minHeight,
            min: 36,
            max: 100,
            onChanged: (value) => setState(() => minHeight = value),
          ),
        ],
        if (useFixedSize) ...[
          SliderControl(
            label: 'Fixed width',
            value: fixedWidth,
            min: 80,
            max: 340,
            onChanged: (value) => setState(() => fixedWidth = value),
          ),
          SliderControl(
            label: 'Fixed height',
            value: fixedHeight,
            min: 36,
            max: 120,
            onChanged: (value) => setState(() => fixedHeight = value),
          ),
        ],
        DropdownControl<Color>(
          label: 'Background color',
          value: backgroundColor,
          options: kColorOptions,
          onChanged: (value) => setState(() => backgroundColor = value),
        ),
        DropdownControl<Color>(
          label: 'Foreground color',
          value: foregroundColor,
          options: kColorOptions,
          onChanged: (value) => setState(() => foregroundColor = value),
        ),
        DropdownControl<Color>(
          label: 'Border color',
          value: borderColor,
          options: kColorOptions,
          onChanged: (value) => setState(() => borderColor = value),
        ),
        DropdownControl<AlignmentGeometry>(
          label: 'Alignment',
          value: alignment,
          options: kAlignmentOptions,
          onChanged: (value) => setState(() => alignment = value),
        ),
        DropdownControl<Clip>(
          label: 'Clip behavior',
          value: clipBehavior,
          options: kClipOptions,
          onChanged: (value) => setState(() => clipBehavior = value),
        ),
      ],
    );
  }
}
