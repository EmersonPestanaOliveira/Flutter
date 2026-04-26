import 'package:flutter/material.dart';

class VariablesTablePage extends StatelessWidget {
  const VariablesTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tabela de Variáveis")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Tipo")),
            DataColumn(label: Text("Descrição")),
            DataColumn(label: Text("Exemplo")),
          ],
          rows: const [
            DataRow(
              cells: [
                DataCell(Text("String")),
                DataCell(Text("Texto")),
                DataCell(Text('String nome = "Ana";')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("int")),
                DataCell(Text("Número inteiro")),
                DataCell(Text("int idade = 20;")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("double")),
                DataCell(Text("Número decimal")),
                DataCell(Text("double altura = 1.75;")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("num")),
                DataCell(Text("Inteiro ou decimal")),
                DataCell(Text("num valor = 10.5;")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("bool")),
                DataCell(Text("Verdadeiro ou falso")),
                DataCell(Text("bool ativo = true;")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("var")),
                DataCell(Text("Inferência de tipo")),
                DataCell(Text('var nome = "Carlos";')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("dynamic")),
                DataCell(Text("Tipo dinâmico")),
                DataCell(Text("dynamic valor = 10;")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Object")),
                DataCell(Text("Tipo base de objetos")),
                DataCell(Text('Object valor = "texto";')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("List")),
                DataCell(Text("Coleção ordenada")),
                DataCell(Text('List<int> nums = [1,2,3];')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Map")),
                DataCell(Text("Chave e valor")),
                DataCell(Text('Map<String,int> idade = {"Ana":20};')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Set")),
                DataCell(Text("Valores únicos")),
                DataCell(Text("Set<int> nums = {1,2,3};")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Nullable")),
                DataCell(Text("Aceita null")),
                DataCell(Text("String? nome;")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
