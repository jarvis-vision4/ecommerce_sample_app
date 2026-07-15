// Cart Domain - Remove Coupon Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/cart/domain.dart';

class RemoveCouponUseCase extends NoParamsUseCase<Cart> {
  final CartRepository repository;

  const RemoveCouponUseCase(this.repository);

  @override
  Future<DomainResult<Cart>> call() {
    return repository.removeCoupon();
  }
}