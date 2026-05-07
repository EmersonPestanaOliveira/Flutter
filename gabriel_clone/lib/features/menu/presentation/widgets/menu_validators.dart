part of '../menu_pages.dart';

String? _requiredText(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Preencha este campo.';
  }
  return null;
}

