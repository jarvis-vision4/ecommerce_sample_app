// Auth Data - Remote Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/network/api_client.dart' hide Result;
import 'package:flutter_ecommerce/shared/models.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<DomainResult<AuthResponse>> login(LoginRequest request) async {
    final result = await apiClient.login(request);
    return _convertResult(result);
  }

  Future<DomainResult<AuthResponse>> register(RegisterRequest request) async {
    final result = await apiClient.register(request);
    return _convertResult(result);
  }

  Future<DomainResult<void>> logout() async {
    final result = await apiClient.logout();
    return _convertResult(result);
  }

  Future<DomainResult<TokenResponse>> refreshToken(RefreshTokenRequest request) async {
    final result = await apiClient.refreshToken(request);
    return _convertResult(result);
  }

  Future<DomainResult<void>> forgotPassword(ForgotPasswordRequest request) async {
    final result = await apiClient.forgotPassword(request);
    return _convertResult(result);
  }

  Future<DomainResult<void>> resetPassword(ResetPasswordRequest request) async {
    final result = await apiClient.resetPassword(request);
    return _convertResult(result);
  }

  Future<DomainResult<void>> verifyEmail(VerifyEmailRequest request) async {
    final result = await apiClient.verifyEmail(request);
    return _convertResult(result);
  }

  Future<DomainResult<UserProfile>> getCurrentUser() async {
    final result = await apiClient.getCurrentUser();
    return _convertResult(result);
  }

  Future<DomainResult<UserProfile>> updateProfile(UpdateProfileRequest request) async {
    final result = await apiClient.updateProfile(request);
    return _convertResult(result);
  }

  Future<DomainResult<void>> changePassword(ChangePasswordRequest request) async {
    final result = await apiClient.changePassword(request);
    return _convertResult(result);
  }

  DomainResult<T> _convertResult<T>(dynamic apiResult) {
    if (apiResult is Success) {
      return DomainSuccess(apiResult.data as T);
    } else if (apiResult is ApiFailure) {
      return DomainFailure(apiResult.error);
    }
    return DomainFailure(Exception('Unknown result type'));
  }
}