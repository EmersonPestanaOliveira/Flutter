import 'package:equatable/equatable.dart';

import '../../../../core/types/app_result.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/services/ocorrencia_service.dart';
import '../repositories/ocorrencia_repository.dart';

class CreateOcorrenciaParams extends Equatable {
  const CreateOcorrenciaParams({required this.input});

  final CreateOcorrenciaInput input;

  @override
  List<Object?> get props => [input];
}

class CreateOcorrenciaUseCase
    implements UseCase<String, CreateOcorrenciaParams> {
  const CreateOcorrenciaUseCase(this._repository);

  final OcorrenciaRepository _repository;

  @override
  Future<AppResult<String>> call(CreateOcorrenciaParams params) {
    return _repository.create(params.input);
  }
}
