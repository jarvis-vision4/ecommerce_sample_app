// Cart Data - Repository Implementation
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/errors/failures.dart';
import 'package:flutter_ecommerce/core/network/network_info.dart';
import 'package:flutter_ecommerce/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:flutter_ecommerce/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:flutter_ecommerce/features/cart/domain/repository/cart_repository.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final CartLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<DomainResult<Cart>> getCart() async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getCart();
      if (result.isSuccess) {
        await localDataSource.cacheCart(result.data!);
      }
      return result;
    } else {
      final cached = await localDataSource.getCachedCart();
      if (cached.isSuccess && cached.data != null) {
        return DomainSuccess(cached.data! as Cart);
      }
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<CartItem>> addItem(AddToCartRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.addItem(request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<CartItem>> updateItem(String itemId, UpdateCartItemRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.updateItem(itemId, request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<void>> removeItem(String itemId) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.removeItem(itemId);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<void>> clearCart() async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.clearCart();
      if (result.isSuccess) {
        await localDataSource.clearCartCache();
      }
      return result;
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<Cart>> applyCoupon(ApplyCouponRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.applyCoupon(request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<Cart>> removeCoupon() async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.removeCoupon();
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<CheckoutValidation>> validateCheckout(CheckoutRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.validateCheckout(request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }
}