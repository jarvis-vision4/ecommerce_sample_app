// Wishlist Data - Local Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/storage/hive_storage.dart';


abstract class WishlistLocalDataSource {
  Future<DomainResult<void>> cacheWishlist(dynamic data);
  Future<DomainResult<dynamic>> getCachedWishlist();
  Future<DomainResult<void>> clearWishlistCache();
}

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  final HiveStorage hiveStorage;

  WishlistLocalDataSourceImpl(this.hiveStorage);

  @override
  Future<DomainResult<void>> cacheWishlist(dynamic data) {
    return DomainResult.safeCall(() async {
      await hiveStorage.cacheWishlist(data);
    });
  }

  @override
  Future<DomainResult<dynamic>> getCachedWishlist() {
    return DomainResult.safeCall(() async {
      return hiveStorage.getCachedWishlist();
    });
  }

  @override
  Future<DomainResult<void>> clearWishlistCache() {
    return DomainResult.safeCall(() async {
      await hiveStorage.wishlistBox.clear();
    });
  }
}