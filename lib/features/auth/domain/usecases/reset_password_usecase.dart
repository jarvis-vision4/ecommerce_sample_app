// Auth Domain - Reset Password Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/auth/domain.dart';

class ResetPasswordUseCase extends UseCase<void, ResetPasswordParams> {
  final AuthRepository repository;

  const ResetPasswordUseCase(this.repository);

  @override
  Future<DomainResult<void>> call(ResetPasswordParams params) {
    return repository.resetPassword(params.request);
  }
}

class ResetPasswordParams {
  final ResetPasswordRequest request;
  const ResetPasswordParams({required this.request});
}