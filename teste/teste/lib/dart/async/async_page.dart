import 'package:flutter/material.dart';
import 'async_table.dart';
import 'future_example.dart';
import 'streams_example.dart';
import 'future_error_handling.dart';
import 'future_wait_example.dart';
import 'future_or_example.dart';
import 'stream_controller_example.dart';
import 'broadcast_stream_example.dart';
import 'stream_transform_example.dart';

class AsyncPage extends StatelessWidget {
  const AsyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ("Tabela Resumo", "Resumo do módulo async", const AsyncTablePage()),
      (
        "Future",
        "Execução assíncrona com async/await",
        const FutureExamplePage(),
      ),
      (
        "Tratamento de erro em Future",
        "try/catch, catchError e timeout",
        const FutureErrorHandlingPage(),
      ),
      (
        "Future.wait",
        "Executa várias futures em paralelo",
        const FutureWaitExamplePage(),
      ),
      (
        "FutureOr",
        "Retorno síncrono ou assíncrono",
        const FutureOrExamplePage(),
      ),
      (
        "Streams",
        "Fluxo assíncrono de múltiplos valores",
        const StreamsExamplePage(),
      ),
      (
        "StreamController",
        "Criação manual de streams",
        const StreamControllerExamplePage(),
      ),
      (
        "Broadcast Stream",
        "Vários listeners na mesma stream",
        const BroadcastStreamExamplePage(),
      ),
      (
        "Transformação de Streams",
        "map, where e listen",
        const StreamTransformExamplePage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Async")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return ListTile(
            title: Text(item.$1),
            subtitle: Text(item.$2),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item.$3),
              );
            },
          );
        },
      ),
    );
  }
}
