// Wishlist Domain - Repository Interface
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models.dart';

abstract class WishlistRepository {
  Future<DomainResult<Wishlist>> getWishlist();
  Future<DomainResult<WishlistItem>> addItem(AddToWishlistRequest request);
  Future<DomainResult<void>> removeItem(String productId);
  Future<DomainResult<void>> clearWishlist();
}