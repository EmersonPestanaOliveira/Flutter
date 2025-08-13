import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductController {
  final ProductService _productService = ProductService();

  // Método para buscar a lista de produtos do serviço
  Future<List<ProductModel>> getProducts() async {
    try {
      // Chama o serviço para buscar os produtos
      List<ProductModel> products = await _productService.fetchProducts();
      return products;
    } catch (e) {
      // Em caso de erro, imprime no console e lança uma exceção
      print('Erro ao carregar produtos: $e');
      throw Exception('Erro ao carregar produtos');
    }
  }
}
