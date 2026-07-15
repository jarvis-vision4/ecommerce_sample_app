// Settings Domain - Update Settings Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/settings/domain.dart';

class UpdateSettingsUseCase extends UseCase<void, UpdateSettingsParams> {
  final SettingsRepository repository;

  const UpdateSettingsUseCase(this.repository);

  @override
  Future<DomainResult<void>> call(UpdateSettingsParams params) {
    return repository.updateSettings(params.settings);
  }
}

class UpdateSettingsParams {
  final AppSettings settings;
  const UpdateSettingsParams({required this.settings});
}