// lib/data/topics/fundamental/comments.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent commentsTopic = TopicContent(
  title: 'Comentários', // Título explícito para exibição
  code: '''void main() {
  // Este é um comentário de linha única.

  /*
   * Este é um comentário de múltiplas linhas.
   * Ele pode cobrir várias linhas de código.
   * Geralmente usado para blocos de código ou explicações mais longas.
   */

  /// Este é um comentário de documentação.
  /// Ele é usado para gerar a documentação do seu código
  /// que pode ser vista em IDEs ou gerada para HTML.
  print('Exemplo de comentários em Dart'); // Você pode comentar no final da linha também!
}''',
  output: '''Exemplo de comentários em Dart''',
  description:
      'Comentários são trechos de texto ignorados pelo compilador de Dart. Eles são essenciais para documentar seu código, explicar sua lógica e torná-lo mais compreensível para você e para outros desenvolvedores. Existem três tipos principais de comentários em Dart: de linha única, de múltiplas linhas e de documentação.',
);
