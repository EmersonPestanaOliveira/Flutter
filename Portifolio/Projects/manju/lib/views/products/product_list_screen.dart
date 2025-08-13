import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manju/controllers/product_controller.dart';
import 'package:manju/views/products/product_form_screen.dart';

import '../dashboard/dashboard_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final controller = GetIt.I<ProductController>();

  @override
  void initState() {
    super.initState();
    controller.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Produtos'),
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => const DashboardScreen(),
              ));
            },
            icon: Icon(
              Icons.arrow_back,
            )),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final products = controller.products;
          if (products.isEmpty) {
            return const Center(child: Text('Nenhum produto cadastrado.'));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: (product.imagePath != null)
                    ? Image.file(File(product.imagePath!),
                        width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.image),
                title: Text(product.name),
                subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProductFormScreen(product: product),
                        ));
                        controller.loadProducts();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        if (product.id != null) {
                          await controller.deleteProduct(product.id!);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
