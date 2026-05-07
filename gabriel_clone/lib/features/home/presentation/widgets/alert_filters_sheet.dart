import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../domain/entities/alerta.dart';
import '../../domain/enums/alerta_tipo.dart';
import 'filter_sheet_controls.dart';

class AlertFilterResult {
  const AlertFilterResult({
    required this.bairro,
    required this.cidade,
    required this.dateKey,
    required this.tipo,
  });

  final String? bairro;
  final String? cidade;
  final String? dateKey;
  final AlertaTipo? tipo;
}

class AlertFiltersSheet extends StatefulWidget {
  const AlertFiltersSheet({
    required this.alertas,
    required this.selectedBairro,
    required this.selectedCidade,
    required this.selectedDateKey,
    required this.selectedTipo,
    required this.dateKeyBuilder,
    required this.dateLabelBuilder,
    super.key,
  });

  final List<Alerta> alertas;
  final String? selectedBairro;
  final String? selectedCidade;
  final String? selectedDateKey;
  final AlertaTipo? selectedTipo;
  final String Function(DateTime date) dateKeyBuilder;
  final String Function(DateTime date) dateLabelBuilder;

  @override
  State<AlertFiltersSheet> createState() => _AlertFiltersSheetState();
}

class _AlertFiltersSheetState extends State<AlertFiltersSheet> {
  late final ValueNotifier<AlertFilterResult> _selection;

  @override
  void initState() {
    super.initState();
    _selection = ValueNotifier(
      AlertFilterResult(
        bairro: widget.selectedBairro,
        cidade: widget.selectedCidade,
        dateKey: widget.selectedDateKey,
        tipo: widget.selectedTipo,
      ),
    );
  }

  @override
  void dispose() {
    _selection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bairros = filterOptions(
      widget.alertas.map((alerta) => alerta.bairro),
    );
    final cidades = filterOptions(
      widget.alertas.map((alerta) => alerta.cidade),
    );
    final dateOptions = _dateOptions();
    final tipos = AlertaTipo.values
        .where((tipo) => widget.alertas.any((alerta) => alerta.tipo == tipo))
        .toList(growable: false);

    return ValueListenableBuilder<AlertFilterResult>(
      valueListenable: _selection,
      builder: (context, selection, _) {
        return FilterSheetScaffold(
          title: 'Filtrar alertas',
          onClear: () => _selection.value = const AlertFilterResult(
            bairro: null,
            cidade: null,
            dateKey: null,
            tipo: null,
          ),
          onApply: () => Navigator.of(context).pop(selection),
          children: [
            FilterDropdown(
              label: 'Bairro',
              value: bairros.contains(selection.bairro)
                  ? selection.bairro
                  : null,
              options: bairros,
              onChanged: (value) => _selection.value = AlertFilterResult(
                bairro: value,
                cidade: selection.cidade,
                dateKey: selection.dateKey,
                tipo: selection.tipo,
              ),
            ),
            FilterDropdown(
              label: 'Cidade',
              value: cidades.contains(selection.cidade)
                  ? selection.cidade
                  : null,
              options: cidades,
              onChanged: (value) => _selection.value = AlertFilterResult(
                bairro: selection.bairro,
                cidade: value,
                dateKey: selection.dateKey,
                tipo: selection.tipo,
              ),
            ),
            FilterDropdown(
              label: 'Data',
              value: dateOptions.any((option) => option.key == selection.dateKey)
                  ? selection.dateKey
                  : null,
              options: dateOptions.map((option) => option.key).toList(),
              labels: {
                for (final option in dateOptions) option.key: option.label,
              },
              onChanged: (value) => _selection.value = AlertFilterResult(
                bairro: selection.bairro,
                cidade: selection.cidade,
                dateKey: value,
                tipo: selection.tipo,
              ),
            ),
            DropdownButtonFormField<AlertaTipo>(
              initialValue: tipos.contains(selection.tipo)
                  ? selection.tipo
                  : null,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Tipo',
                filled: true,
                fillColor: AppColors.neutral50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Todos')),
                ...tipos.map(
                  (tipo) =>
                      DropdownMenuItem(value: tipo, child: Text(tipo.label)),
                ),
              ],
              onChanged: (value) => _selection.value = AlertFilterResult(
                bairro: selection.bairro,
                cidade: selection.cidade,
                dateKey: selection.dateKey,
                tipo: value,
              ),
            ),
          ],
        );
      },
    );
  }

  List<({String key, String label})> _dateOptions() {
    final labels = <String, String>{};
    for (final alerta in widget.alertas) {
      final key = widget.dateKeyBuilder(alerta.data);
      if (key.isNotEmpty) {
        labels[key] = widget.dateLabelBuilder(alerta.data);
      }
    }
    return labels.entries
        .map((entry) => (key: entry.key, label: entry.value))
        .toList()
      ..sort((a, b) => b.key.compareTo(a.key));
  }
}
