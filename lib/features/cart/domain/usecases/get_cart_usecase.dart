// Cart Domain - Get Cart Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/cart/domain.dart';

class GetCartUseCase extends NoParamsUseCase<Cart> {
  final CartRepository repository;

  const GetCartUseCase(this.repository);

  @override
  Future<DomainResult<Cart>> call() {
    return repository.getCart();
  }
}