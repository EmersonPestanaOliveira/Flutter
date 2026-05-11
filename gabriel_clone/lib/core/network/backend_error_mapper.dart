import 'dart:async';

import 'package:flutter/services.dart';

import '../errors/firebase_error_handler.dart';
import '../errors/failures.dart';
import 'backend_error_code.dart';

abstract final class BackendErrorMapper {
  static Failure toFailure(Object error) {
    if (error is Failure) {
      return error;
    }

    if (_isSocketException(error)) {
      return OfflineFailure(log: error);
    }

    if (error is TimeoutException) {
      return PoorConnectionFailure(
        errorCode: BackendErrorCode.timeout,
        code: 'timeout',
        log: error,
      );
    }

    if (error is StateError && error.message.toLowerCase().contains('usu')) {
      return ServerFailure(
        errorCode: BackendErrorCode.unauthenticated,
        code: 'unauthenticated',
        log: error,
      );
    }

    if (error is PlatformException) {
      final errorCode = BackendErrorCode.fromServerCode(error.code);
      return switch (errorCode) {
        BackendErrorCode.networkOffline => OfflineFailure(
          code: error.code,
          log: error,
        ),
        BackendErrorCode.networkPoor || BackendErrorCode.timeout =>
          PoorConnectionFailure(
            errorCode: errorCode,
            code: error.code,
            log: error,
          ),
        BackendErrorCode.unknown => UnknownFailure(code: error.code, log: error),
        _ => ServerFailure(errorCode: errorCode, code: error.code, log: error),
      };
    }

    if (error is Exception) {
      return FirebaseErrorHandler.handle(error);
    }

    return UnknownFailure(log: error);
  }

  static String message(Object error) => toFailure(error).errorCode.message;

  static bool _isSocketException(Object error) {
    final type = error.runtimeType.toString().toLowerCase();
    final message = error.toString().toLowerCase();
    return type.contains('socketexception') || message.contains('socket');
  }
}
