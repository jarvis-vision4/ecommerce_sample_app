// Auth Domain - Forgot Password Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/auth/domain.dart';

class ForgotPasswordUseCase extends UseCase<void, ForgotPasswordParams> {
  final AuthRepository repository;

  const ForgotPasswordUseCase(this.repository);

  @override
  Future<DomainResult<void>> call(ForgotPasswordParams params) {
    return repository.forgotPassword(params.request);
  }
}

class ForgotPasswordParams {
  final ForgotPasswordRequest request;
  const ForgotPasswordParams({required this.request});
}