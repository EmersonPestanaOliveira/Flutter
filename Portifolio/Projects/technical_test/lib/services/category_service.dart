import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category_model.dart';

class CategoryService {
  final String apiUrl =
      "https://link-do-endpoint-de-categorias"; // Substitua pela URL real

  // Método que busca categorias do endpoint
  Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((category) => CategoryModel.fromJson(category)).toList();
    } else {
      throw Exception('Erro ao carregar categorias');
    }
  }
}
