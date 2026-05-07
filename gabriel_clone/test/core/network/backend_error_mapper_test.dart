import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/errors/failure_x.dart';
import 'package:gabriel_clone/core/errors/failures.dart';
import 'package:gabriel_clone/core/network/backend_error_code.dart';
import 'package:gabriel_clone/core/network/backend_error_mapper.dart';

void main() {
  group('BackendErrorMapper.toFailure', () {
    test('retorna Failure sem remapear', () {
      const failure = OfflineFailure(code: 'network-request-failed');

      expect(BackendErrorMapper.toFailure(failure), same(failure));
    });

    test('mapeia SocketException para OfflineFailure', () {
      final failure = BackendErrorMapper.toFailure(
        const SocketException('offline'),
      );

      expect(failure, isA<OfflineFailure>());
      expect(failure.errorCode, BackendErrorCode.networkOffline);
    });

    test('mapeia TimeoutException para PoorConnectionFailure com timeout', () {
      final failure = BackendErrorMapper.toFailure(
        TimeoutException('slow server'),
      );

      expect(failure, isA<PoorConnectionFailure>());
      expect(failure.errorCode, BackendErrorCode.timeout);
      expect(failure.message, 'O servidor demorou para responder. Tente novamente.');
    });

    test('mapeia PlatformException conhecida para ServerFailure especifico', () {
      final failure = BackendErrorMapper.toFailure(
        PlatformException(code: 'requires-recent-login'),
      );

      expect(failure, isA<ServerFailure>());
      expect(failure.errorCode, BackendErrorCode.requiresRecentLogin);
    });

    test('mapeia PlatformException de rede para OfflineFailure', () {
      final failure = BackendErrorMapper.toFailure(
        PlatformException(code: 'network_error'),
      );

      expect(failure, isA<OfflineFailure>());
      expect(failure.errorCode, BackendErrorCode.networkOffline);
    });

    test('mapeia FirebaseException not-found para NotFoundFailure', () {
      final failure = BackendErrorMapper.toFailure(
        FirebaseException(plugin: 'cloud_firestore', code: 'not-found'),
      );

      expect(failure, isA<NotFoundFailure>());
      expect(failure.errorCode, BackendErrorCode.notFound);
    });

    test('mapeia FirebaseException unavailable para conexao ruim', () {
      final failure = BackendErrorMapper.toFailure(
        FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
      );

      expect(failure, isA<PoorConnectionFailure>());
      expect(failure.errorCode, BackendErrorCode.networkPoor);
    });

    test('mapeia usuario ausente para sessao expirada', () {
      final failure = BackendErrorMapper.toFailure(
        StateError('Usuario nao autenticado.'),
      );

      expect(failure, isA<ServerFailure>());
      expect(failure.errorCode, BackendErrorCode.unauthenticated);
    });

    test('mapeia erro desconhecido para UnknownFailure', () {
      final failure = BackendErrorMapper.toFailure(Object());

      expect(failure, isA<UnknownFailure>());
      expect(failure.errorCode, BackendErrorCode.unknown);
    });
  });

  group('BackendErrorMapper.message', () {
    test('retorna mensagem padrao a partir do erro', () {
      expect(
        BackendErrorMapper.message(
          FirebaseException(plugin: 'firebase_auth', code: 'invalid-email'),
        ),
        'E-mail invalido.',
      );
    });
  });
}
