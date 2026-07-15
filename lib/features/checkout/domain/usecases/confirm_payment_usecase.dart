// Checkout Domain - Confirm Payment Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/checkout/domain.dart';

class ConfirmPaymentUseCase extends UseCase<PaymentConfirmation, ConfirmPaymentParams> {
  final CheckoutRepository repository;

  const ConfirmPaymentUseCase(this.repository);

  @override
  Future<DomainResult<PaymentConfirmation>> call(ConfirmPaymentParams params) {
    return repository.confirmPayment(params.request);
  }
}

class ConfirmPaymentParams {
  final ConfirmPaymentRequest request;
  const ConfirmPaymentParams({required this.request});
}