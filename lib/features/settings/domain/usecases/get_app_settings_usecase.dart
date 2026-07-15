// Settings Domain - Get App Settings Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/settings/domain.dart';

class GetAppSettingsUseCase extends NoParamsUseCase<AppSettings> {
  final SettingsRepository repository;

  const GetAppSettingsUseCase(this.repository);

  @override
  Future<DomainResult<AppSettings>> call() {
    return repository.getAppSettings();
  }
}