// Addresses Data - Remote Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/network/api_client.dart' hide Result;
import 'package:flutter_ecommerce/shared/models.dart';

class AddressesRemoteDataSource {
  final ApiClient apiClient;

  AddressesRemoteDataSource(this.apiClient);

  Future<DomainResult<List<Address>>> getAddresses() async {
    final result = await apiClient.getAddresses();
    return _convertResult(result);
  }

  Future<DomainResult<Address>> getAddress(String id) async {
    final result = await apiClient.getAddress(id);
    return _convertResult(result);
  }

  Future<DomainResult<Address>> createAddress(CreateAddressRequest request) async {
    final result = await apiClient.createAddress(request);
    return _convertResult(result);
  }

  Future<DomainResult<Address>> updateAddress(String id, UpdateAddressRequest request) async {
    final result = await apiClient.updateAddress(id, request);
    return _convertResult(result);
  }

  Future<DomainResult<void>> deleteAddress(String id) async {
    final result = await apiClient.deleteAddress(id);
    return _convertResult(result);
  }

  Future<DomainResult<Address>> setDefaultAddress(String id) async {
    final result = await apiClient.setDefaultAddress(id);
    return _convertResult(result);
  }

  DomainResult<T> _convertResult<T>(dynamic apiResult) {
    if (apiResult is Success) {
      return DomainSuccess(apiResult.data as T);
    } else if (apiResult is ApiFailure) {
      return DomainFailure(apiResult.error);
    }
    return DomainFailure(Exception('Unknown result type'));
  }
}