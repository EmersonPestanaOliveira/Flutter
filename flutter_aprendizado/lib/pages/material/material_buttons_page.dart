import 'package:flutter/material.dart';
import '../../data/material/button_entries.dart';
import '../catalog/category_grid_page.dart';

class MaterialButtonsPage extends StatelessWidget {
  const MaterialButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryGridPage(
      title: 'Material / BotÃµes',
      entries: materialButtonEntries,
    );
  }
}
