// Addresses Domain - Set Default Address Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/addresses/domain.dart';

class SetDefaultAddressUseCase extends UseCase<Address, SetDefaultAddressParams> {
  final AddressesRepository repository;

  const SetDefaultAddressUseCase(this.repository);

  @override
  Future<DomainResult<Address>> call(SetDefaultAddressParams params) {
    return repository.setDefaultAddress(params.id);
  }
}

class SetDefaultAddressParams {
  final String id;
  const SetDefaultAddressParams({required this.id});
}