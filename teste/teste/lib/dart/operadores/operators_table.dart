import 'package:flutter/material.dart';

class OperatorsTablePage extends StatelessWidget {
  const OperatorsTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tabela de Operadores")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Categoria")),
            DataColumn(label: Text("Operadores")),
            DataColumn(label: Text("Exemplo")),
          ],
          rows: const [
            DataRow(
              cells: [
                DataCell(Text("Aritméticos")),
                DataCell(Text("+, -, *, /, ~/, %")),
                DataCell(Text("10 + 2")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Unários")),
                DataCell(Text("-x, !x, ~x")),
                DataCell(Text("!ativo")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Incremento")),
                DataCell(Text("++, --")),
                DataCell(Text("x++")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Atribuição combinada")),
                DataCell(Text("+=, -=, *=, /=, ??=")),
                DataCell(Text("x += 5")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Relacionais")),
                DataCell(Text("==, !=, >, <, >=, <=")),
                DataCell(Text("x > 10")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Lógicos")),
                DataCell(Text("&&, ||, !")),
                DataCell(Text("a && b")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Condicionais")),
                DataCell(Text("?:, ??, ??=")),
                DataCell(Text("x ?? 0")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Null-aware")),
                DataCell(Text("?., ?.., ??, ??=, ...?")),
                DataCell(Text("usuario?.nome")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Tipo")),
                DataCell(Text("is, is!, as")),
                DataCell(Text("x is String")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Cascata")),
                DataCell(Text(".., ?..")),
                DataCell(Text("obj..metodo()")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Coleção")),
                DataCell(Text("..., ...?, if, for")),
                DataCell(Text("[1, ...lista]")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
