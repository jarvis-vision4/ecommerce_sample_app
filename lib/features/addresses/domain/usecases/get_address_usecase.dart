// Addresses Domain - Get Address Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/addresses/domain.dart';

class GetAddressUseCase extends UseCase<Address, GetAddressParams> {
  final AddressesRepository repository;

  const GetAddressUseCase(this.repository);

  @override
  Future<DomainResult<Address>> call(GetAddressParams params) {
    return repository.getAddress(params.id);
  }
}

class GetAddressParams {
  final String id;
  const GetAddressParams({required this.id});
}