sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  R when<R>({
    required R Function(T value) success,
    required R Function(AppError error) failure,
  }) {
    final self = this;

    return switch (self) {
      Success<T>(value: final value) => success(value),
      Failure<T>(error: final error) => failure(error),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);

  final AppError error;
}

class AppError implements Exception {
  const AppError({
    required this.code,
    required this.message,
    this.cause,
  });

  final String code;
  final String message;
  final Object? cause;

  @override
  String toString() => 'AppError(code: $code, message: $message, cause: $cause)';
}
