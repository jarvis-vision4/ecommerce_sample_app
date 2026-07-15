// Auth Domain - Change Password Use Case
import 'package:flutter_ecommerce/core/domain.dart';


import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/auth/domain.dart';

class ChangePasswordUseCase extends UseCase<void, ChangePasswordParams> {
  final AuthRepository repository;

  const ChangePasswordUseCase(this.repository);

  @override
  Future<DomainResult<void>> call(ChangePasswordParams params) {
    return repository.changePassword(params.request);
  }
}

class ChangePasswordParams {
  final ChangePasswordRequest request;
  const ChangePasswordParams({required this.request});
}