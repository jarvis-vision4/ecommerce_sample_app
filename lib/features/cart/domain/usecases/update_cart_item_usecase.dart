// Cart Domain - Update Cart Item Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/cart/domain.dart';

class UpdateCartItemUseCase extends UseCase<CartItem, UpdateCartItemParams> {
  final CartRepository repository;

  const UpdateCartItemUseCase(this.repository);

  @override
  Future<DomainResult<CartItem>> call(UpdateCartItemParams params) {
    return repository.updateItem(params.itemId, params.request);
  }
}

class UpdateCartItemParams {
  final String itemId;
  final UpdateCartItemRequest request;
  const UpdateCartItemParams({required this.itemId, required this.request});
}