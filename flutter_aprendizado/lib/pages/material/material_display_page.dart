import 'package:flutter/material.dart';
import '../../data/material/display_entries.dart';
import '../catalog/category_grid_page.dart';

class MaterialDisplayPage extends StatelessWidget {
  const MaterialDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryGridPage(
      title: 'Material / Display',
      entries: materialDisplayEntries,
    );
  }
}
