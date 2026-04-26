import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../pages/material/material_buttons_page.dart';
import '../../pages/material/material_display_page.dart';
import '../../pages/material/material_feedback_page.dart';
import '../../pages/material/material_inputs_page.dart';
import '../../pages/material/material_pickers_page.dart';
import '../../pages/material/material_selection_page.dart';
import '../../pages/material/material_surfaces_page.dart';

const List<CatalogEntry> materialCategoryEntries = [
  CatalogEntry(
    title: 'BotÃµes',
    icon: Icons.smart_button,
    pageBuilder: _buttonsPage,
  ),
  CatalogEntry(
    title: 'Inputs',
    icon: Icons.text_fields,
    pageBuilder: _inputsPage,
  ),
  CatalogEntry(
    title: 'Feedback',
    icon: Icons.notifications_active,
    pageBuilder: _feedbackPage,
  ),
  CatalogEntry(
    title: 'SeleÃ§Ã£o',
    icon: Icons.checklist,
    pageBuilder: _selectionPage,
  ),
  CatalogEntry(
    title: 'Pickers',
    icon: Icons.calendar_month,
    pageBuilder: _pickersPage,
  ),
  CatalogEntry(
    title: 'Display',
    icon: Icons.image,
    pageBuilder: _displayPage,
  ),
  CatalogEntry(
    title: 'SuperfÃ­cie',
    icon: Icons.layers,
    pageBuilder: _surfacesPage,
  ),
];

Widget _buttonsPage() => const MaterialButtonsPage();
Widget _inputsPage() => const MaterialInputsPage();
Widget _feedbackPage() => const MaterialFeedbackPage();
Widget _selectionPage() => const MaterialSelectionPage();
Widget _pickersPage() => const MaterialPickersPage();
Widget _displayPage() => const MaterialDisplayPage();
Widget _surfacesPage() => const MaterialSurfacesPage();
