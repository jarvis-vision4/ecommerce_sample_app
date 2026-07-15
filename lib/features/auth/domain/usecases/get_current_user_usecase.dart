// Auth Domain - Get Current User Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/auth/domain.dart';

class GetCurrentUserUseCase extends UseCase<UserProfile, NoParams> {
  final AuthRepository repository;

  const GetCurrentUserUseCase(this.repository);

  @override
  Future<DomainResult<UserProfile>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}