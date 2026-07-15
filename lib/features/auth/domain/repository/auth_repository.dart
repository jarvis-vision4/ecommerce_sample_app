// Auth Domain - Repository Interface
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models.dart';

abstract class AuthRepository {
  Future<DomainResult<AuthResponse>> login(LoginRequest request);
  Future<DomainResult<AuthResponse>> register(RegisterRequest request);
  Future<DomainResult<void>> logout();
  Future<DomainResult<TokenResponse>> refreshToken(RefreshTokenRequest request);
  Future<DomainResult<void>> forgotPassword(ForgotPasswordRequest request);
  Future<DomainResult<void>> resetPassword(ResetPasswordRequest request);
  Future<DomainResult<void>> verifyEmail(VerifyEmailRequest request);
  Future<DomainResult<UserProfile>> getCurrentUser();
  Future<DomainResult<UserProfile>> updateProfile(UpdateProfileRequest request);
  Future<DomainResult<void>> changePassword(ChangePasswordRequest request);
}