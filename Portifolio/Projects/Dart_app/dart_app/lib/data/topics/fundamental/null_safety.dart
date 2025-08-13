// lib/data/topics/fundamental/null_safety.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent nullSafetyTopic = TopicContent(
  title: 'Null Safety (Segurança contra null)',
  code: '''void main() {
  // 1. Tipos Não-Nulos (Non-nullable by default)
  // int idade = null; // Erro: Um int não pode ser null por padrão.
  int idade = 30;
  print('Idade: \$idade');

  // 2. Tipos Nulos (Nullable types)
  // Use '?' para indicar que uma variável pode ser null.
  String? nome; // 'nome' pode ser uma String ou null
  print('Nome (antes da atribuição): \$nome');
  nome = 'Alice';
  print('Nome (depois da atribuição): \$nome');
  nome = null;
  print('Nome (depois de null): \$nome');

  // 3. Operador de Promoção de Tipo (Null check)
  // Dart pode "promover" um tipo nulo para não-nulo após uma verificação.
  String? sobrenome = 'Silva';
  if (sobrenome != null) {
    // Dentro deste bloco, 'sobrenome' é tratado como String (não-nula).
    print('Sobrenome (promoção de tipo): \${sobrenome.toUpperCase()}');
  }

  // 4. Operador de Assert (Asserção de não-nulo) - '!'
  // Use quando você tem certeza que a variável não será null.
  // Se for null em runtime, lança um erro. Use com cautela!
  String? maybeName = 'Bob';
  String sureName = maybeName!; // "Tenho certeza que não é null!"
  print('Sure Name: \$sureName');

  String? anotherMaybeName;
  // String crash = anotherMaybeName!; // Descomente para ver o erro em tempo de execução

  // 5. Operador Null-aware de Acesso a Membro (?.)
  // Acessa um membro APENAS se o objeto não for null.
  String? textoLongo;
  int? comprimento = textoLongo?.length; // comprimento será null
  print('Comprimento do textoLongo: \$comprimento');

  String? textoCurto = 'Dart';
  int? comprimentoCurto = textoCurto?.length; // comprimentoCurto será 4
  print('Comprimento do textoCurto: \$comprimentoCurto');

  // 6. Operador Null-aware de Atribuição (??=)
  // Atribui um valor APENAS se a variável for null.
  String? configuracao;
  configuracao ??= 'default_value'; // configuracao será 'default_value'
  print('Configuração 1: \$configuracao');

  configuracao = 'user_value';
  configuracao ??= 'another_default'; // não atribui, pois 'user_value' não é null
  print('Configuração 2: \$configuracao');

  // 7. Operador Null-Coalescing (??)
  // Retorna o operando esquerdo se não for null; caso contrário, retorna o direito.
  String? userPreference;
  String finalSetting = userPreference ?? 'system_default';
  print('Configuração final: \$finalSetting');

  String userPreference2 = 'custom_setting';
  String finalSetting2 = userPreference2 ?? 'system_default';
  print('Configuração final 2: \$finalSetting2');
}''',
  output: '''Idade: 30
Nome (antes da atribuição): null
Nome (depois da atribuição): Alice
Nome (depois de null): null
Sobrenome (promoção de tipo): SILVA
Sure Name: Bob
Comprimento do textoLongo: null
Comprimento do textoCurto: 4
Configuração 1: default_value
Configuração 2: user_value
Configuração final: system_default
Configuração final 2: custom_setting''',
  description:
      'Null Safety em Dart é um recurso poderoso que ajuda a prevenir erros de tempo de execução relacionados a valores nulos. Por padrão, as variáveis não podem ser nulas. Para permitir que uma variável seja nula, você usa o operador `?`. Dart oferece vários operadores (`!`, `?.`, `??=`, `??`) para lidar com valores nulos de forma segura e explícita, promovendo código mais robusto e previsível.',
);
