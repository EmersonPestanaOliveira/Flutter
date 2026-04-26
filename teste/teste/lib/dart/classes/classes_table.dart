import 'package:flutter/material.dart';

class ClassesTablePage extends StatelessWidget {
  const ClassesTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tabela de Classes")),
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
                DataCell(Text("Orientação a Objeto")),
                DataCell(Text("Classe com atributos e métodos")),
                DataCell(Text("class Pessoa { ... }")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Classe Genérica")),
                DataCell(Text("Classe com tipo parametrizado")),
                DataCell(Text("class Caixa<T> { ... }")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Getter")),
                DataCell(Text("Lê valor calculado ou privado")),
                DataCell(Text("String get nomeCompleto")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Setter")),
                DataCell(Text("Define valor com validação")),
                DataCell(Text("set idade(int valor)")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
