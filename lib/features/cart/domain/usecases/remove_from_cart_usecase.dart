// Cart Domain - Remove From Cart Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/features/cart/domain.dart';

class RemoveFromCartUseCase extends UseCase<void, RemoveFromCartParams> {
  final CartRepository repository;

  const RemoveFromCartUseCase(this.repository);

  @override
  Future<DomainResult<void>> call(RemoveFromCartParams params) {
    return repository.removeItem(params.itemId);
  }
}

class RemoveFromCartParams {
  final String itemId;
  const RemoveFromCartParams({required this.itemId});
}