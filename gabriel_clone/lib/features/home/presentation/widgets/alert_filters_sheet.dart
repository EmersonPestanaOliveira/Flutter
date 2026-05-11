import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../domain/entities/alerta.dart';
import '../../domain/enums/alerta_tipo.dart';
import 'filter_sheet_controls.dart';

/// Opções de período para filtrar alertas.
enum AlertPeriodo {
  hoje,
  tresDias,
  seteDias,
  umMes,
  tresMeses;

  String get label => switch (this) {
        AlertPeriodo.hoje => 'Hoje',
        AlertPeriodo.tresDias => 'Últimos 3 dias',
        AlertPeriodo.seteDias => 'Últimos 7 dias',
        AlertPeriodo.umMes => 'Último mês',
        AlertPeriodo.tresMeses => 'Últimos 3 meses',
      };

  /// Retorna a data inicial (inclusive) a partir de hoje.
  DateTime get dateFrom {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return switch (this) {
      AlertPeriodo.hoje => today,
      AlertPeriodo.tresDias => today.subtract(const Duration(days: 2)),
      AlertPeriodo.seteDias => today.subtract(const Duration(days: 6)),
      AlertPeriodo.umMes => DateTime(now.year, now.month - 1, now.day),
      AlertPeriodo.tresMeses => DateTime(now.year, now.month - 3, now.day),
    };
  }
}

class AlertFilterResult {
  const AlertFilterResult({
    required this.bairro,
    required this.cidade,
    required this.periodo,
    required this.tipo,
  });

  final String? bairro;
  final String? cidade;
  final AlertPeriodo? periodo;
  final AlertaTipo? tipo;
}

class AlertFiltersSheet extends StatefulWidget {
  const AlertFiltersSheet({
    required this.alertas,
    required this.selectedBairro,
    required this.selectedCidade,
    required this.selectedPeriodo,
    required this.selectedTipo,
    super.key,
  });

  final List<Alerta> alertas;
  final String? selectedBairro;
  final String? selectedCidade;
  final AlertPeriodo? selectedPeriodo;
  final AlertaTipo? selectedTipo;

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
        periodo: widget.selectedPeriodo,
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
            periodo: null,
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
                periodo: selection.periodo,
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
                periodo: selection.periodo,
                tipo: selection.tipo,
              ),
            ),
            DropdownButtonFormField<AlertPeriodo>(
              initialValue: selection.periodo,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Período',
                filled: true,
                fillColor: AppColors.neutral50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Todos')),
                ...AlertPeriodo.values.map(
                  (periodo) => DropdownMenuItem(
                    value: periodo,
                    child: Text(periodo.label),
                  ),
                ),
              ],
              onChanged: (value) => _selection.value = AlertFilterResult(
                bairro: selection.bairro,
                cidade: selection.cidade,
                periodo: value,
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
                periodo: selection.periodo,
                tipo: value,
              ),
            ),
          ],
        );
      },
    );
  }
}
