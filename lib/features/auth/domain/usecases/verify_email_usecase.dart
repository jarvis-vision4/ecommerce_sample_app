// Auth Domain - Verify Email Use Case
import 'package:flutter_ecommerce/core/domain.dart';


import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/auth/domain.dart';

class VerifyEmailUseCase extends UseCase<void, VerifyEmailParams> {
  final AuthRepository repository;

  const VerifyEmailUseCase(this.repository);

  @override
  Future<DomainResult<void>> call(VerifyEmailParams params) {
    return repository.verifyEmail(params.request);
  }
}

class VerifyEmailParams {
  final VerifyEmailRequest request;
  const VerifyEmailParams({required this.request});
}