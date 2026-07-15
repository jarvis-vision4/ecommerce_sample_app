// Addresses Domain - Repository Interface
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

abstract class AddressesRepository {
  Future<DomainResult<List<Address>>> getAddresses();
  Future<DomainResult<Address>> getAddress(String id);
  Future<DomainResult<Address>> createAddress(CreateAddressRequest request);
  Future<DomainResult<Address>> updateAddress(String id, UpdateAddressRequest request);
  Future<DomainResult<void>> deleteAddress(String id);
  Future<DomainResult<Address>> setDefaultAddress(String id);
}