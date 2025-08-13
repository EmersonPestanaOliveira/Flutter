import '../../core/usecases/usecase.dart';
import '../etities/image_entity.dart';
import '../repositories/image_repository.dart';

class GetImagesUseCase implements UseCase<List<ImageEntity>, NoParams> {
  final ImageRepository repository;

  GetImagesUseCase(this.repository);

  @override
  Future<List<ImageEntity>> call(NoParams params) async {
    return await repository.getImages();
  }
}
