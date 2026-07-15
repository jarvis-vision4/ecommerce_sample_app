// Cart Data - Local Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/storage/hive_storage.dart';


abstract class CartLocalDataSource {
  Future<DomainResult<void>> cacheCart(dynamic data);
  Future<DomainResult<dynamic>> getCachedCart();
  Future<DomainResult<void>> clearCartCache();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final HiveStorage hiveStorage;

  CartLocalDataSourceImpl(this.hiveStorage);

  @override
  Future<DomainResult<void>> cacheCart(dynamic data) {
    return DomainResult.safeCall(() async {
      await hiveStorage.cacheCart(data);
    });
  }

  @override
  Future<DomainResult<dynamic>> getCachedCart() {
    return DomainResult.safeCall(() async {
      return hiveStorage.getCachedCart();
    });
  }

  @override
  Future<DomainResult<void>> clearCartCache() {
    return DomainResult.safeCall(() async {
      await hiveStorage.clearCartCache();
    });
  }
}