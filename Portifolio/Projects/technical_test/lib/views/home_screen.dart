import 'package:flutter/material.dart';
import 'product_list_view.dart'; // Tela de produtos
import 'category_list_view.dart'; // Tela de categorias

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botão para ir para a tela de Categorias
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryListView(),
                  ),
                );
              },
              child: Text('Ver Categorias'),
            ),
            SizedBox(height: 20),
            // Botão para ir para a tela de Produtos
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductListView(),
                  ),
                );
              },
              child: Text('Ver Produtos'),
            ),
          ],
        ),
      ),
    );
  }
}
