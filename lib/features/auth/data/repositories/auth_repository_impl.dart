// Auth Data - Repository Implementation
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_ecommerce/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_ecommerce/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_ecommerce/shared/models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<DomainResult<AuthResponse>> login(LoginRequest request) async {
    final result = await remoteDataSource.login(request);
    if (result.isSuccess) {
      await localDataSource.saveAuthTokens(result.data!);
    }
    return result;
  }

  @override
  Future<DomainResult<AuthResponse>> register(RegisterRequest request) async {
    final result = await remoteDataSource.register(request);
    if (result.isSuccess) {
      await localDataSource.saveAuthTokens(result.data!);
    }
    return result;
  }

  @override
  Future<DomainResult<void>> logout() async {
    await localDataSource.clearAuthTokens();
    return remoteDataSource.logout();
  }

  @override
  Future<DomainResult<TokenResponse>> refreshToken(RefreshTokenRequest request) async {
    final result = await remoteDataSource.refreshToken(request);
    if (result.isSuccess) {
      await localDataSource.updateAccessToken(result.data!.accessToken);
    }
    return result;
  }

  @override
  Future<DomainResult<void>> forgotPassword(ForgotPasswordRequest request) {
    return remoteDataSource.forgotPassword(request);
  }

  @override
  Future<DomainResult<void>> resetPassword(ResetPasswordRequest request) {
    return remoteDataSource.resetPassword(request);
  }

  @override
  Future<DomainResult<void>> verifyEmail(VerifyEmailRequest request) {
    return remoteDataSource.verifyEmail(request);
  }

  @override
  Future<DomainResult<UserProfile>> getCurrentUser() async {
    final cached = await localDataSource.getCachedUser();
    if (cached != null) {
      return DomainSuccess(cached);
    }
    final result = await remoteDataSource.getCurrentUser();
    if (result.isSuccess) {
      await localDataSource.cacheUser(result.data!);
    }
    return result;
  }

  @override
  Future<DomainResult<UserProfile>> updateProfile(UpdateProfileRequest request) async {
    final result = await remoteDataSource.updateProfile(request);
    if (result.isSuccess) {
      await localDataSource.cacheUser(result.data!);
    }
    return result;
  }

  @override
  Future<DomainResult<void>> changePassword(ChangePasswordRequest request) {
    return remoteDataSource.changePassword(request);
  }
}