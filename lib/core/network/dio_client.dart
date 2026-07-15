// Network Layer - Dio Configuration & Interceptors
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';


import '../config/app_config.dart';
import '../errors/failures.dart';
import '../storage/secure_storage.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(
    SecureStorage secureStorage,
    @Named('baseUrl') String baseUrl,
    @Named('connectTimeout') int connectTimeout,
    @Named('receiveTimeout') int receiveTimeout,
    @Named('sendTimeout') int sendTimeout,
  ) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: connectTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      sendTimeout: Duration(milliseconds: sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) => status != null && status < 500,
    ));

    // Auth Interceptor
    dio.interceptors.add(AuthInterceptor(secureStorage));

    // Logging Interceptor (only in debug)
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: false,
        maxWidth: 120,
      ));
    }

    // Error Handling Interceptor
    dio.interceptors.add(ErrorHandlingInterceptor());

    // Retry Interceptor
    dio.interceptors.add(RetryInterceptor());

    return dio;
  }

  @Named('baseUrl')
  String get baseUrl => AppConfig.current.fullApiUrl;

  @Named('connectTimeout')
  int get connectTimeout => AppConfig.current.connectTimeout;

  @Named('receiveTimeout')
  int get receiveTimeout => AppConfig.current.receiveTimeout;

  @Named('sendTimeout')
  int get sendTimeout => AppConfig.current.sendTimeout;
}

/// Auth Interceptor - Adds Bearer token to requests
class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    final token = await _secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isAuthEndpoint(err.requestOptions.path)) {
      // Try to refresh token
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        // Retry original request
        final token = await _secureStorage.getAccessToken();
        err.requestOptions.headers['Authorization'] = 'Bearer $token';
        final response = await Dio().fetch(err.requestOptions);
        return handler.resolve(response);
      } else {
        // Clear tokens and notify auth state
        await _secureStorage.clearAuthTokens();
        // Navigation to login would be handled by app router
      }
    }
    return handler.next(err);
  }

  bool _isPublicEndpoint(String path) {
    const publicPaths = [
      '/auth/login',
      '/auth/register',
      '/auth/forgot-password',
      '/auth/reset-password',
      '/auth/refresh',
      '/products/public',
      '/categories/public',
    ];
    return publicPaths.any((p) => path.startsWith(p));
  }

  bool _isAuthEndpoint(String path) {
    return path.startsWith('/auth/');
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await Dio().post(
        '${AppConfig.current.fullApiUrl}/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        await _secureStorage.saveAccessToken(response.data['access_token']);
        if (response.data['refresh_token'] != null) {
          await _secureStorage.saveRefreshToken(response.data['refresh_token']);
        }
        return true;
      }
    } catch (_) {
      // Ignore refresh errors
    }
    return false;
  }
}

/// Error Handling Interceptor - Converts Dio errors to Failures
class ErrorHandlingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  Failure _mapToFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerFailure.fromDioError(err);
      case DioExceptionType.connectionError:
        return NetworkFailure.noConnection();
      case DioExceptionType.badResponse:
        return ServerFailure.fromDioError(err);
      case DioExceptionType.cancel:
        return const UnknownFailure(
          message: 'Request cancelled',
          code: 'REQUEST_CANCELLED',
        );
      case DioExceptionType.badCertificate:
        return const UnknownFailure(
          message: 'SSL Certificate error',
          code: 'BAD_CERTIFICATE',
        );
      case DioExceptionType.unknown:
        if (err.message?.contains('SocketException') == true) {
          return NetworkFailure.noConnection();
        }
        return UnknownFailure.fromError(err);
      default:
        return UnknownFailure.fromError(err);
    }
  }
}

/// Retry Interceptor - Automatic retry for failed requests
class RetryInterceptor extends Interceptor {
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final retryCount = (options.extra['retry_count'] as int?) ?? 0;

    if (_shouldRetry(err, retryCount)) {
      options.extra['retry_count'] = retryCount + 1;
      
      // Exponential backoff
      await Future.delayed(retryDelay * (retryCount + 1));
      
      try {
        final response = await Dio().fetch(options);
        return handler.resolve(response);
      } catch (e) {
        // If retry fails, continue with original error
        return handler.next(err);
      }
    }
    
    return handler.next(err);
  }

  bool _shouldRetry(DioException err, int retryCount) {
    if (retryCount >= maxRetries) return false;
    
    // Retry on network errors, timeouts, and 5xx errors
    return err.type == DioExceptionType.connectionError ||
           err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

