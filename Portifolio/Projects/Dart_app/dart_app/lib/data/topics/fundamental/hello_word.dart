// lib/data/topics/fundamental/hello_world.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent helloWorldTopic = TopicContent(
  title: 'Olá Mundo!', // Título explícito para exibição
  code: '''void main() {
  print('Olá, Mundo!');
}''',
  output: '''Olá, Mundo!''',
  description:
      'Este é o programa "Olá, Mundo!" mais simples em Dart. A função `main()` é o ponto de entrada do seu aplicativo.',
);
