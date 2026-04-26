import 'package:flutter/material.dart';

class AsyncTablePage extends StatelessWidget {
  const AsyncTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tabela Async")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Tópico")),
            DataColumn(label: Text("Descrição")),
            DataColumn(label: Text("Exemplo")),
          ],
          rows: const [
            DataRow(
              cells: [
                DataCell(Text("Future")),
                DataCell(Text("Representa um valor disponível no futuro")),
                DataCell(Text("Future<String> carregar() async")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("async / await")),
                DataCell(Text("Escreve código assíncrono de forma sequencial")),
                DataCell(Text("final r = await carregar();")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("then")),
                DataCell(Text("Trata resultado sem await")),
                DataCell(Text("carregar().then(...)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Stream")),
                DataCell(Text("Fluxo de múltiplos valores no tempo")),
                DataCell(Text("Stream<int> contar() async*")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("await for")),
                DataCell(Text("Consome eventos de uma Stream")),
                DataCell(Text("await for (final n in contar())")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Tratamento de erro")),
                DataCell(Text("Captura falhas em Future")),
                DataCell(Text("try/catch ou catchError")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Future.wait")),
                DataCell(Text("Aguarda várias futures")),
                DataCell(Text("await Future.wait([...])")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("FutureOr")),
                DataCell(Text("Pode retornar valor ou Future")),
                DataCell(Text("FutureOr<String>")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("StreamController")),
                DataCell(Text("Controla emissão de eventos")),
                DataCell(Text("controller.add(1)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Broadcast Stream")),
                DataCell(Text("Permite múltiplos listeners")),
                DataCell(Text("asBroadcastStream()")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Transformação de Stream")),
                DataCell(Text("Transforma e filtra eventos")),
                DataCell(Text("stream.map(...).where(...)")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
