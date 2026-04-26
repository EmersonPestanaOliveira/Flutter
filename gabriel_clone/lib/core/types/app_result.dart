import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

typedef AppResult<T> = Either<Failure, T>;
