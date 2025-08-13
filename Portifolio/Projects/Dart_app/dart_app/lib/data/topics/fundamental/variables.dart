// lib/data/topics/fundamental/variables.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent variablesTopic = TopicContent(
  title: 'Variáveis',
  code: '''void main() {
  // Inteiro
  int idade = 30;
  print('Idade: \$idade');

  // String
  String nome = 'Alice';
  print('Nome: \$nome');

  // Double
  double altura = 1.75;
  print('Altura: \$altura');

  // Booleano
  bool estaAtivo = true;
  print('Está ativo: \$estaAtivo');

  // Variável dinâmica
  var preco = 10.99;
  print('Preço: \$preco');

  // Variável dinâmica com tipo inferido
  dynamic dado = 'Olá';
  print('Dado (String): \$dado');
  dado = 123;
  print('Dado (int): \$dado');
}''',
  output: '''Idade: 30
Nome: Alice
Altura: 1.75
Está ativo: true
Preço: 10.99
Dado (String): Olá
Dado (int): 123''',
  description:
      'Dart suporta vários tipos de variáveis. `var` infere o tipo e `dynamic` permite que a variável mude de tipo.',
);
