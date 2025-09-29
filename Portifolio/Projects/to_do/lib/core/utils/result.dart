sealed class Result<T> {
  const Result();
  R when<R>({required R Function(T data) success, required R Function(Object e) failure}) {
    final self = this;
    if (self is Success<T>) return success(self.data);
    if (self is Fail<T>) return failure(self.error);
    throw StateError('Invalid Result state');
  }
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Fail<T> extends Result<T> {
  final Object error;
  const Fail(this.error);
}
