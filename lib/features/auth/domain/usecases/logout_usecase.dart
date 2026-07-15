// Auth Domain - Logout Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/features/auth/domain.dart';

class LogoutUseCase extends UseCase<void, NoParams> {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  @override
  Future<DomainResult<void>> call(NoParams params) {
    return repository.logout();
  }
}