// Addresses Data - Repository Implementation
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/errors/failures.dart';
import 'package:flutter_ecommerce/core/network/network_info.dart';
import 'package:flutter_ecommerce/features/addresses/data/datasources/addresses_local_datasource.dart';
import 'package:flutter_ecommerce/features/addresses/data/datasources/addresses_remote_datasource.dart';
import 'package:flutter_ecommerce/features/addresses/domain/repository/addresses_repository.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

class AddressesRepositoryImpl implements AddressesRepository {
  final AddressesRemoteDataSource remoteDataSource;
  final AddressesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AddressesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<DomainResult<List<Address>>> getAddresses() async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getAddresses();
      if (result.isSuccess) {
        await localDataSource.cacheAddresses(result.data!);
      }
      return result;
    } else {
      final cached = await localDataSource.getCachedAddresses();
      if (cached.isSuccess && cached.data != null) {
        return DomainSuccess(cached.data!);
      }
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<Address>> getAddress(String id) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.getAddress(id);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<Address>> createAddress(CreateAddressRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.createAddress(request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<Address>> updateAddress(String id, UpdateAddressRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.updateAddress(id, request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<void>> deleteAddress(String id) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.deleteAddress(id);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<Address>> setDefaultAddress(String id) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.setDefaultAddress(id);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }
}