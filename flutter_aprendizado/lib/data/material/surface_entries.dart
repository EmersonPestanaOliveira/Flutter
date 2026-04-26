import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/material/surfaces/card_playground.dart';

const List<CatalogEntry> materialSurfaceEntries = [
  CatalogEntry(
    title: 'Card',
    icon: Icons.credit_card,
    pageBuilder: _card,
  ),
];

Widget _card() => const CardPlayground();
