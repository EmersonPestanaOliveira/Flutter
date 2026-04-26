enum AlertaTipo {
  violencia,
  acidente,
  rouboFurtoVeiculo,
  rouboFurto,
  estelionato,
  vandalismo,
  invasao,
  outros;
}

AlertaTipo alertaTipoFromString(String value) {
  final normalized = value
      .trim()
      .toLowerCase()
      .replaceAll('ê', 'e')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ã', 'a')
      .replaceAll('á', 'a')
      .replaceAll('ç', 'c')
      .replaceAll('-', ' ')
      .replaceAll('_', ' ');

  if (normalized == 'violencia') {
    return AlertaTipo.violencia;
  }
  if (normalized == 'acidente') {
    return AlertaTipo.acidente;
  }
  if (normalized == 'roubo ou furto de veiculos' ||
      normalized == 'roubo furto veiculo' ||
      normalized == 'roubo furtoveiculo') {
    return AlertaTipo.rouboFurtoVeiculo;
  }
  if (normalized == 'roubo ou furto' || normalized == 'roubo furto') {
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
      AlertaTipo.violencia => 'Violencia',
      AlertaTipo.acidente => 'Acidente',
      AlertaTipo.rouboFurtoVeiculo => 'Roubo ou Furto de Veiculos',
      AlertaTipo.rouboFurto => 'Roubo ou Furto',
      AlertaTipo.estelionato => 'Estelionato',
      AlertaTipo.vandalismo => 'Vandalismo',
      AlertaTipo.invasao => 'Invasao',
      AlertaTipo.outros => 'Outros',
    };
  }
}