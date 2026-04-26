import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class RatingBarPlayground extends StatefulWidget {
  const RatingBarPlayground({super.key});

  @override
  State<RatingBarPlayground> createState() => _RatingBarPlaygroundState();
}

class _RatingBarPlaygroundState extends State<RatingBarPlayground> {
  int rating = 3;
  int totalStars = 5;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Rating Bar',
      preview: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(totalStars, (index) {
          final filled = index < rating;
          return IconButton(
            onPressed: () => setState(() => rating = index + 1),
            icon: Icon(
              filled ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 34,
            ),
          );
        }),
      ),
      controls: [
        SliderControl(
          label: 'Rating',
          value: rating.toDouble(),
          min: 1,
          max: totalStars.toDouble(),
          onChanged: (value) => setState(() => rating = value.round()),
        ),
      ],
    );
  }
}
