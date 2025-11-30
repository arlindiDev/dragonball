/// A Result type that represents either a success or a failure.
/// 
/// Use [Result.success] to create a successful result.
/// Use [Result.error] to create a failed result.
sealed class Result<E, S> {
  const Result();

  /// Creates a successful result
  factory Result.success(S value) = Success<E, S>;

  /// Creates a failed result
  factory Result.error(E error) = Error<E, S>;

  /// Returns true if this is a success
  bool get isSuccess => this is Success<E, S>;

  /// Returns true if this is a failure
  bool get isError => this is Error<E, S>;

  /// Transforms the result by applying functions based on its state
  T when<T>({
    required T Function(S success) success,
    required T Function(E error) error,
  }) {
    if (this is Success<E, S>) {
      return success((this as Success<E, S>).value);
    } else {
      return error((this as Error<E, S>).error);
    }
  }

  /// Alternative to when() for convenience (similar to Either.fold)
  T fold<T>(
    T Function(E error) onError,
    T Function(S success) onSuccess,
  ) {
    return when(
      success: onSuccess,
      error: onError,
    );
  }
}

/// Represents a successful result
class Success<E, S> extends Result<E, S> {
  final S value;

  const Success(this.value);

  @override
  String toString() => 'Success($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<E, S> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Represents a failed result
class Error<E, S> extends Result<E, S> {
  final E error;

  const Error(this.error);

  @override
  String toString() => 'Error($error)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Error<E, S> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}

