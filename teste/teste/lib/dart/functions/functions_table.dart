import 'package:flutter/material.dart';

class FunctionsTablePage extends StatelessWidget {
  const FunctionsTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tabela de Funções")),
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
                DataCell(Text("Declaração")),
                DataCell(Text("Funções com retorno ou void")),
                DataCell(Text("int soma(int a, int b)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Parâmetros")),
                DataCell(Text("Posicionais e nomeados")),
                DataCell(Text("titulo(required nome)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Tipos de função")),
                DataCell(Text("Função como parâmetro/retorno")),
                DataCell(Text("int Function(int,int)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("typedef")),
                DataCell(Text("Alias para função")),
                DataCell(Text("typedef BinOp = int Function(...)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Genéricas")),
                DataCell(Text("Uso de tipos parametrizados")),
                DataCell(Text("T escolher<T>(...)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Closures")),
                DataCell(Text("Capturam variáveis do escopo")),
                DataCell(Text("Function contador()")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Tear-offs")),
                DataCell(Text("Referência a método sem chamar")),
                DataCell(Text("int.parse")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Async")),
                DataCell(Text("Future, await e try/catch")),
                DataCell(Text("Future<String> carregar() async")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Generators")),
                DataCell(Text("sync* e async*")),
                DataCell(Text("Iterable<int> paresAte(...)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Record")),
                DataCell(Text("Funções com records")),
                DataCell(Text("int area((int, int) dims)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Tipos especiais")),
                DataCell(Text("Never, void, external")),
                DataCell(Text("Never falhar(String msg)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Alta ordem")),
                DataCell(Text("Recebem/retornam funções")),
                DataCell(Text("executarOperacao(...)")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
