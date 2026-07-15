// Products Data - Local Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/storage/hive_storage.dart';
import 'package:flutter_ecommerce/shared/models.dart';

abstract class ProductsLocalDataSource {
  Future<DomainResult<void>> cacheProducts(String key, dynamic data, {Duration? ttl});
  Future<DomainResult<dynamic>> getCachedProducts(String key);
  Future<DomainResult<void>> clearProductsCache();
  
  Future<DomainResult<void>> cacheProduct(String key, Product product);
  Future<DomainResult<Product?>> getCachedProduct(String key);
  
  Future<DomainResult<void>> cacheProductsList(String key, List<Product> products);
  Future<DomainResult<List<Product>?>> getCachedProductsList(String key);
}

class ProductsLocalDataSourceImpl implements ProductsLocalDataSource {
  final HiveStorage hiveStorage;

  ProductsLocalDataSourceImpl(this.hiveStorage);

  @override
  Future<DomainResult<void>> cacheProducts(String key, dynamic data, {Duration? ttl}) {
    return DomainResult.safeCall(() async {
      await hiveStorage.cacheProducts(key, data, ttl: ttl);
    });
  }

  @override
  Future<DomainResult<dynamic>> getCachedProducts(String key) {
    return DomainResult.safeCall(() async {
      return hiveStorage.getCachedProducts(key);
    });
  }

  @override
  Future<DomainResult<void>> clearProductsCache() {
    return DomainResult.safeCall(() async {
      await hiveStorage.clearProductsCache();
    });
  }

  @override
  Future<DomainResult<void>> cacheProduct(String key, Product product) {
    return DomainResult.safeCall(() async {
      await hiveStorage.cacheProducts(key, product.toJson());
    });
  }

  @override
  Future<DomainResult<Product?>> getCachedProduct(String key) {
    return DomainResult.safeCall(() async {
      final data = hiveStorage.getCachedProducts(key);
      if (data == null) return null;
      return Product.fromJson(data as Map<String, dynamic>);
    });
  }

  @override
  Future<DomainResult<void>> cacheProductsList(String key, List<Product> products) {
    return DomainResult.safeCall(() async {
      await hiveStorage.cacheProducts(key, products.map((p) => p.toJson()).toList());
    });
  }

  @override
  Future<DomainResult<List<Product>?>> getCachedProductsList(String key) {
    return DomainResult.safeCall(() async {
      final data = hiveStorage.getCachedProducts(key);
      if (data == null) return null;
      final list = data as List;
      return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    });
  }
}