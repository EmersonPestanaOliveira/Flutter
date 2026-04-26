import 'package:flutter/material.dart';

class ConditionalStructuresTablePage extends StatelessWidget {
  const ConditionalStructuresTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tabela de Estruturas Condicionais")),
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
                DataCell(Text("if")),
                DataCell(Text("Executa se a condição for verdadeira")),
                DataCell(Text("if (idade >= 18)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("if else")),
                DataCell(Text("Escolhe entre dois blocos")),
                DataCell(Text("if (idade >= 18) ... else ...")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("if else if else")),
                DataCell(Text("Avalia várias condições")),
                DataCell(Text("if (...) else if (...) else")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("ternário")),
                DataCell(Text("Condição em uma linha")),
                DataCell(Text("idade >= 18 ? 'Maior' : 'Menor'")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("switch case")),
                DataCell(Text("Escolhe um caso específico")),
                DataCell(Text("switch (dia) { case 1: ... }")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
