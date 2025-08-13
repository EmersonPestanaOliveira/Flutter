// lib/data/topics/advanced/generators.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados

final TopicContent generatorsTopic = TopicContent(
  title: 'Geradores (Generators)', // Título explícito para exibição
  code: '''// Geradores (Generators) em Dart
// Geradores são funções especiais que produzem uma sequência de valores
// (geralmente sob demanda, ou "lazy") usando a palavra-chave `yield`.
// Eles podem ser de dois tipos:
// 1. Geradores Síncronos: Retornam um `Iterable` (sequência de valores síncrona).
//    Usam `sync*` e `yield`.
// 2. Geradores Assíncronos: Retornam um `Stream` (sequência de valores assíncrona).
//    Usam `async*` e `yield`.

// Exemplo 1: Gerador Síncrono
// Gera números de 1 até um determinado limite.
Iterable<int> contarSincronamente(int limite) sync* {
  for (int i = 1; i <= limite; i++) {
    yield i; // Pausa a execução e "cede" (yields) um valor.
             // Quando o próximo valor for solicitado, a execução continua a partir daqui.
  }
}

// Exemplo 2: Gerador Síncrono que gera uma sequência infinita (cuidado ao usar!).
// Pode ser útil com operadores como `take`.
Iterable<int> numerosPares() sync* {
  int num = 0;
  while (true) {
    yield num;
    num += 2;
  }
}

// Exemplo 3: Gerador Assíncrono
// Gera números com um pequeno atraso, útil para fluxos de dados contínuos.
Stream<int> contarAssincronamente(int limite) async* {
  for (int i = 1; i <= limite; i++) {
    await Future.delayed(Duration(milliseconds: 500)); // Simula uma operação assíncrona
    yield i; // Cede o valor para o Stream
  }
}

// Exemplo 4: Gerador Assíncrono que filtra valores.
Stream<String> filtrarNomes(List<String> nomes) async* {
  for (var nome in nomes) {
    if (nome.startsWith('A')) {
      yield nome;
      await Future.delayed(Duration(milliseconds: 100)); // Pequeno atraso entre os yields
    }
  }
}

void main() async { // main é async para poder usar await com Streams
  print('--- Exemplo de Gerador Síncrono (Iterable) ---');
  Iterable<int> contagem = contarSincronamente(5);
  // Os valores são gerados apenas quando solicitados (lazy evaluation).
  print('Contagem síncrona:');
  for (var numero in contagem) {
    print(numero);
  }

  print('\\n--- Usando Gerador Síncrono com take (Sequência Infinita) ---');
  Iterable<int> pares = numerosPares().take(10); // Pega apenas os primeiros 10 pares
  print('Os 10 primeiros números pares: \${pares.toList()}');

  print('\\n--- Exemplo de Gerador Assíncrono (Stream) ---');
  Stream<int> contagemAssincrona = contarAssincronamente(3);
  print('Iniciando contagem assíncrona...');
  // Para consumir um Stream, usamos `await for`
  await for (var numero in contagemAssincrona) {
    print('Número assíncrono: \$numero');
  }
  print('Contagem assíncrona concluída.');

  print('\\n--- Exemplo de Gerador Assíncrono com Filtragem ---');
  List<String> nomes = ['Alice', 'Bob', 'Ana', 'Carlos', 'Amanda'];
  Stream<String> nomesFiltrados = filtrarNomes(nomes);
  print('Nomes começando com "A":');
  await for (var nome in nomesFiltrados) {
    print('Encontrado: \$nome');
  }
  print('Filtragem de nomes concluída.');
}''',
  output: '''--- Exemplo de Gerador Síncrono (Iterable) ---
Contagem síncrona:
1
2
3
4
5

--- Usando Gerador Síncrono com take (Sequência Infinita) ---
Os 10 primeiros números pares: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]

--- Exemplo de Gerador Assíncrono (Stream) ---
Iniciando contagem assíncrona...
Número assíncrono: 1
Número assíncrono: 2
Número assíncrono: 3
Contagem assíncrona concluída.

--- Exemplo de Gerador Assíncrono com Filtragem ---
Nomes começando com "A":
Encontrado: Alice
Encontrado: Ana
Encontrado: Amanda
Filtragem de nomes concluída.''',
  description:
      'Geradores em Dart são funções especiais que produzem uma sequência de valores usando a palavra-chave `yield`. Eles são ideais para criar sequências de dados "sob demanda" (lazy evaluation), o que pode economizar memória e melhorar a performance, especialmente para coleções grandes ou infinitas. Geradores síncronos (definidos com `sync*`) retornam um `Iterable`, enquanto geradores assíncronos (definidos com `async*`) retornam um `Stream`, sendo este último útil para processar fluxos de dados assíncronos (como dados de rede ou eventos).',
);
