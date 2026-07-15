// Auth Domain - Refresh Token Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/auth/domain.dart';

class RefreshTokenUseCase extends UseCase<TokenResponse, RefreshTokenParams> {
  final AuthRepository repository;

  const RefreshTokenUseCase(this.repository);

  @override
  Future<DomainResult<TokenResponse>> call(RefreshTokenParams params) {
    return repository.refreshToken(params.request);
  }
}

class RefreshTokenParams {
  final RefreshTokenRequest request;
  const RefreshTokenParams({required this.request});
}