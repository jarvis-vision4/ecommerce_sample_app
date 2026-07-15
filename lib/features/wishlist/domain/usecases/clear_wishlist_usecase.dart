// Wishlist Domain - Clear Wishlist Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/features/wishlist/domain.dart';

class ClearWishlistUseCase extends NoParamsUseCase<void> {
  final WishlistRepository repository;

  const ClearWishlistUseCase(this.repository);

  @override
  Future<DomainResult<void>> call() {
    return repository.clearWishlist();
  }
}