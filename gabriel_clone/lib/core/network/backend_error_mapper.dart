import '../errors/firebase_error_handler.dart';
import '../errors/failures.dart';

abstract final class BackendErrorMapper {
  static Failure toFailure(Object error) {
    if (error is Exception) {
      return FirebaseErrorHandler.handle(error);
    }

    return UnknownFailure(log: error);
  }
}
