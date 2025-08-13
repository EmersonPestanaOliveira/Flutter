import 'package:flutter/material.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/etities/image_entity.dart';
import '../../domain/usecases/get_images_usecase.dart';

class ImageChangeNotifier extends ChangeNotifier {
  final GetImagesUseCase getImagesUseCase;

  ImageChangeNotifier(this.getImagesUseCase);

  List<ImageEntity> images = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchImages() async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await getImagesUseCase(NoParams());
      images = result;
    } catch (e) {
      errorMessage = 'Ocorreu um erro ao buscar as imagens.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
