// Settings Domain - Get Supported Currencies Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/settings/domain.dart';

class GetSupportedCurrenciesUseCase extends NoParamsUseCase<List<AppCurrency>> {
  final SettingsRepository repository;

  const GetSupportedCurrenciesUseCase(this.repository);

  @override
  Future<DomainResult<List<AppCurrency>>> call() {
    return repository.getSupportedCurrencies();
  }
}