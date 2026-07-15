// Addresses Data - Local Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/storage/hive_storage.dart';
import 'package:flutter_ecommerce/shared/models.dart';

abstract class AddressesLocalDataSource {
  Future<DomainResult<void>> cacheAddresses(List<Address> addresses);
  Future<DomainResult<List<Address>?>> getCachedAddresses();
  Future<DomainResult<void>> clearAddressesCache();
}

class AddressesLocalDataSourceImpl implements AddressesLocalDataSource {
  final HiveStorage hiveStorage;

  AddressesLocalDataSourceImpl(this.hiveStorage);

  @override
  Future<DomainResult<void>> cacheAddresses(List<Address> addresses) {
    return DomainResult.safeCall(() async {
      await hiveStorage.cacheAddresses('addresses', addresses.map((a) => a.toJson()).toList());
    });
  }

  @override
  Future<DomainResult<List<Address>?>> getCachedAddresses() {
    return DomainResult.safeCall(() async {
      final data = hiveStorage.getCachedAddresses('addresses');
      if (data == null) return null;
      final list = data as List;
      return list.map((e) => Address.fromJson(e as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<DomainResult<void>> clearAddressesCache() {
    return DomainResult.safeCall(() async {
      await hiveStorage.addressesBox.clear();
    });
  }
}