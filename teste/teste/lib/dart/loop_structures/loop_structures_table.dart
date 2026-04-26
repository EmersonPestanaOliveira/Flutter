import 'package:flutter/material.dart';

class LoopStructuresTablePage extends StatelessWidget {
  const LoopStructuresTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tabela de Estruturas de Repetição")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Estrutura")),
            DataColumn(label: Text("Descrição")),
            DataColumn(label: Text("Exemplo")),
          ],
          rows: const [
            DataRow(
              cells: [
                DataCell(Text("for")),
                DataCell(Text("Loop com contador")),
                DataCell(Text("for (int i = 0; i < 5; i++)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("while")),
                DataCell(Text("Executa enquanto a condição for true")),
                DataCell(Text("while (i < 5)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("do while")),
                DataCell(Text("Executa pelo menos uma vez")),
                DataCell(Text("do { } while (condicao)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("forEach")),
                DataCell(Text("Itera sobre listas usando função")),
                DataCell(Text("lista.forEach(...)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("for-in")),
                DataCell(Text("Percorre elementos de coleção")),
                DataCell(Text("for (var item in lista)")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
