// lib/data/topics/fundamental/conditional_structures.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent conditionalStructuresTopic = TopicContent(
  title: 'Estruturas Condicionais',
  code: '''void main() {
  int idade = 18;
  String clima = 'chuvoso';
  bool temCafe = true;

  print('--- if, else if, else ---');
  if (idade >= 18) {
    print('Você é maior de idade.');
  } else if (idade >= 12) {
    print('Você é um adolescente.');
  } else {
    print('Você é uma criança.');
  }

  print('\\n--- switch case ---');
  switch (clima) {
    case 'ensolarado':
      print('Dia perfeito para um passeio!');
      break;
    case 'chuvoso':
      print('Melhor ficar em casa com um bom livro.');
      break;
    case 'nublado':
      print('Pode sair, mas leve um agasalho.');
      break;
    default:
      print('Clima desconhecido.');
  }

  print('\\n--- Operador Ternário (?:) ---');
  // condição ? valor_se_verdadeiro : valor_se_falso
  String statusCafe = temCafe ? 'Café disponível!' : 'Sem café.';
  print(statusCafe);

  int numero = 7;
  String tipoNumero = (numero % 2 == 0) ? 'par' : 'ímpar';
  print('O número \$numero é \$tipoNumero.');

  print('\\n--- if com null-aware (??) ---');
  String? nomeUsuario; // Pode ser null
  String nomeExibicao = nomeUsuario ?? 'Convidado'; // Se nomeUsuario for null, usa 'Convidado'
  print('Nome de exibição: \$nomeExibicao');

  String? cidadeUsuario = 'São Paulo';
  String cidadeExibicao = cidadeUsuario ?? 'Desconhecida';
  print('Cidade de exibição: \$cidadeExibicao');
}''',
  output: '''--- if, else if, else ---
Você é maior de idade.

--- switch case ---
Melhor ficar em casa com um bom livro.

--- Operador Ternário (?:) ---
Café disponível!
O número 7 é ímpar.

--- if com null-aware (??) ---
Nome de exibição: Convidado
Cidade de exibição: São Paulo''',
  description:
      'Estruturas condicionais permitem que o fluxo de execução do seu programa mude com base em certas condições. As principais são `if-else if-else` para múltiplas condições, `switch-case` para comparar um valor com múltiplos casos, e o operador ternário `?:` para atribuições condicionais concisas. O operador `??` (null-aware) é útil para fornecer um valor padrão se uma variável for nula.',
);
