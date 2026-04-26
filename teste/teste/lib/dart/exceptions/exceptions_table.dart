import 'package:flutter/material.dart';

class ExceptionsTablePage extends StatelessWidget {
  const ExceptionsTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tabela de Exceptions")),
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
                DataCell(Text("assert")),
                DataCell(Text("Valida condição em debug")),
                DataCell(Text("assert(b != 0, 'erro')")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("try/catch/finally")),
                DataCell(Text("Captura e trata erros")),
                DataCell(Text("try { ... } catch (e) { ... }")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("stackTrace")),
                DataCell(Text("Mostra a pilha do erro")),
                DataCell(Text("catch (e, stackTrace)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("on")),
                DataCell(Text("Filtra por tipo de exceção")),
                DataCell(Text("on FormatException catch (e)")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("finally")),
                DataCell(Text("Executa sempre")),
                DataCell(Text("finally { fechar(); }")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("rethrow")),
                DataCell(Text("Relança mantendo stack trace")),
                DataCell(Text("rethrow;")),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text("Exception customizada")),
                DataCell(Text("Cria tipo próprio de erro")),
                DataCell(Text("class MinhaExcecao implements Exception")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
