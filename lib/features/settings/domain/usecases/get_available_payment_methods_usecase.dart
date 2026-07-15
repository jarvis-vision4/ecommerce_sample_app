// Settings Domain - Get Available Payment Methods Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/settings/domain.dart';

class GetAvailablePaymentMethodsUseCase extends NoParamsUseCase<List<AvailablePaymentMethod>> {
  final SettingsRepository repository;

  const GetAvailablePaymentMethodsUseCase(this.repository);

  @override
  Future<DomainResult<List<AvailablePaymentMethod>>> call() {
    return repository.getAvailablePaymentMethods();
  }
}