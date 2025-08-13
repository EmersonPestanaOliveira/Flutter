import 'package:flutter/material.dart';
import '../app_state.dart';
import 'product_form_view.dart';

class HomeView extends StatelessWidget {
  final VoidCallback onStateChanged;
  const HomeView({Key? key, required this.onStateChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productViewModel = AppState.of(context).productViewModel;
    final products = productViewModel.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text(
              'Preço: R\$ ${product.price.toStringAsFixed(2)} '
              '- Quantidade: ${product.quantity}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductFormView(
                          product: product,
                        ),
                      ),
                    );
                    // Após retornar do form, notifica para rebuildar
                    onStateChanged();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await productViewModel.removeProduct(product.id);
                    onStateChanged();
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Abre formulário para criar produto
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProductFormView(),
            ),
          );
          // Após retornar do form, atualiza
          onStateChanged();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
