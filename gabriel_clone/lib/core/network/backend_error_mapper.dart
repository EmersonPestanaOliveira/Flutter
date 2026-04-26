import '../errors/app_exception.dart';
import '../errors/failure.dart';

abstract final class BackendErrorMapper {
  static Failure toFailure(Object error) {
    if (error is AppException) {
      return Failure(error.message, code: error.code);
    }

    return const Failure('Nao foi possivel processar a solicitacao.');
  }
}