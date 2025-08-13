import 'package:flutter/material.dart';
import '../controllers/category_controller.dart';
import '../models/category_model.dart';

class CategoryListView extends StatelessWidget {
  final CategoryController _controller = CategoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias'),
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: _controller.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar categorias'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma categoria disponível'));
          } else {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.name),
                  onTap: () {
                    // Aqui você pode definir o comportamento ao clicar em uma categoria
                    // Exemplo: Navegar para uma tela que lista os produtos dessa categoria
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
