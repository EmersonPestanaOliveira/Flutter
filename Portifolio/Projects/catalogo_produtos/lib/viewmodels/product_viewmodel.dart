import 'package:uuid/uuid.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

class ProductViewModel {
  final ProductRepository _repository;

  // Lista de produtos em memória
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  ProductViewModel(this._repository);

  // Carrega todos os produtos do repositório
  Future<void> loadProducts() async {
    _products = await _repository.getAllProducts();
  }

  // Cria um novo produto
  Future<void> addProduct(String name, double price, int quantity) async {
    final newProduct = ProductModel(
      id: const Uuid().v4(), // gera um id único
      name: name,
      price: price,
      quantity: quantity,
    );
    await _repository.addProduct(newProduct);
    _products.add(newProduct);
  }

  // Edita um produto existente
  Future<void> editProduct(
      String id, String name, double price, int quantity) async {
    final index = _products.indexWhere((prod) => prod.id == id);
    if (index != -1) {
      final updated = ProductModel(
        id: id,
        name: name,
        price: price,
        quantity: quantity,
      );
      await _repository.updateProduct(updated);
      _products[index] = updated;
    }
  }

  // Remove um produto
  Future<void> removeProduct(String id) async {
    await _repository.deleteProduct(id);
    _products.removeWhere((prod) => prod.id == id);
  }
}
