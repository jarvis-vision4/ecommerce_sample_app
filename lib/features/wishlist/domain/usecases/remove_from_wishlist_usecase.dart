// Wishlist Domain - Remove From Wishlist Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/features/wishlist/domain.dart';

class RemoveFromWishlistUseCase extends UseCase<void, RemoveFromWishlistParams> {
  final WishlistRepository repository;

  const RemoveFromWishlistUseCase(this.repository);

  @override
  Future<DomainResult<void>> call(RemoveFromWishlistParams params) {
    return repository.removeItem(params.productId);
  }
}

class RemoveFromWishlistParams {
  final String productId;
  const RemoveFromWishlistParams({required this.productId});
}