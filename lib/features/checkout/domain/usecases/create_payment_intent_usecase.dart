// Checkout Domain - Create Payment Intent Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/checkout/domain.dart';

class CreatePaymentIntentUseCase extends UseCase<PaymentIntent, CreatePaymentIntentParams> {
  final CheckoutRepository repository;

  const CreatePaymentIntentUseCase(this.repository);

  @override
  Future<DomainResult<PaymentIntent>> call(CreatePaymentIntentParams params) {
    return repository.createPaymentIntent(params.request);
  }
}

class CreatePaymentIntentParams {
  final CreatePaymentIntentRequest request;
  const CreatePaymentIntentParams({required this.request});
}