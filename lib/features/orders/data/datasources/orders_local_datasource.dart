// Orders Data - Local Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/storage/hive_storage.dart';


abstract class OrdersLocalDataSource {
  Future<DomainResult<void>> cacheOrders(String key, dynamic data);
  Future<DomainResult<dynamic>> getCachedOrders(String key);
  Future<DomainResult<void>> clearOrdersCache();
}

class OrdersLocalDataSourceImpl implements OrdersLocalDataSource {
  final HiveStorage hiveStorage;

  OrdersLocalDataSourceImpl(this.hiveStorage);

  @override
  Future<DomainResult<void>> cacheOrders(String key, dynamic data) {
    return DomainResult.safeCall(() async {
      await hiveStorage.cacheOrders(key, data);
    });
  }

  @override
  Future<DomainResult<dynamic>> getCachedOrders(String key) {
    return DomainResult.safeCall(() async {
      return hiveStorage.getCachedOrders(key);
    });
  }

  @override
  Future<DomainResult<void>> clearOrdersCache() {
    return DomainResult.safeCall(() async {
      await hiveStorage.ordersBox.clear();
    });
  }
}