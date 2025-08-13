import 'package:flutter/foundation.dart';
import 'package:manju/data/repositories/product_repository.dart';
import 'package:manju/models/product_model.dart';

class ProductController extends ChangeNotifier {
  final ProductRepository productRepository;

  ProductController(this.productRepository);

  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> loadProducts() async {
    _products = await productRepository.getAllProducts();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await productRepository.insertProduct(product);
    await loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    if (product.id != null) {
      await productRepository.updateProduct(product);
      await loadProducts();
    }
  }

  Future<void> deleteProduct(int id) async {
    await productRepository.deleteProduct(id);
    await loadProducts();
  }
}
