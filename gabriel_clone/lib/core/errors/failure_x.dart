import 'failures.dart';

extension FailureX on Failure {
  String get message {
    return errorCode.message;
  }
}
