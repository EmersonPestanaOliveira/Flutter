// lib/data/topics/fundamental/constants.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent constantsTopic = TopicContent(
  title: 'Constantes',
  code: '''void main() {
  // const: O valor deve ser conhecido em tempo de compilação.
  // É usada para valores que nunca mudarão e são fixos.
  const double pi = 3.14159;
  const String appName = 'Meu App Dart';
  const int maxAttempts = 3;

  print('Valor de Pi: \$pi');
  print('Nome do Aplicativo: \$appName');
  print('Tentativas máximas: \$maxAttempts');

  // final: O valor é atribuído apenas uma vez, em tempo de execução.
  // É usada para valores que não mudarão após a primeira atribuição.
  final DateTime now = DateTime.now(); // O valor só é conhecido em tempo de execução
  final String userId = obterIdUsuario(); // Resultado de uma função

  print('Hora atual (final): \$now');
  print('ID do Usuário (final): \$userId');

  // Diferenças principais:
  // - 'const' é uma constante em tempo de compilação.
  // - 'final' é uma variável que só pode ser atribuída uma vez.
  // Você não pode reatribuir um valor a uma variável 'const' ou 'final' depois de inicializada.

  // Exemplo de erro (descomente para ver o erro):
  // pi = 3.0; // Erro: Não pode atribuir a uma variável const
  // now = DateTime.now(); // Erro: Não pode atribuir a uma variável final
}

String obterIdUsuario() {
  // Simula a obtenção de um ID de usuário, que pode ser gerado dinamicamente
  return 'user_abc_123';
}''',
  output: '''Valor de Pi: 3.14159
Nome do Aplicativo: Meu App Dart
Tentativas máximas: 3
Hora atual (final): <data e hora atual>
ID do Usuário (final): user_abc_123''', // A hora vai variar na execução
  description:
      'Em Dart, `const` e `final` são usadas para definir valores que não podem ser alterados após a inicialização. `const` é para constantes em tempo de compilação (valores fixos conhecidos antes da execução), enquanto `final` é para variáveis que são atribuídas uma única vez em tempo de execução. Ambas garantem imutabilidade.',
);
