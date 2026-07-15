// Wishlist Domain - Add To Wishlist Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/features/wishlist/domain.dart';
import 'package:flutter_ecommerce/shared/models.dart';

class AddToWishlistUseCase extends UseCase<WishlistItem, AddToWishlistParams> {
  final WishlistRepository repository;

  const AddToWishlistUseCase(this.repository);

  @override
  Future<DomainResult<WishlistItem>> call(AddToWishlistParams params) {
    return repository.addItem(params.request);
  }
}

class AddToWishlistParams {
  final AddToWishlistRequest request;
  const AddToWishlistParams({required this.request});
}