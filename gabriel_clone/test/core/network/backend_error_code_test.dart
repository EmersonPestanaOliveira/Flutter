import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/network/backend_error_code.dart';

void main() {
  group('BackendErrorCode.fromServerCode', () {
    test('mapeia codigos HTTP para erros padronizados', () {
      expect(
        BackendErrorCode.fromServerCode('400'),
        BackendErrorCode.invalidArgument,
      );
      expect(
        BackendErrorCode.fromServerCode('401'),
        BackendErrorCode.unauthenticated,
      );
      expect(
        BackendErrorCode.fromServerCode('403'),
        BackendErrorCode.permissionDenied,
      );
      expect(BackendErrorCode.fromServerCode('404'), BackendErrorCode.notFound);
      expect(BackendErrorCode.fromServerCode('408'), BackendErrorCode.timeout);
      expect(
        BackendErrorCode.fromServerCode('429'),
        BackendErrorCode.tooManyRequests,
      );
      expect(BackendErrorCode.fromServerCode('500'), BackendErrorCode.internal);
    });

    test('mapeia codigos Firebase Auth para mensagens especificas', () {
      expect(
        BackendErrorCode.fromServerCode('invalid-email'),
        BackendErrorCode.invalidEmail,
      );
      expect(
        BackendErrorCode.fromServerCode('invalid-credential'),
        BackendErrorCode.invalidCredential,
      );
      expect(
        BackendErrorCode.fromServerCode('email-already-in-use'),
        BackendErrorCode.emailAlreadyInUse,
      );
      expect(
        BackendErrorCode.fromServerCode('requires-recent-login'),
        BackendErrorCode.requiresRecentLogin,
      );
    });

    test('mapeia codigos Firestore e Storage', () {
      expect(
        BackendErrorCode.fromServerCode('permission-denied'),
        BackendErrorCode.permissionDenied,
      );
      expect(
        BackendErrorCode.fromServerCode('deadline-exceeded'),
        BackendErrorCode.timeout,
      );
      expect(
        BackendErrorCode.fromServerCode('resource-exhausted'),
        BackendErrorCode.quotaExceeded,
      );
      expect(
        BackendErrorCode.fromServerCode('storage/object-not-found'),
        BackendErrorCode.storageObjectNotFound,
      );
      expect(
        BackendErrorCode.fromServerCode('storage/retry-limit-exceeded'),
        BackendErrorCode.uploadRetryLimitExceeded,
      );
    });

    test('normaliza espacos e caixa', () {
      expect(
        BackendErrorCode.fromServerCode('  PERMISSION-DENIED  '),
        BackendErrorCode.permissionDenied,
      );
    });

    test('retorna unknown para codigo vazio ou desconhecido', () {
      expect(BackendErrorCode.fromServerCode(null), BackendErrorCode.unknown);
      expect(BackendErrorCode.fromServerCode(''), BackendErrorCode.unknown);
      expect(
        BackendErrorCode.fromServerCode('nao-mapeado'),
        BackendErrorCode.unknown,
      );
    });
  });

  group('BackendErrorCode.message', () {
    test('fornece mensagens padrao para rede', () {
      expect(
        BackendErrorCode.networkOffline.message,
        'Sem conexao com a internet. Verifique sua rede e tente novamente.',
      );
      expect(
        BackendErrorCode.networkPoor.message,
        'Sua conexao esta instavel. Tente novamente em alguns instantes.',
      );
    });

    test('fornece mensagem segura para erro desconhecido', () {
      expect(
        BackendErrorCode.unknown.message,
        'Ocorreu um erro inesperado. Tente novamente.',
      );
    });
  });
}
