// Cart Domain - Apply Coupon Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/cart/domain.dart';

class ApplyCouponUseCase extends UseCase<Cart, ApplyCouponParams> {
  final CartRepository repository;

  const ApplyCouponUseCase(this.repository);

  @override
  Future<DomainResult<Cart>> call(ApplyCouponParams params) {
    return repository.applyCoupon(params.request);
  }
}

class ApplyCouponParams {
  final ApplyCouponRequest request;
  const ApplyCouponParams({required this.request});
}