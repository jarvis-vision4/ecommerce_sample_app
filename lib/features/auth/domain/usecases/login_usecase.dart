// Auth Domain - Login Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/auth/domain.dart';

class LoginUseCase extends UseCase<AuthResponse, LoginParams> {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  @override
  Future<DomainResult<AuthResponse>> call(LoginParams params) {
    return repository.login(params.request);
  }
}

class LoginParams {
  final LoginRequest request;
  const LoginParams({required this.request});
}