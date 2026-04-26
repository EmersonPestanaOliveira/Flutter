import 'package:flutter/material.dart';
import '../../data/cupertino/cupertino_entries.dart';
import '../catalog/category_grid_page.dart';

class CupertinoComponentsPage extends StatelessWidget {
  const CupertinoComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryGridPage(
      title: 'Cupertino',
      entries: cupertinoEntries,
    );
  }
}
