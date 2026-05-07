import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';

class FilterSheetScaffold extends StatelessWidget {
  const FilterSheetScaffold({
    required this.title,
    required this.children,
    required this.onClear,
    required this.onApply,
    super.key,
  });

  final String title;
  final List<Widget> children;
  final VoidCallback onClear;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.xl + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FilterSheetTitle(title: title),
            const SizedBox(height: AppSpacing.md),
            for (final child in children) ...[
              child,
              const SizedBox(height: AppSpacing.md),
            ],
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onClear,
                    child: const Text('Limpar'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.brandGreen,
                      foregroundColor: AppColors.neutral0,
                    ),
                    onPressed: onApply,
                    child: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FilterDropdown extends StatelessWidget {
  const FilterDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.labels = const {},
    super.key,
  });

  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final Map<String, String> labels;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.neutral50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      items: [
        const DropdownMenuItem(value: null, child: Text('Todos')),
        ...options.map(
          (option) => DropdownMenuItem(
            value: option,
            child: Text(labels[option] ?? option),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}

List<String> filterOptions(Iterable<String> values) {
  final options =
      values
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .toSet()
          .toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return options;
}

class _FilterSheetTitle extends StatelessWidget {
  const _FilterSheetTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.headerBlue,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}
