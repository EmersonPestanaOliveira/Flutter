class Resultado {
  const Resultado({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.cidade,
    required this.data,
    this.imagemUrl,
    this.conteudo,
  });

  final String id;
  final String titulo;

  /// 'casos_solucionados' | 'novidades'
  final String categoria;
  final String cidade;
  final DateTime data;
  final String? imagemUrl;
  final String? conteudo;

  bool get isNovidade => categoria == 'novidades';
}
