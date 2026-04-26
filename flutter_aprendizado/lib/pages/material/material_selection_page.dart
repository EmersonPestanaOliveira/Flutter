import 'package:flutter/material.dart';
import '../../data/material/selection_entries.dart';
import '../catalog/category_grid_page.dart';

class MaterialSelectionPage extends StatelessWidget {
  const MaterialSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryGridPage(
      title: 'Material / SeleÃ§Ã£o',
      entries: materialSelectionEntries,
    );
  }
}
