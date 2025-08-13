import 'package:flutter/material.dart';
import 'package:imc_clone/screens/dashboard_screen.dart/components/app_bar_custon.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 239, 241, 1), // Cor sólida (rgb),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.05,
          ),
          AppBarCuston(
            screenHeight: screenHeight,
          ),
          // Conteúdo da tela

          // Conteúdo abaixo do "AppBar"
          Expanded(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: screenHeight * 0.33,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(10), // Bordas arredondadas
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26, // Cor da sombra
                        blurRadius: 15, // Suavidade da sombra
                        offset: Offset(4, 4), // Posição da sombra
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Container',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: screenHeight * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(10), // Bordas arredondadas
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26, // Cor da sombra
                        blurRadius: 15, // Suavidade da sombra
                        offset: Offset(4, 4), // Posição da sombra
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Container',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
