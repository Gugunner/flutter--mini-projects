typedef AsyncResultFunction<T> =
    Future<Result<T?, Error>> Function(dynamic input);

sealed class Result<T, E extends Error> {}

final class Success<T, E extends Error> extends Result<T, E> {
  final T value;
  Success(this.value);
}

final class Failure<T, E extends Error> extends Result<T, E> {
  final E error;
  final String? message;
  Failure(this.error, [this.message]);
}

