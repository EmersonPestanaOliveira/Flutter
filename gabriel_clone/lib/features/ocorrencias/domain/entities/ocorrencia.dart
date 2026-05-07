class Ocorrencia {
  const Ocorrencia({
    required this.id,
    required this.userId,
    required this.informacoes,
    required this.quando,
    required this.horario,
    this.audio,
    this.descricao,
    this.boletimOcorrencia,
    this.multimidia = const [],
    this.latitude,
    this.longitude,
    this.status = 'em_andamento',
  });

  final String id;
  final String userId;
  final String informacoes;
  final DateTime quando;
  final String horario;
  final String? audio;
  final String? descricao;
  final String? boletimOcorrencia;
  final List<String> multimidia;
  final double? latitude;
  final double? longitude;

  /// 'em_andamento' | 'concluido' | 'invalido'
  final String status;
}
