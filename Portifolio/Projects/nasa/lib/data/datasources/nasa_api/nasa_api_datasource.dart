import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/utils/constants.dart';
import '../../models/image_model.dart';

class NasaApiDatasourceImpl implements NasaApiDatasource {
  @override
  Future<List<ImageModel>> getImagesFromNasa() async {
    final uri = Uri.parse('${Constants.nasaBaseUrl}/search?q=moon');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['collection']['items'];
      return items.map((e) => ImageModel.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar imagens na NASA API');
    }
  }

  @override
  Future<Map<String, dynamic>> getAssetManifest(String nasaId) async {
    final uri = Uri.parse('${Constants.nasaBaseUrl}/asset/$nasaId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao buscar o manifesto do asset: $nasaId');
    }
  }
}
