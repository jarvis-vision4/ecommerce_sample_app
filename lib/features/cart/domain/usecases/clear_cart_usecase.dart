// Cart Domain - Clear Cart Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/features/cart/domain.dart';

class ClearCartUseCase extends NoParamsUseCase<void> {
  final CartRepository repository;

  const ClearCartUseCase(this.repository);

  @override
  Future<DomainResult<void>> call() {
    return repository.clearCart();
  }
}