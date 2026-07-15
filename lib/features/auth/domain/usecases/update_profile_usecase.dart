// Auth Domain - Update Profile Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/auth/domain.dart';

class UpdateProfileUseCase extends UseCase<UserProfile, UpdateProfileParams> {
  final AuthRepository repository;

  const UpdateProfileUseCase(this.repository);

  @override
  Future<DomainResult<UserProfile>> call(UpdateProfileParams params) {
    return repository.updateProfile(params.request);
  }
}

class UpdateProfileParams {
  final UpdateProfileRequest request;
  const UpdateProfileParams({required this.request});
}