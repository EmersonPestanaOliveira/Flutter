import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart'; // Substitua pelo caminho correto para o arquivo ThemeProvider.

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tema Claro/Escuro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tema atual: ${themeProvider.isDarkMode ? "Escuro" : "Claro"}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => themeProvider.toggleTheme(),
              child: Text('Alternar Tema'),
            ),
          ],
        ),
      ),
    );
  }
}
