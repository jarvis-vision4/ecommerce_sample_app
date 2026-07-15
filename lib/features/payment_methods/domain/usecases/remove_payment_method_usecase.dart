// Payment Methods Domain - Remove Payment Method Use Case
import 'package:flutter_ecommerce/core/domain.dart';

import 'package:flutter_ecommerce/features/payment_methods/domain.dart';

class RemovePaymentMethodUseCase extends UseCase<void, RemovePaymentMethodParams> {
  final PaymentMethodsRepository repository;

  const RemovePaymentMethodUseCase(this.repository);

  @override
  Future<DomainResult<void>> call(RemovePaymentMethodParams params) {
    return repository.removePaymentMethod(params.id);
  }
}

class RemovePaymentMethodParams {
  final String id;
  const RemovePaymentMethodParams({required this.id});
}