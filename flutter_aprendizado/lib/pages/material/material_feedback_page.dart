import 'package:flutter/material.dart';
import '../../data/material/feedback_entries.dart';
import '../catalog/category_grid_page.dart';

class MaterialFeedbackPage extends StatelessWidget {
  const MaterialFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryGridPage(
      title: 'Material / Feedback',
      entries: materialFeedbackEntries,
    );
  }
}
