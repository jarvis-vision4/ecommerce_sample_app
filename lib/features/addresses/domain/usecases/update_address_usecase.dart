// Addresses Domain - Update Address Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/addresses/domain.dart';

class UpdateAddressUseCase extends UseCase<Address, UpdateAddressParams> {
  final AddressesRepository repository;

  const UpdateAddressUseCase(this.repository);

  @override
  Future<DomainResult<Address>> call(UpdateAddressParams params) {
    return repository.updateAddress(params.id, params.request);
  }
}

class UpdateAddressParams {
  final String id;
  final UpdateAddressRequest request;
  const UpdateAddressParams({required this.id, required this.request});
}