// Cart Domain - Repository Interface
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

abstract class CartRepository {
  Future<DomainResult<Cart>> getCart();
  Future<DomainResult<CartItem>> addItem(AddToCartRequest request);
  Future<DomainResult<CartItem>> updateItem(String itemId, UpdateCartItemRequest request);
  Future<DomainResult<void>> removeItem(String itemId);
  Future<DomainResult<void>> clearCart();
  Future<DomainResult<Cart>> applyCoupon(ApplyCouponRequest request);
  Future<DomainResult<Cart>> removeCoupon();
  Future<DomainResult<CheckoutValidation>> validateCheckout(CheckoutRequest request);
}