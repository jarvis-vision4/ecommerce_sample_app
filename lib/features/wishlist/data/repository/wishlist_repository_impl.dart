// Wishlist Data - Repository Implementation
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/errors/failures.dart';
import 'package:flutter_ecommerce/core/network/network_info.dart';
import 'package:flutter_ecommerce/features/wishlist/data/datasources/wishlist_local_datasource.dart';
import 'package:flutter_ecommerce/features/wishlist/data/datasources/wishlist_remote_datasource.dart';
import 'package:flutter_ecommerce/features/wishlist/domain/repository/wishlist_repository.dart';
import 'package:flutter_ecommerce/shared/models.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource remoteDataSource;
  final WishlistLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WishlistRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<DomainResult<Wishlist>> getWishlist() async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getWishlist();
      if (result.isSuccess) {
        await localDataSource.cacheWishlist(result.data!);
      }
      return result;
    } else {
      final cached = await localDataSource.getCachedWishlist();
      if (cached.isSuccess && cached.data != null) {
        return DomainSuccess(cached.data! as Wishlist);
      }
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<WishlistItem>> addItem(AddToWishlistRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.addItem(request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<void>> removeItem(String productId) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.removeItem(productId);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<void>> clearWishlist() async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.clearWishlist();
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }
}