// Payment Methods Domain - Get Payment Methods Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/payment_methods/domain.dart';

class GetPaymentMethodsUseCase extends NoParamsUseCase<List<PaymentMethod>> {
  final PaymentMethodsRepository repository;

  const GetPaymentMethodsUseCase(this.repository);

  @override
  Future<DomainResult<List<PaymentMethod>>> call() {
    return repository.getPaymentMethods();
  }
}