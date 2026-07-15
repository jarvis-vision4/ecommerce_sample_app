// Addresses Domain - Delete Address Use Case
import 'package:flutter_ecommerce/core/domain.dart';


import 'package:flutter_ecommerce/features/addresses/domain.dart';

class DeleteAddressUseCase extends UseCase<void, DeleteAddressParams> {
  final AddressesRepository repository;

  const DeleteAddressUseCase(this.repository);

  @override
  Future<DomainResult<void>> call(DeleteAddressParams params) {
    return repository.deleteAddress(params.id);
  }
}

class DeleteAddressParams {
  final String id;
  const DeleteAddressParams({required this.id});
}