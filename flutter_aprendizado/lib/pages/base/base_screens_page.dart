import 'package:flutter/material.dart';
import '../../data/base/base_screen_entries.dart';
import '../catalog/category_grid_page.dart';

class BaseScreensPage extends StatelessWidget {
  const BaseScreensPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryGridPage(
      title: 'Telas Base',
      entries: baseScreenEntries,
    );
  }
}
