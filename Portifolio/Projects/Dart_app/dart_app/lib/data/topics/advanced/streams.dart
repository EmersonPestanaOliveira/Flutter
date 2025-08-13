// lib/data/topics/advanced/streams.dart

import 'package:dart_app/data/study_data_model.dart'; // Importação do modelo de dados

final TopicContent streamsTopic = TopicContent(
  title: 'Streams (Fluxos de Dados)', // Título explícito para exibição
  code: '''// Streams (Fluxos de Dados) em Dart
// Um `Stream` é uma sequência de eventos ou dados assíncronos.
// Pense em um Stream como uma "mangueira" de dados por onde valores podem fluir ao longo do tempo.
// Eles são usados para lidar com eventos contínuos, como cliques do mouse,
// dados de rede, eventos de banco de dados, ou até mesmo resultados de cálculos pesados.
// Streams podem ser:
// - Single-subscription (assinatura única): Podem ter apenas um ouvinte. Uma vez que o ouvinte
//   começa a ouvir, ele consome os eventos e o Stream se "fecha" para outros ouvintes.
// - Broadcast (transmissão): Podem ter múltiplos ouvintes. Os eventos são enviados para todos
//   os ouvintes ativos simultaneamente.

// --- 1. Criando Streams com StreamController (a forma mais comum) ---
// StreamController é a ferramenta mais flexível para criar e gerenciar Streams.
// Ele tem um `sink` para adicionar eventos e um `stream` para ouvir eventos.

// Criando um StreamController Single-subscription
StreamController<int> singleController = StreamController<int>();

// Criando um StreamController Broadcast
StreamController<String> broadcastController = StreamController<String>.broadcast();

// --- 2. Criando Streams a partir de Geradores Assíncronos (async*) ---
// Já vimos isso no tópico de Geradores, mas vale reforçar.
Stream<int> contarAte(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(milliseconds: 200));
    yield i;
  }
}

// --- 3. Escutando e Reagindo a Eventos de Stream ---

void main() async {
  print('--- Stream Single-Subscription com StreamController ---');
  // Obter o Stream do controlador
  Stream<int> singleStream = singleController.stream;

  // Assinar o Stream. Apenas uma assinatura é permitida.
  singleStream.listen(
    (data) => print('Single: Recebido \$data'),
    onError: (error) => print('Single: Erro! \$error'),
    onDone: () => print('Single: Stream single-subscription finalizada.'),
    cancelOnError: true, // Se ocorrer um erro, cancela a assinatura.
  );

  // Adicionar eventos ao sink do controlador
  singleController.sink.add(10);
  await Future.delayed(Duration(milliseconds: 100)); // Pequeno delay
  singleController.sink.add(20);
  await Future.delayed(Duration(milliseconds: 100));
  singleController.sink.add(30);
  singleController.sink.addError('Algo deu errado no single stream!'); // Adiciona um erro
  singleController.sink.add(40); // Este não será processado se cancelOnError for true
  await singleController.close(); // Fechar o sink para indicar que não há mais eventos
  await Future.delayed(Duration(milliseconds: 500)); // Aguardar onDone


  print('\\n--- Stream Broadcast com StreamController e Múltiplos Ouvintes ---');
  Stream<String> broadcastStream = broadcastController.stream;

  // Ouvinte 1
  broadcastStream.listen((data) {
    print('Broadcast Ouvinte 1: \$data');
  }, onError: (e) => print('Broadcast Ouvinte 1: Erro \$e'));

  await Future.delayed(Duration(milliseconds: 100));

  // Ouvinte 2 (pode ser adicionado a qualquer momento)
  broadcastStream.listen((data) {
    print('Broadcast Ouvinte 2: \$data');
  }, onError: (e) => print('Broadcast Ouvinte 2: Erro \$e'));

  broadcastController.sink.add('Evento A');
  await Future.delayed(Duration(milliseconds: 100));
  broadcastController.sink.add('Evento B');
  broadcastController.sink.addError('Erro no broadcast!');
  broadcastController.sink.add('Evento C');
  await broadcastController.close();
  await Future.delayed(Duration(milliseconds: 500)); // Aguardar onDone de ambos


  print('\\n--- Consumindo Stream com await for (Gerador Assíncrono) ---');
  Stream<int> contagemStream = contarAte(3);
  print('Iniciando contagem de 1 a 3...');
  await for (var numero in contagemStream) {
    // 'await for' consome eventos do Stream de forma sequencial.
    print('Contador: \$numero');
  }
  print('Contagem concluída.');

  print('\\n--- Transformando Streams (Ex: map, where, distinct) ---');
  StreamController<int> transformController = StreamController<int>();
  Stream<String> transformedStream = transformController.stream
      .where((n) => n % 2 == 0) // Filtra apenas números pares
      .map((n) => 'Número par: \$n'); // Transforma o número em uma string

  transformedStream.listen((data) => print('Transformado: \$data'));

  transformController.sink.add(1);
  transformController.sink.add(2);
  transformController.sink.add(3);
  transformController.sink.add(4);
  transformController.sink.add(5);
  await transformController.close();
  await Future.delayed(Duration(milliseconds: 500));
}''',
  output: '''--- Stream Single-Subscription com StreamController ---
Single: Recebido 10
Single: Recebido 20
Single: Recebido 30
Single: Erro! Algo deu errado no single stream!
Single: Stream single-subscription finalizada.

--- Stream Broadcast com StreamController e Múltiplos Ouvintes ---
Broadcast Ouvinte 1: Evento A
Broadcast Ouvinte 2: Evento A
Broadcast Ouvinte 1: Evento B
Broadcast Ouvinte 2: Evento B
Broadcast Ouvinte 1: Erro Erro no broadcast!
Broadcast Ouvinte 2: Erro Erro no broadcast!
Broadcast Ouvinte 1: Evento C
Broadcast Ouvinte 2: Evento C

--- Consumindo Stream com await for (Gerador Assíncrono) ---
Iniciando contagem de 1 a 3...
Contador: 1
Contador: 2
Contador: 3
Contagem concluída.

--- Transformando Streams (Ex: map, where, distinct) ---
Transformado: Número par: 2
Transformado: Número par: 4''',
  description:
      'Em Dart, `Stream` representa uma sequência de eventos ou dados assíncronos, como um fluxo contínuo de informações. Streams são usados para lidar com interações em tempo real e operações que produzem múltiplos valores ao longo do tempo. Eles podem ser `single-subscription` (um único ouvinte consome todos os eventos) ou `broadcast` (múltiplos ouvintes podem receber os mesmos eventos). `StreamController` é a forma mais comum de criar e gerenciar Streams, enquanto geradores assíncronos (`async*`) são ótimos para criar Streams de forma declarativa. Streams podem ser transformados e filtrados usando métodos como `map`, `where`, e consumidos com `listen()` ou `await for`.',
);
