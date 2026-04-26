import 'package:flutter/material.dart';

class ConstantsTablePage extends StatelessWidget {
  const ConstantsTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tabela de Constantes")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Tipo")),
            DataColumn(label: Text("Tempo")),
            DataColumn(label: Text("Descrição")),
            DataColumn(label: Text("Exemplo")),
          ],
          rows: const [
            DataRow(
              cells: [
                DataCell(Text("const")),
                DataCell(Text("Compilação")),
                DataCell(Text("Valor conhecido antes da execução")),
                DataCell(Text("const int x = 10;")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("final")),
                DataCell(Text("Execução")),
                DataCell(Text("Definido uma vez durante execução")),
                DataCell(Text("final ano = DateTime.now().year;")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("enum")),
                DataCell(Text("Compilação")),
                DataCell(Text("Conjunto fixo de valores nomeados")),
                DataCell(Text("enum Cor { vermelho, verde, azul }")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("const List")),
                DataCell(Text("Compilação")),
                DataCell(Text("Lista totalmente imutável")),
                DataCell(Text("const lista = [1,2,3];")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("const Map")),
                DataCell(Text("Compilação")),
                DataCell(Text("Mapa imutável")),
                DataCell(Text("const mapa = {'a':1};")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("List.unmodifiable")),
                DataCell(Text("Execução")),
                DataCell(Text("Lista somente leitura")),
                DataCell(Text("List.unmodifiable(lista)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Map.unmodifiable")),
                DataCell(Text("Execução")),
                DataCell(Text("Mapa somente leitura")),
                DataCell(Text("Map.unmodifiable(mapa)")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
