// Checkout Domain - Validate Checkout Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/checkout/domain.dart';

class ValidateCheckoutUseCase extends UseCase<CheckoutValidation, ValidateCheckoutParams> {
  final CheckoutRepository repository;

  const ValidateCheckoutUseCase(this.repository);

  @override
  Future<DomainResult<CheckoutValidation>> call(ValidateCheckoutParams params) {
    return repository.validateCheckout(params.request);
  }
}

class ValidateCheckoutParams {
  final CheckoutRequest request;
  const ValidateCheckoutParams({required this.request});
}