import 'package:equatable/equatable.dart';

import '../network/backend_error_code.dart';

sealed class Failure extends Equatable {
  const Failure({this.errorCode = BackendErrorCode.unknown, this.code, this.log});

  final BackendErrorCode errorCode;
  final String? code;
  final Object? log;

  /// Human-readable message delegated to [BackendErrorCode.message].
  String get message => errorCode.message;

  @override
  List<Object?> get props => [errorCode, code, log];
}

final class ServerFailure extends Failure {
  const ServerFailure({super.errorCode, super.code, super.log});
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.errorCode, super.code, super.log});
}

final class OfflineFailure extends NetworkFailure {
  const OfflineFailure({
    super.errorCode = BackendErrorCode.networkOffline,
    super.code,
    super.log,
  });
}

final class PoorConnectionFailure extends NetworkFailure {
  const PoorConnectionFailure({
    super.errorCode = BackendErrorCode.networkPoor,
    super.code,
    super.log,
  });
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure({super.errorCode, super.code, super.log});
}

final class UnknownFailure extends Failure {
  const UnknownFailure({super.errorCode, super.code, super.log});
}
