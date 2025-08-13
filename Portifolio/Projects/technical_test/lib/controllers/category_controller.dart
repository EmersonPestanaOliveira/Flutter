import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryController {
  final CategoryService _categoryService = CategoryService();

  // Método para buscar as categorias do serviço
  Future<List<CategoryModel>> getCategories() async {
    try {
      // Chama o serviço para buscar as categorias
      List<CategoryModel> categories = await _categoryService.fetchCategories();
      return categories;
    } catch (e) {
      // Em caso de erro, imprime no console e lança uma exceção
      print('Erro ao carregar categorias: $e');
      throw Exception('Erro ao carregar categorias');
    }
  }
}
