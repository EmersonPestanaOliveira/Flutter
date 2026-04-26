import 'package:equatable/equatable.dart';

import '../types/app_result.dart';

abstract class UseCase<Type, Params> {
  Future<AppResult<Type>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
