import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';

class ProductListView extends StatelessWidget {
  final ProductController _controller = ProductController();
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _filteredProducts = [];

  ProductListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _controller.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar produtos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum produto disponível'));
          } else {
            List<ProductModel> products = snapshot.data!;
            _filteredProducts = products;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar produto...',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          _filterProducts(products);
                        },
                      ),
                    ),
                    onChanged: (value) {
                      _filterProducts(products);
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                            'Preço: R\$${product.price.toStringAsFixed(2)}'),
                        onTap: () {
                          // Aqui você pode definir o comportamento ao clicar em um produto
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _filterProducts(List<ProductModel> products) {
    String searchText = _searchController.text.toLowerCase();
    _filteredProducts = products
        .where((product) =>
            product.name.toLowerCase().contains(searchText) ||
            product.category.toLowerCase().contains(searchText))
        .toList();
  }
}
