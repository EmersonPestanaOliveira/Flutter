import '../../../../core/utils/text_normalizer.dart';

enum AlertaTipo {
  violencia,
  acidente,
  rouboFurtoVeiculo,
  rouboFurto,
  estelionato,
  vandalismo,
  invasao,
  outros,
}

AlertaTipo alertaTipoFromString(String value) {
  for (final tipo in AlertaTipo.values) {
    if (value == tipo.name || value == tipo.label) {
      return tipo;
    }
  }

  final normalized = normalizeSearchText(
    value,
    collapseWhitespace: true,
    separatorsAsSpaces: true,
  );

  if (normalized == 'violencia') {
    return AlertaTipo.violencia;
  }
  if (normalized == 'acidente') {
    return AlertaTipo.acidente;
  }
  if (normalized == 'roubo ou furto de veiculos' ||
      normalized == 'roubo furto veiculo' ||
      normalized == 'roubo furtoveiculo' ||
      normalized == 'roubofurtoveiculo') {
    return AlertaTipo.rouboFurtoVeiculo;
  }
  if (normalized == 'roubo ou furto' ||
      normalized == 'roubo furto' ||
      normalized == 'roubofurto') {
    return AlertaTipo.rouboFurto;
  }
  if (normalized == 'estelionato') {
    return AlertaTipo.estelionato;
  }
  if (normalized == 'vandalismo') {
    return AlertaTipo.vandalismo;
  }
  if (normalized == 'invasao') {
    return AlertaTipo.invasao;
  }

  return AlertaTipo.outros;
}

extension AlertaTipoX on AlertaTipo {
  String get label {
    return switch (this) {
      AlertaTipo.violencia => 'Violência',
      AlertaTipo.acidente => 'Acidente',
      AlertaTipo.rouboFurtoVeiculo => 'Roubo ou Furto de Veículos',
      AlertaTipo.rouboFurto => 'Roubo ou Furto',
      AlertaTipo.estelionato => 'Estelionato',
      AlertaTipo.vandalismo => 'Vandalismo',
      AlertaTipo.invasao => 'Invasão',
      AlertaTipo.outros => 'Outros',
    };
  }
}
