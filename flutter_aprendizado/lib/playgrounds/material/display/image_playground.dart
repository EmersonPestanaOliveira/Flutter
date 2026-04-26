import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class ImagePlayground extends StatefulWidget {
  const ImagePlayground({super.key});

  @override
  State<ImagePlayground> createState() => _ImagePlaygroundState();
}

class _ImagePlaygroundState extends State<ImagePlayground> {
  double width = 180;
  double height = 120;
  double radius = 12;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Image',
      preview: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(
          'https://picsum.photos/400/240',
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              width: width,
              height: height,
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: const Icon(Icons.image, size: 48),
            );
          },
        ),
      ),
      controls: [
        SliderControl(
          label: 'Width',
          value: width,
          min: 100,
          max: 320,
          onChanged: (value) => setState(() => width = value),
        ),
        SliderControl(
          label: 'Height',
          value: height,
          min: 80,
          max: 240,
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
