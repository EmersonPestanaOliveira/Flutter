import 'package:flutter/material.dart';

class TypeConversionPage extends StatelessWidget {
  const TypeConversionPage({super.key});

  String getCode() {
    return '''
void main() {
  // String para int
  String idadeTexto = "25";
  int idade = int.parse(idadeTexto);

  // String para double
  String precoTexto = "19.99";
  double preco = double.parse(precoTexto);

  // String para num
  String numeroTexto = "10.5";
  num numero = num.parse(numeroTexto);

  // int para String
  int ano = 2025;
  String anoTexto = ano.toString();

  // double para String
  double altura = 1.75;
  String alturaTexto = altura.toString();

  // num para String
  num valor = 99.9;
  String valorTexto = valor.toString();

  // int para double
  int quantidade = 10;
  double quantidadeDouble = quantidade.toDouble();

  // double para int
  double temperatura = 29.8;
  int temperaturaInt = temperatura.toInt();

  // String para bool
  String ativoTexto = "true";
  bool ativo = ativoTexto.toLowerCase() == "true";

  // bool para String
  bool status = false;
  String statusTexto = status.toString();

  // List para Set
  List<int> numerosLista = [1, 2, 2, 3];
  Set<int> numerosSet = numerosLista.toSet();

  // Set para List
  Set<String> nomesSet = {"Ana", "Bruno"};
  List<String> nomesLista = nomesSet.toList();

  // Map para String
  Map<String, dynamic> usuario = {
    "nome": "João",
    "idade": 30,
  };
  String usuarioTexto = usuario.toString();

  print(idade);
  print(preco);
  print(numero);
  print(anoTexto);
  print(alturaTexto);
  print(valorTexto);
  print(quantidadeDouble);
  print(temperaturaInt);
  print(ativo);
  print(statusTexto);
  print(numerosSet);
  print(nomesLista);
  print(usuarioTexto);
}
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conversões de Variáveis")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Código Dart:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                getCode(),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "monospace",
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Resumo das conversões:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "• String → int: int.parse()\n"
              "• String → double: double.parse()\n"
              "• String → num: num.parse()\n"
              "• int/double/num/bool → String: toString()\n"
              "• int → double: toDouble()\n"
              "• double → int: toInt()\n"
              "• String → bool: comparação manual com 'true'\n"
              "• List → Set: toSet()\n"
              "• Set → List: toList()\n"
              "• Map → String: toString()",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
