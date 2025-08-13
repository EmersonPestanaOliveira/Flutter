// lib/data/topics/advanced/futures_error_handling.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados
import 'dart:async'; // Para Future e seus métodos
import 'dart:math'; // Para simular sucesso/falha aleatória

// --- Funções que retornam Futures ---

// 1. Future que simula uma operação de sucesso após um atraso.
Future<String> simularDownloadDados() {
  print('Simulando download de dados...');
  return Future.delayed(
      Duration(seconds: 2), () => 'Dados baixados com sucesso!');
}

// 2. Future que simula uma operação que pode falhar.
Future<int> simularProcessamentoDados(int dado) {
  print('Simulando processamento de dados (recebido: \$dado)...');
  return Future.delayed(Duration(seconds: 1), () {
    if (dado % 2 != 0) {
      // Simula falha se o dado for ímpar
      throw Exception('Erro: Dado ímpar não pode ser processado.');
    }
    return dado * 10;
  });
}

// 3. Future que simula uma operação com erro de conexão.
Future<bool> verificarConexao() {
  print('Verificando conexão...');
  return Future.delayed(Duration(milliseconds: 500), () {
    var random = Random();
    if (random.nextBool()) {
      // 50% de chance de falha
      throw TimeoutException('Tempo limite de conexão excedido.');
    }
    return true;
  });
}

final TopicContent futuresErrorHandlingTopic = TopicContent(
  title: 'Futures e Tratamento de Erros', // Título explícito para exibição
  code: '''// Futures e Tratamento de Erros em Dart
// Em Dart, operações assíncronas (que levam tempo e não bloqueiam o thread principal)
// são representadas por objetos `Future`. Um `Future` representa o resultado
// (ou um erro) de uma operação assíncrona que ainda não foi concluída.
// Métodos como `then()`, `catchError()`, `whenComplete()` e as palavras-chave
// `async`/`await` são usados para lidar com Futures e seus resultados.

import 'dart:async'; // Para Future e seus métodos
import 'dart:math'; // Para simular sucesso/falha aleatória

// 1. Future que simula uma operação de sucesso após um atraso.
Future<String> downloadData() {
  print('Iniciando download...');
  return Future.delayed(Duration(seconds: 2), () => 'Dados baixados com sucesso!');
}

// 2. Future que simula uma operação que pode falhar.
Future<int> processData(int input) {
  print('Processando dado \$input...');
  return Future.delayed(Duration(seconds: 1), () {
    if (input % 2 != 0) {
      throw ArgumentError('Erro de processamento: Dado ímpar (\$input) não permitido.');
    }
    return input * 2;
  });
}

// 3. Future que simula uma operação com erro de conexão.
Future<bool> checkConnection() {
  print('Verificando conexão...');
  return Future.delayed(Duration(milliseconds: 500), () {
    var random = Random();
    if (random.nextBool()) { // 50% de chance de falha
      throw TimeoutException('Tempo limite de conexão excedido.');
    }
    return true;
  });
}

void main() async { // O main precisa ser 'async' para usar 'await'
  print('--- Exemplo 1: Future com Sucesso e then() ---');
  await downloadData().then((data) {
    print('Sucesso: \$data');
  }).catchError((error) {
    print('Erro inesperado no download: \$error');
  }).whenComplete(() {
    print('Download finalizado (com ou sem erro).');
  });

  print('\\n--- Exemplo 2: Future com async/await e try-catch ---');
  try {
    String data = await downloadData(); // Espera o Future ser resolvido
    print('Sucesso com async/await: \$data');

    int processed = await processData(10); // Dado par, deve ter sucesso
    print('Processamento OK: \$processed');

    processed = await processData(7); // Dado ímpar, deve falhar
    print('Processamento OK: \$processed'); // Esta linha não será atingida
  } on ArgumentError catch (e) { // Captura um tipo específico de erro
    print('Erro específico (ArgumentError): \${e.message}');
  } catch (e) { // Captura qualquer outra exceção
    print('Erro genérico: \$e');
  } finally {
    print('Bloco try-catch finalizado (processamento).');
  }

  print('\\n--- Exemplo 3: Lidando com múltiplos erros (sequência) ---');
  try {
    bool connected = await checkConnection();
    print('Conexão: \$connected');
    String data = await downloadData();
    print('Dados: \$data');
  } on TimeoutException catch (e) {
    print('Erro de conexão: \${e.message}');
  } catch (e) {
    print('Erro geral na sequência: \$e');
  } finally {
    print('Sequência de operações finalizada.');
  }

  print('\\n--- Future.value e Future.error ---');
  // Cria um Future que já é resolvido com um valor.
  Future<String> instantSuccess = Future.value('Operação instantânea bem-sucedida.');
  print(await instantSuccess);

  // Cria um Future que já é resolvido com um erro.
  Future<int> instantError = Future.error(StateError('O estado não permite esta operação.'));
  try {
    await instantError;
  } on StateError catch(e) {
    print('Erro instantâneo: \${e.message}');
  }

  print('\\n--- Future.wait para múltiplos Futures ---');
  // Executa múltiplos Futures em paralelo e espera que todos completem.
  try {
    List<String> results = await Future.wait([
      downloadData(),
      Future.delayed(Duration(seconds: 1), () => 'Outra tarefa concluída.'),
    ]);
    print('Todos os Futures concluíram: \${results.join(' | ')}');
  } catch (e) {
    print('Um ou mais Futures falharam em Future.wait: \$e');
  }
}''',
  output: '''--- Exemplo 1: Future com Sucesso e then() ---
Iniciando download...
Sucesso: Dados baixados com sucesso!
Download finalizado (com ou sem erro).

--- Exemplo 2: Future com async/await e try-catch ---
Iniciando download...
Sucesso com async/await: Dados baixados com sucesso!
Processando dado 10...
Processamento OK: 20
Processando dado 7...
Erro específico (ArgumentError): Erro de processamento: Dado ímpar (7) não permitido.
Bloco try-catch finalizado (processamento).

--- Exemplo 3: Lidando com múltiplos erros (sequência) ---
Verificando conexão...
Conexão: true
Iniciando download...
Dados: Dados baixados com sucesso!
Sequência de operações finalizada.

--- Future.value e Future.error ---
Operação instantânea bem-sucedida.
Erro instantâneo: O estado não permite esta operação.

--- Future.wait para múltiplos Futures ---
Iniciando download...
Todos os Futures concluíram: Dados baixados com sucesso! | Outra tarefa concluída.''',
  description:
      'Em Dart, `Future` é a classe central para lidar com operações assíncronas que produzirão um valor (ou um erro) em algum momento no futuro. O tratamento de erros com Futures pode ser feito de duas maneiras principais: encadeando `.catchError()` após `.then()`, ou usando o bloco `try-catch` em conjunto com as palavras-chave `async` e `await`. As funções `async` retornam implicitamente um `Future`, e `await` pausa a execução até que um `Future` seja concluído. `Future.value` e `Future.error` criam Futures já resolvidos, e `Future.wait` executa múltiplos Futures em paralelo, esperando por todos eles.',
);
