// lib/data/topics/fundamental/enums.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent enumsTopic = TopicContent(
  title: 'Enumeradores (Enum)',
  code: '''// O que são Enums?
// Enums (ou Enumeradores) são tipos especiais que representam um conjunto
// fixo de valores nomeados. Eles tornam seu código mais legível e seguro,
// evitando o uso de "strings mágicas" ou números para representar estados.

// Exemplo 1: Definindo um Enum para Status de Tarefa
enum StatusTarefa {
  pendente,
  emAndamento,
  concluida,
  cancelada,
}

// Exemplo 2: Definindo um Enum para Nível de Dificuldade
enum NivelDificuldade {
  facil,
  medio,
  dificil,
  expert,
}

void main() {
  print('--- Exemplo: Status de Tarefa ---');
  StatusTarefa statusAtual = StatusTarefa.pendente;
  print('Status da tarefa: \$statusAtual'); // Saída: StatusTarefa.pendente

  // Você pode comparar valores de enum diretamente
  if (statusAtual == StatusTarefa.pendente) {
    print('A tarefa ainda não foi iniciada.');
  }

  // Acessando o nome do valor do enum como uma String
  print('Nome do status: \${statusAtual.name}'); // Saída: pendente

  // Alterando o status
  statusAtual = StatusTarefa.concluida;
  print('Novo status da tarefa: \$statusAtual');

  // Iterando sobre todos os valores de um enum
  print('\\n--- Todos os Status de Tarefa ---');
  for (var status in StatusTarefa.values) {
    print('- \$status');
  }

  print('\\n--- Exemplo: Nível de Dificuldade ---');
  NivelDificuldade nivelJogo = NivelDificuldade.medio;
  print('Nível de dificuldade escolhido: \$nivelJogo');

  // Convertendo uma String para um valor de Enum
  // Isso é feito iterando sobre os valores do enum e comparando o nome.
  String nivelString = 'dificil';
  NivelDificuldade? nivelConvertido;
  for (var nivel in NivelDificuldade.values) {
    if (nivel.name == nivelString) {
      nivelConvertido = nivel;
      break; // Encontrou, pode parar de procurar
    }
  }

  if (nivelConvertido != null) {
    print('Nível convertido de "\$nivelString": \$nivelConvertido');
  } else {
    print('Erro: Nível "\$nivelString" não encontrado no enum.');
  }

  String nivelInvalido = 'muito_dificil';
  NivelDificuldade? nivelInvalidoConvertido;
  for (var nivel in NivelDificuldade.values) {
    if (nivel.name == nivelInvalido) {
      nivelInvalidoConvertido = nivel;
      break; 
    }
  }

  if (nivelInvalidoConvertido != null) {
    print('Nível convertido de "\$nivelInvalido": \$nivelInvalidoConvertido');
  } else {
    print('Nível "\$nivelInvalido" não encontrado, valor padrão não atribuído.');
  }
}''',
  output: '''--- Exemplo: Status de Tarefa ---
Status da tarefa: StatusTarefa.pendente
A tarefa ainda não foi iniciada.
Nome do status: pendente
Novo status da tarefa: StatusTarefa.concluida

--- Todos os Status de Tarefa ---
- StatusTarefa.pendente
- StatusTarefa.emAndamento
- StatusTarefa.concluida
- StatusTarefa.cancelada

--- Exemplo: Nível de Dificuldade ---
Nível de dificuldade escolhido: NivelDificuldade.medio
Nível convertido de "dificil": NivelDificuldade.dificil
Nível "muito_dificil" não encontrado, valor padrão não atribuído.''',
  description:
      'Enumeradores (`enum`) em Dart são um tipo especial de classe que representa um conjunto fixo de constantes. Eles são usados para definir um grupo de valores nomeados que um tipo pode ter, tornando o código mais legível e evitando erros comuns de digitação. Você pode acessar os valores do enum, compará-los e iterar sobre eles. Cada valor do enum tem uma propriedade `.name` que retorna seu nome como uma String, facilitando a conversão de e para Strings.',
);
