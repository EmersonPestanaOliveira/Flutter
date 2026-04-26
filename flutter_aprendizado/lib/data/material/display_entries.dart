import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/material/display/image_playground.dart';
import '../../playgrounds/material/display/label_playground.dart';

const List<CatalogEntry> materialDisplayEntries = [
  CatalogEntry(
    title: 'Image',
    icon: Icons.image,
    pageBuilder: _image,
  ),
  CatalogEntry(
    title: 'Label',
    icon: Icons.label,
    pageBuilder: _label,
  ),
];

Widget _image() => const ImagePlayground();
Widget _label() => const LabelPlayground();
