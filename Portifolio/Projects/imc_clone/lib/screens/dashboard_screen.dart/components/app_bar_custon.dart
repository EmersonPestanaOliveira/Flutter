import 'package:flutter/material.dart';
import 'package:imc_clone/screens/dashboard_screen.dart/components/input_field.dart';

class AppBarCuston extends StatelessWidget {
  final double screenHeight;
  const AppBarCuston({super.key, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.38,
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 53, 87, 1), // Cor sólida do cabeçalho
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calculadora de IMC',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.help_outline,
                  color: Colors.white,
                  size: 28,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Campos de entrada
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Campo Gênero
                      InputField(
                        label: 'Gênero',
                        initialValue: '',
                      ),
                      // Campo Idade
                      InputField(
                        label: 'Gênero',
                        initialValue: '',
                      ),
                    ],
                  ),
                  SizedBox(height: 16), // Espaçamento
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InputField(
                        label: 'Gênero',
                        initialValue: '',
                      ),
                      InputField(
                        label: 'Gênero',
                        initialValue: '',
                      ),
                    ],
                  ),
                  SizedBox(height: 24), // Espaçamento maior
                  // Botão Calcular
                  ElevatedButton(
                    onPressed: () {
                      // Ação ao pressionar o botão
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize:
                          Size(double.infinity, 50), // Tamanho do botão
                    ),
                    child: Text(
                      'CALCULAR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
