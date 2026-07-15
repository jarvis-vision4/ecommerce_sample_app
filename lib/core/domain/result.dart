// Core Domain - Result Type for Functional Error Handling
// Uses sealed classes for exhaustive pattern matching

sealed class DomainResult<T> {
  const DomainResult();

  bool get isSuccess => this is DomainSuccess<T>;
  bool get isFailure => this is DomainFailure<T>;

  T? get data => switch (this) {
        DomainSuccess<T>(data: final d) => d,
        DomainFailure<T>() => null,
      };

  Object? get error => switch (this) {
        DomainSuccess<T>() => null,
        DomainFailure<T>(error: final e) => e,
      };

  T getOrElse(T defaultValue) => isSuccess ? data! : defaultValue;
  
  T getOrThrow() => switch (this) {
        DomainSuccess<T>(data: final d) => d,
        DomainFailure<T>(error: final e) => throw e,
      };

  DomainResult<U> map<U>(U Function(T) fn) => switch (this) {
        DomainSuccess<T>(data: final d) => DomainSuccess(fn(d)),
        DomainFailure<T>(error: final e) => DomainFailure(e),
      };

  Future<DomainResult<U>> asyncMap<U>(Future<U> Function(T) fn) async => switch (this) {
        DomainSuccess<T>(data: final d) => await _safeCall(() => fn(d)),
        DomainFailure<T>(error: final e) => DomainFailure(e),
      };

  void onSuccess(void Function(T) fn) {
    if (this is DomainSuccess<T>) fn((this as DomainSuccess<T>).data);
  }

  void onFailure(void Function(Object) fn) {
    if (this is DomainFailure<T>) fn((this as DomainFailure<T>).error);
  }

  static Future<DomainResult<T>> safeCall<T>(Future<T> Function() fn) async {
    try {
      final result = await fn();
      return DomainSuccess(result);
    } on Exception catch (e) {
      return DomainFailure(e);
    } catch (e, s) {
      return DomainFailure(AppException(e.toString(), s));
    }
  }
}

Future<DomainResult<T>> _safeCall<T>(Future<T> Function() fn) async {
  try {
    final result = await fn();
    return DomainSuccess(result);
  } on Exception catch (e) {
    return DomainFailure(e);
  } catch (e, s) {
    return DomainFailure(AppException(e.toString(), s));
  }
}

class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  
  const AppException(this.message, [this.stackTrace]);
  
  @override
  String toString() => 'AppException: $message';
}

final class DomainSuccess<T> extends DomainResult<T> {
  @override
  final T data;
  const DomainSuccess(this.data);
}

final class DomainFailure<T> extends DomainResult<T> {
  @override
  final Object error;
  const DomainFailure(this.error);
}