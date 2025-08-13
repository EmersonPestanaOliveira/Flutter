// lib/data/topics/advanced/async_await.dart

import 'package:dart_app/data/study_data_model.dart';

final TopicContent asyncAwaitTopic = TopicContent(
  title: 'Assíncrona (Async/Await)',
  code:
      '''// Async/Await é usado para lidar com operações que levam tempo para serem
// concluídas, como requisições de rede, leitura de arquivos ou acesso a banco de dados,
// sem "congelar" a interface do usuário.

// Uma função marcada com 'async' pode usar a palavra-chave 'await'.
// 'await' pausa a execução da função 'async' até que a 'Future' (operação assíncrona)
// seja concluída, sem bloquear a thread principal.

// Simula uma operação que leva 2 segundos para buscar dados
Future<String> buscarDadosOnline() async {
  print('  [1] Buscando dados online...');
  // Future.delayed simula um atraso, como uma requisição de rede.
  await Future.delayed(Duration(seconds: 2));
  print('  [2] Dados recebidos!');
  return 'Dados do Usuário: João Silva';
}

// Simula outra operação que leva 1 segundo para processar algo
Future<bool> processarInformacao(String info) async {
  print('  [3] Processando informação: "\$info"...');
  await Future.delayed(Duration(seconds: 1));
  print('  [4] Informação processada com sucesso.');
  return true;
}

void main() async {
  print('Início da execução do programa (Main Thread).');

  // Usando await para esperar a conclusão de buscarDadosOnline()
  String dados = await buscarDadosOnline();
  print('Resultado da busca: \$dados');

  // Continua a execução após a primeira Future ser concluída
  bool sucesso = await processarInformacao('Relatório XYZ');
  print('Processamento concluído com sucesso? \$sucesso');

  print('Fim da execução do programa (Main Thread).');
}''',
  output: '''Início da execução do programa (Main Thread).
  [1] Buscando dados online...
(Espera 2 segundos)
  [2] Dados recebidos!
Resultado da busca: Dados do Usuário: João Silva
  [3] Processando informação: "Relatório XYZ"...
(Espera 1 segundo)
  [4] Informação processada com sucesso.
Processamento concluído com sucesso? true
Fim da execução do programa (Main Thread).''',
  description:
      'A programação assíncrona com `async` e `await` é essencial em Dart para lidar com operações de longa duração de forma não-bloqueante. A palavra-chave `async` marca uma função como assíncrona, permitindo o uso de `await` dentro dela. `await` pausa a execução da função assíncrona até que uma `Future` (representando uma operação assíncrona) seja concluída, garantindo que o programa continue responsivo.',
);
