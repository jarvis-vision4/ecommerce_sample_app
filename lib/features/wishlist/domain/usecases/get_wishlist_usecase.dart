// Wishlist Domain - Get Wishlist Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/features/wishlist/domain.dart';
import 'package:flutter_ecommerce/shared/models.dart';

class GetWishlistUseCase extends NoParamsUseCase<Wishlist> {
  final WishlistRepository repository;

  const GetWishlistUseCase(this.repository);

  @override
  Future<DomainResult<Wishlist>> call() {
    return repository.getWishlist();
  }
}