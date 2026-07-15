// Categories Data - Local Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/storage/hive_storage.dart';


abstract class CategoriesLocalDataSource {
  Future<DomainResult<void>> cacheCategories(dynamic data, {Duration? ttl});
  Future<DomainResult<dynamic>> getCachedCategories();
}

class CategoriesLocalDataSourceImpl implements CategoriesLocalDataSource {
  final HiveStorage hiveStorage;

  CategoriesLocalDataSourceImpl(this.hiveStorage);

  @override
  Future<DomainResult<void>> cacheCategories(dynamic data, {Duration? ttl}) {
    return DomainResult.safeCall(() async {
      await hiveStorage.cacheCategories(data, ttl: ttl);
    });
  }

  @override
  Future<DomainResult<dynamic>> getCachedCategories() {
    return DomainResult.safeCall(() async {
      return hiveStorage.getCachedCategories();
    });
  }
}