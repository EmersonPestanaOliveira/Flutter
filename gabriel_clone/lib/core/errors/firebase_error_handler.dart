import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';

import 'failures.dart';

abstract final class FirebaseErrorHandler {
  static Failure handle(Exception exception) {
    if (exception is FirebaseException) {
      return switch (exception.code) {
        'permission-denied' => ServerFailure(
          code: exception.code,
          log: exception,
        ),
        'unavailable' => NetworkFailure(code: exception.code, log: exception),
        'not-found' => NotFoundFailure(code: exception.code, log: exception),
        _ => _unknown(exception),
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
