import '../../domain/etities/image_entity.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/nasa_api/nasa_api_datasource.dart';

class ImageRepositoryImpl implements ImageRepository {
  final NasaApiDatasource datasource;

  ImageRepositoryImpl(this.datasource);

  @override
  Future<List<ImageEntity>> getImages() async {
    final models = await datasource.getImagesFromNasa();
    return models; // models já são ImageModels, que extendem ImageEntity
  }

  @override
  Future<void> createImage(ImageEntity image) async {
    // Aqui entraria a lógica de criar, por ex., em um backend próprio
    // ou em um banco local. Exemplo genérico:
    throw UnimplementedError();
  }

  @override
  Future<void> updateImage(ImageEntity image) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteImage(String id) async {
    throw UnimplementedError();
  }
}
