// Cart Domain - Add To Cart Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/cart/domain.dart';

class AddToCartUseCase extends UseCase<CartItem, AddToCartParams> {
  final CartRepository repository;

  const AddToCartUseCase(this.repository);

  @override
  Future<DomainResult<CartItem>> call(AddToCartParams params) {
    return repository.addItem(params.request);
  }
}

class AddToCartParams {
  final AddToCartRequest request;
  const AddToCartParams({required this.request});
}