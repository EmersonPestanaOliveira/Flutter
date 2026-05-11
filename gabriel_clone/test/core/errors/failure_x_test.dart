import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/errors/failures.dart';
import 'package:gabriel_clone/core/network/backend_error_code.dart';

void main() {
  test('Failure.message usa a mensagem do BackendErrorCode', () {
    const failure = ServerFailure(
      errorCode: BackendErrorCode.permissionDenied,
      code: 'permission-denied',
    );

    expect(
      failure.message,
      'Voce nao tem permissao para realizar esta acao.',
    );
  });

  test('OfflineFailure tem codigo padrao de internet ausente', () {
    const failure = OfflineFailure();

    expect(failure.errorCode, BackendErrorCode.networkOffline);
    expect(
      failure.message,
      'Sem conexao com a internet. Verifique sua rede e tente novamente.',
    );
  });

  test('PoorConnectionFailure permite sobrescrever para timeout', () {
    const failure = PoorConnectionFailure(
      errorCode: BackendErrorCode.timeout,
      code: 'timeout',
    );

    expect(failure.errorCode, BackendErrorCode.timeout);
    expect(failure.message, 'O servidor demorou para responder. Tente novamente.');
  });
}
