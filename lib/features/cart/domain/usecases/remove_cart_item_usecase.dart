// Cart Domain - Remove Cart Item Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/features/cart/domain.dart';

class RemoveCartItemUseCase extends UseCase<void, RemoveCartItemParams> {
  final CartRepository repository;

  const RemoveCartItemUseCase(this.repository);

  @override
  Future<DomainResult<void>> call(RemoveCartItemParams params) {
    return repository.removeItem(params.itemId);
  }
}

class RemoveCartItemParams {
  final String itemId;
  const RemoveCartItemParams({required this.itemId});
}