import 'package:flutter/material.dart';

import '../../domain/entities/camera.dart';
import 'filter_sheet_controls.dart';

class CameraFilterResult {
  const CameraFilterResult({
    required this.bairro,
    required this.cidade,
    required this.regiao,
  });

  final String? bairro;
  final String? cidade;
  final String? regiao;
}

class CameraFiltersSheet extends StatefulWidget {
  const CameraFiltersSheet({
    required this.cameras,
    required this.selectedBairro,
    required this.selectedCidade,
    required this.selectedRegiao,
    super.key,
  });

  final List<Camera> cameras;
  final String? selectedBairro;
  final String? selectedCidade;
  final String? selectedRegiao;

  @override
  State<CameraFiltersSheet> createState() => _CameraFiltersSheetState();
}

class _CameraFiltersSheetState extends State<CameraFiltersSheet> {
  late final ValueNotifier<CameraFilterResult> _selection;

  @override
  void initState() {
    super.initState();
    _selection = ValueNotifier(
      CameraFilterResult(
        bairro: widget.selectedBairro,
        cidade: widget.selectedCidade,
        regiao: widget.selectedRegiao,
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
      widget.cameras.map((camera) => camera.bairro),
    );
    final cidades = filterOptions(
      widget.cameras.map((camera) => camera.cidade),
    );
    final regioes = filterOptions(
      widget.cameras.map((camera) => camera.regiao),
    );

    return ValueListenableBuilder<CameraFilterResult>(
      valueListenable: _selection,
      builder: (context, selection, _) {
        return FilterSheetScaffold(
          title: 'Filtrar câmeras',
          children: [
            FilterDropdown(
              label: 'Bairro',
              value: bairros.contains(selection.bairro)
                  ? selection.bairro
                  : null,
              options: bairros,
              onChanged: (value) => _selection.value = CameraFilterResult(
                bairro: value,
                cidade: selection.cidade,
                regiao: selection.regiao,
              ),
            ),
            FilterDropdown(
              label: 'Cidade',
              value: cidades.contains(selection.cidade)
                  ? selection.cidade
                  : null,
              options: cidades,
              onChanged: (value) => _selection.value = CameraFilterResult(
                bairro: selection.bairro,
                cidade: value,
                regiao: selection.regiao,
              ),
            ),
            FilterDropdown(
              label: 'Região',
              value: regioes.contains(selection.regiao)
                  ? selection.regiao
                  : null,
              options: regioes,
              onChanged: (value) => _selection.value = CameraFilterResult(
                bairro: selection.bairro,
                cidade: selection.cidade,
                regiao: value,
              ),
            ),
          ],
          onClear: () {
            _selection.value = const CameraFilterResult(
              bairro: null,
              cidade: null,
              regiao: null,
            );
          },
          onApply: () => Navigator.of(context).pop(selection),
        );
      },
    );
  }
}
