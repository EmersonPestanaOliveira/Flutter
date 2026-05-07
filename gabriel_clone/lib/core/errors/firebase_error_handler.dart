import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';

import '../network/backend_error_code.dart';
import 'failures.dart';

abstract final class FirebaseErrorHandler {
  static Failure handle(Exception exception) {
    if (exception is FirebaseException) {
      final errorCode = BackendErrorCode.fromServerCode(exception.code);
      return switch (errorCode) {
        BackendErrorCode.networkOffline => OfflineFailure(
          code: exception.code,
          log: exception,
        ),
        BackendErrorCode.networkPoor || BackendErrorCode.timeout =>
          PoorConnectionFailure(
            errorCode: errorCode,
            code: exception.code,
            log: exception,
          ),
        BackendErrorCode.notFound ||
        BackendErrorCode.storageObjectNotFound => NotFoundFailure(
          errorCode: errorCode,
          code: exception.code,
          log: exception,
        ),
        BackendErrorCode.unknown => _unknown(exception),
        _ => ServerFailure(
          errorCode: errorCode,
          code: exception.code,
          log: exception,
        ),
      };
    }

    return _unknown(exception);
  }

  static UnknownFailure _unknown(Object error) {
    developer.log(
      'Unhandled Firebase error',
      name: 'FirebaseErrorHandler',
      error: error,
    );

    return UnknownFailure(log: error);
  }
}
