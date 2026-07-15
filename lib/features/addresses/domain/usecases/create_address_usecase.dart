// Addresses Domain - Create Address Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/addresses/domain.dart';

class CreateAddressUseCase extends UseCase<Address, CreateAddressParams> {
  final AddressesRepository repository;

  const CreateAddressUseCase(this.repository);

  @override
  Future<DomainResult<Address>> call(CreateAddressParams params) {
    return repository.createAddress(params.request);
  }
}

class CreateAddressParams {
  final CreateAddressRequest request;
  const CreateAddressParams({required this.request});
}