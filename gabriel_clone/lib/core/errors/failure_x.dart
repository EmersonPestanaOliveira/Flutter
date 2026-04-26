import 'failures.dart';

extension FailureX on Failure {
  String get message {
    return switch (this) {
      ServerFailure() =>
        'Nao foi possivel acessar o servidor. Tente novamente.',
      NetworkFailure() =>
        'Conexao indisponivel. Verifique sua internet e tente novamente.',
      NotFoundFailure() => 'Informacao nao encontrada.',
      UnknownFailure() => 'Ocorreu um erro inesperado. Tente novamente.',
    };
  }
}
