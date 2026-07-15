// Cart Data - Remote Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/network/api_client.dart' hide Result;
import 'package:flutter_ecommerce/shared/models/models.dart';

abstract class CartRemoteDataSource {
  Future<DomainResult<Cart>> getCart();
  Future<DomainResult<CartItem>> addItem(AddToCartRequest request);
  Future<DomainResult<CartItem>> updateItem(String itemId, UpdateCartItemRequest request);
  Future<DomainResult<void>> removeItem(String itemId);
  Future<DomainResult<void>> clearCart();
  Future<DomainResult<Cart>> applyCoupon(ApplyCouponRequest request);
  Future<DomainResult<Cart>> removeCoupon();
  Future<DomainResult<CheckoutValidation>> validateCheckout(CheckoutRequest request);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient apiClient;

  CartRemoteDataSourceImpl(this.apiClient);

  @override
  Future<DomainResult<Cart>> getCart() async {
    final result = await apiClient.getCart();
    return _convertResult(result);
  }

  @override
  Future<DomainResult<CartItem>> addItem(AddToCartRequest request) async {
    final result = await apiClient.addToCart(request);
    return _convertResult(result);
  }

  @override
  Future<DomainResult<CartItem>> updateItem(String itemId, UpdateCartItemRequest request) async {
    final result = await apiClient.updateCartItem(itemId, request);
    return _convertResult(result);
  }

  @override
  Future<DomainResult<void>> removeItem(String itemId) async {
    final result = await apiClient.removeFromCart(itemId);
    return _convertResult(result);
  }

  @override
  Future<DomainResult<void>> clearCart() async {
    final result = await apiClient.clearCart();
    return _convertResult(result);
  }

  @override
  Future<DomainResult<Cart>> applyCoupon(ApplyCouponRequest request) async {
    final result = await apiClient.applyCoupon(request);
    return _convertResult(result);
  }

  @override
  Future<DomainResult<Cart>> removeCoupon() async {
    final result = await apiClient.removeCoupon();
    return _convertResult(result);
  }

  @override
  Future<DomainResult<CheckoutValidation>> validateCheckout(CheckoutRequest request) async {
    final result = await apiClient.validateCheckout(request);
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