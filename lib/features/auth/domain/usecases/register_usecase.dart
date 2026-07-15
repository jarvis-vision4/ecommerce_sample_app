// Auth Domain - Register Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/auth/domain.dart';

class RegisterUseCase extends UseCase<AuthResponse, RegisterParams> {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  @override
  Future<DomainResult<AuthResponse>> call(RegisterParams params) {
    return repository.register(params.request);
  }
}

class RegisterParams {
  final RegisterRequest request;
  const RegisterParams({required this.request});
}