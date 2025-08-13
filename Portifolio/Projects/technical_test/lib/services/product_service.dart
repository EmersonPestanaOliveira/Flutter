import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';

class ProductService {
  final String apiUrl =
      "https://link-do-endpoint-de-produtos"; // Substitua pela URL correta

  // Método para buscar a lista de produtos do endpoint
  Future<List<ProductModel>> fetchProducts() async {
    try {
      // Faz a requisição HTTP GET para obter os produtos
      final response = await http.get(Uri.parse(apiUrl));

      // Verifica se a requisição foi bem-sucedida (status code 200)
      if (response.statusCode == 200) {
        // Converte o corpo da resposta para uma lista de objetos ProductModel
        List<dynamic> data = json.decode(response.body);
        return data.map((product) => ProductModel.fromJson(product)).toList();
      } else {
        // Se a requisição falhou, lança uma exceção
        throw Exception('Erro ao carregar produtos: ${response.statusCode}');
      }
    } catch (e) {
      // Captura e lança qualquer erro que ocorrer durante a requisição
      print('Erro ao buscar produtos: $e');
      throw Exception('Erro ao carregar produtos');
    }
  }
}
