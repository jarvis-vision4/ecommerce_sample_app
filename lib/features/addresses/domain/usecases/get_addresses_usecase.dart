// Addresses Domain - Get Addresses Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/addresses/domain.dart';

class GetAddressesUseCase extends NoParamsUseCase<List<Address>> {
  final AddressesRepository repository;

  const GetAddressesUseCase(this.repository);

  @override
  Future<DomainResult<List<Address>>> call() {
    return repository.getAddresses();
  }
}