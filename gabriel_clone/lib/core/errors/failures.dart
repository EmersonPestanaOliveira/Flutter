import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure({this.code, this.log});

  final String? code;
  final Object? log;

  @override
  List<Object?> get props => [code, log];
}

final class ServerFailure extends Failure {
  const ServerFailure({super.code, super.log});
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.code, super.log});
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure({super.code, super.log});
}

final class UnknownFailure extends Failure {
  const UnknownFailure({super.code, super.log});
}
