import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/cupertino/cupertino_button_playground.dart';

const List<CatalogEntry> cupertinoEntries = [
  CatalogEntry(
    title: 'CupertinoButton',
    icon: Icons.radio_button_checked,
    pageBuilder: _cupertinoButton,
  ),
];

Widget _cupertinoButton() => const CupertinoButtonPlayground();
