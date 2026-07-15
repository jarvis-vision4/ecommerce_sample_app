// Settings Domain - Get Shipping Options Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/settings/domain.dart';

class GetShippingOptionsUseCase extends NoParamsUseCase<List<ShippingOption>> {
  final SettingsRepository repository;

  const GetShippingOptionsUseCase(this.repository);

  @override
  Future<DomainResult<List<ShippingOption>>> call() {
    return repository.getShippingOptions();
  }
}