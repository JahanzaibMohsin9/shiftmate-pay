import '../../core/common/result.dart';

Future<Result<T>> guardResult<T>(Future<T> Function() action) async {
  try {
    return Success(await action());
  } catch (error) {
    return Failure(
      AppError(
        code: 'repository_error',
        message: error.toString(),
        cause: error,
      ),
    );
  }
}

Result<T> unsupportedRepositoryResult<T>(String repositoryName) {
  return Failure(
    AppError(
      code: 'not_implemented',
      message: '$repositoryName is scaffolded but not implemented yet.',
    ),
  );
}
