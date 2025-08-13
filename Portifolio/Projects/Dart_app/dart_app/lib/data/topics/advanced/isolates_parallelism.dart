// lib/data/topics/advanced/isolates_parallelism.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados
import 'dart:isolate'; // Importa a biblioteca para trabalhar com Isolates

// Função que será executada em um Isolate separado.
// Ela recebe uma mensagem (que pode ser qualquer objeto) e usa um SendPort
// para enviar mensagens de volta para o Isolate principal.
void calcularPesado(SendPort sendPort) {
  // ignore: unused_local_variable
  int sum = 0;
  for (int i = 0; i <= 1000000000; i++) {
    // Um bilhão de iterações
    sum += i;
  }
  // Envia o resultado de volta para o Isolate principal
  sendPort.send('Cálculo pesado concluído: \$sum');
}

// Outra função para um Isolate, que recebe um número e o processa.
void processarDados(List<dynamic> message) {
  // O primeiro elemento da mensagem é o SendPort para resposta.
  SendPort replyPort = message[0];
  // O segundo elemento é o dado a ser processado (neste caso, um número).
  int data = message[1];

  // ignore: unused_local_variable
  int result = data * 2 + 5; // Simples processamento

  // Envia o resultado de volta.
  replyPort.send('Processado: \$data -> \$result');
}

final TopicContent isolatesParallelismTopic = TopicContent(
  title:
      'Isolates para Paralelismo e Threads', // Título explícito para exibição
  code: '''// Isolates para Paralelismo e Threads em Dart
// Diferente de muitas linguagens que usam threads compartilhando memória,
// Dart usa "Isolates". Um Isolate é como um pequeno universo isolado:
// ele tem sua própria área de memória e seu próprio event loop, e não compartilha
// memória com outros Isolates.
// A comunicação entre Isolates é feita apenas por meio de mensagens, garantindo
// que não haja problemas de concorrência como deadlocks ou race conditions,
// que são comuns em threads compartilhando memória.
// Isso é ideal para tarefas computacionalmente intensivas que não devem
// bloquear a UI principal (em Flutter, por exemplo).

import 'dart:isolate'; // Para criar e gerenciar Isolates
import 'dart:async'; // Para lidar com Futures e Streams (comunicação assíncrona)

// Função que será executada em um Isolate separado.
// Ela recebe uma mensagem (que pode ser qualquer objeto) e usa um SendPort
// para enviar mensagens de volta para o Isolate principal.
void heavyComputation(SendPort sendPort) {
  int sum = 0;
  for (int i = 0; i <= 2000000000; i++) { // Duas bilhões de iterações para simular carga
    sum += i;
  }
  sendPort.send('Resultado do cálculo pesado: \$sum');
}

// Função para Isolate que recebe uma lista de números e retorna a soma.
void sumNumbersIsolate(SendPort sendPort) {
  // Cria uma porta de recebimento para o Isolate ouvir mensagens do Isolate principal.
  ReceivePort receivePort = ReceivePort();
  // Envia o SendPort deste Isolate para o Isolate principal, para que ele possa enviar dados.
  sendPort.send(receivePort.sendPort);

  // Escuta por mensagens. A primeira mensagem esperada é a lista de números.
  receivePort.listen((message) {
    if (message is List<int>) {
      int total = message.reduce((a, b) => a + b);
      // Envia o resultado de volta para o Isolate principal através do SendPort original.
      sendPort.send(total);
      // Fecha a porta após o processamento, se não houver mais mensagens esperadas.
      receivePort.close();
    }
  });
}


void main() async {
  print('--- Demonstração de Isolate para Tarefa Pesada ---');

  // Criar uma porta de recebimento para o Isolate principal ouvir mensagens.
  ReceivePort receivePort = ReceivePort();

  // Iniciar um novo Isolate.
  // `spawn` é um método estático que cria um novo Isolate e o inicializa com uma função.
  // A função passada (`heavyComputation` neste caso) deve ser uma função de nível superior
  // ou um método estático (não pode ser uma função anônima ou método de instância).
  Isolate newIsolate = await Isolate.spawn(heavyComputation, receivePort.sendPort);

  print('Isolate principal: Começando tarefa leve...');
  // Simular alguma outra tarefa que o Isolate principal pode fazer enquanto o outro calcula.
  for (int i = 0; i < 5; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    print('Isolate principal: Executando tarefa leve \$i...');
  }

  // Esperar pela mensagem do Isolate recém-criado.
  // `first` obtém o primeiro elemento da Stream.
  String result = await receivePort.first;
  print('Isolate principal: Recebido do Isolate: \$result');

  // Importante: Matar o Isolate quando não for mais necessário para liberar recursos.
  newIsolate.kill(priority: Isolate.immediate);
  print('Isolate de cálculo pesado finalizado.');


  print('\\n--- Demonstração de Comunicação Bi-Direcional com Isolate ---');
  ReceivePort mainReceivePort = ReceivePort();
  Isolate sumIsolate = await Isolate.spawn(sumNumbersIsolate, mainReceivePort.sendPort);

  // A primeira mensagem que o Isolate principal recebe é o SendPort do Isolate de soma.
  SendPort? sumIsolateSendPort;
  await for (var msg in mainReceivePort) {
    if (msg is SendPort) {
      sumIsolateSendPort = msg;
      break; // Temos o SendPort, podemos sair do loop.
    }
  }

  if (sumIsolateSendPort != null) {
    List<int> numbersToSend = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    print('Isolate principal: Enviando números para o Isolate de soma: \$numbersToSend');

    // Envia a lista de números para o Isolate de soma.
    sumIsolateSendPort.send(numbersToSend);

    // Espera pelo resultado da soma.
    int sumResult = await mainReceivePort.first;
    print('Isolate principal: Soma recebida do Isolate: \$sumResult');
  }

  sumIsolate.kill(priority: Isolate.immediate);
  mainReceivePort.close(); // Fechar a porta principal após o uso.
  print('Isolate de soma finalizado.');
}''',
  output: '''--- Demonstração de Isolate para Tarefa Pesada ---
Isolate principal: Começando tarefa leve...
Isolate principal: Executando tarefa leve 0...
Isolate principal: Executando tarefa leve 1...
Isolate principal: Executando tarefa leve 2...
Isolate principal: Executando tarefa leve 3...
Isolate principal: Executando tarefa leve 4...
Isolate principal: Recebido do Isolate: Resultado do cálculo pesado: 1000000001000000000
Isolate de cálculo pesado finalizado.

--- Demonstração de Comunicação Bi-Direcional com Isolate ---
Isolate principal: Enviando números para o Isolate de soma: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
Isolate principal: Soma recebida do Isolate: 55
Isolate de soma finalizado.''',
  description:
      'Em Dart, o paralelismo é alcançado através de `Isolates`, que são unidades de execução completamente isoladas, com sua própria memória e loop de eventos. Diferente de threads tradicionais que compartilham memória, Isolates se comunicam exclusivamente por troca de mensagens (usando `SendPort` e `ReceivePort`). Essa arquitetura "share-nothing" (não compartilhar nada) elimina problemas de concorrência como race conditions e deadlocks, tornando o código concorrente mais seguro e fácil de depurar. Isolates são ideais para executar tarefas computacionalmente intensivas em segundo plano, sem bloquear o thread principal da UI.',
);
