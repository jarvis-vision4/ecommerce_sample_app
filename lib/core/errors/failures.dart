// Core Error Handling - Functional error types using Dartz
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

/// Base failure class for all errors
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, originalError];

  @override
  String toString() => '$runtimeType: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Server/API failures
class ServerFailure extends Failure {
  final int? statusCode;
  final Map<String, dynamic>? responseData;

  const ServerFailure({
    required super.message,
    super.code,
    this.statusCode,
    this.responseData,
    super.originalError,
    super.stackTrace,
  });

  factory ServerFailure.fromDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    String message = _getMessageFromError(error);
    String? code = _getCodeFromError(error);

    return ServerFailure(
      message: message,
      code: code,
      statusCode: statusCode,
      responseData: data is Map ? Map<String, dynamic>.from(data) : null,
      originalError: error,
      stackTrace: error.stackTrace,
    );
  }

  static String _getMessageFromError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.connectionError:
        return 'Unable to connect to server. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final data = error.response?.data;
        if (data is Map && data.containsKey('message')) {
          return data['message'].toString();
        }
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.unknown:
        return error.message ?? 'An unknown error occurred';
      default:
        return 'An unexpected error occurred';
    }
  }

  static String? _getCodeFromError(DioException error) {
    final data = error.response?.data;
    if (data is Map && data.containsKey('code')) {
      return data['code'].toString();
    }
    return error.type.name;
  }

  @override
  List<Object?> get props => [...super.props, statusCode, responseData];
}

/// Network/connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory NetworkFailure.noConnection() => const NetworkFailure(
        message: 'No internet connection. Please check your network settings.',
        code: 'NO_CONNECTION',
      );

  factory NetworkFailure.weakSignal() => const NetworkFailure(
        message: 'Weak signal. Please try again.',
        code: 'WEAK_SIGNAL',
      );
}

/// Authentication failures
class AuthFailure extends Failure {
  final bool requiresReauth;

  const AuthFailure({
    required super.message,
    super.code,
    this.requiresReauth = false,
    super.originalError,
    super.stackTrace,
  });

  factory AuthFailure.unauthorized() => const AuthFailure(
        message: 'Session expired. Please log in again.',
        code: 'UNAUTHORIZED',
        requiresReauth: true,
      );

  factory AuthFailure.forbidden() => const AuthFailure(
        message: 'You don\'t have permission to perform this action.',
        code: 'FORBIDDEN',
      );

  factory AuthFailure.invalidCredentials() => const AuthFailure(
        message: 'Invalid email or password.',
        code: 'INVALID_CREDENTIALS',
      );

  factory AuthFailure.accountLocked() => const AuthFailure(
        message: 'Account temporarily locked. Please try again later.',
        code: 'ACCOUNT_LOCKED',
      );

  factory AuthFailure.emailNotVerified() => const AuthFailure(
        message: 'Please verify your email address.',
        code: 'EMAIL_NOT_VERIFIED',
      );
}

/// Validation failures
class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code,
    this.fieldErrors = const {},
    super.originalError,
    super.stackTrace,
  });

  factory ValidationFailure.fromValidationErrors(Map<String, List<String>> errors) {
    final firstError = errors.values.expand((e) => e).firstOrNull ?? 'Validation failed';
    return ValidationFailure(
      message: firstError,
      code: 'VALIDATION_ERROR',
      fieldErrors: errors,
    );
  }

  String? getFieldError(String field) => fieldErrors[field]?.firstOrNull;

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

/// Cache/Storage failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory CacheFailure.readError([Object? error]) => CacheFailure(
        message: 'Failed to read cached data',
        code: 'CACHE_READ_ERROR',
        originalError: error,
      );

  factory CacheFailure.writeError([Object? error]) => CacheFailure(
        message: 'Failed to save data',
        code: 'CACHE_WRITE_ERROR',
        originalError: error,
      );

  factory CacheFailure.deleteError([Object? error]) => CacheFailure(
        message: 'Failed to delete cached data',
        code: 'CACHE_DELETE_ERROR',
        originalError: error,
      );

  factory CacheFailure.notFound() => const CacheFailure(
        message: 'Data not found in cache',
        code: 'CACHE_NOT_FOUND',
      );
}

/// Permission failures
class PermissionFailure extends Failure {
  final String permission;

  const PermissionFailure({
    required this.permission,
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory PermissionFailure.denied(String permission) => PermissionFailure(
        permission: permission,
        message: 'Permission denied: $permission',
        code: 'PERMISSION_DENIED',
      );

  factory PermissionFailure.permanentlyDenied(String permission) => PermissionFailure(
        permission: permission,
        message: 'Permission permanently denied: $permission. Please enable in settings.',
        code: 'PERMISSION_PERMANENTLY_DENIED',
      );

  @override
  List<Object?> get props => [...super.props, permission];
}

/// Unknown/Unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory UnknownFailure.fromError(Object error, [StackTrace? stackTrace]) => UnknownFailure(
        message: error.toString(),
        code: 'UNKNOWN_ERROR',
        originalError: error,
        stackTrace: stackTrace,
      );
}



/// Mixin for classes that can fail - removed, use Result from api_client.dart instead