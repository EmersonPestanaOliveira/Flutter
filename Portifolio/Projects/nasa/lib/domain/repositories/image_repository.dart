import '../etities/image_entity.dart';

abstract class ImageRepository {
  Future<List<ImageEntity>> getImages();
  Future<void> createImage(ImageEntity image);
  Future<void> updateImage(ImageEntity image);
  Future<void> deleteImage(String id);
  // e assim por diante...
}
