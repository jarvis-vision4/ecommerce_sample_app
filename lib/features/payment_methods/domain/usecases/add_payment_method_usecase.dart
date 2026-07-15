// Payment Methods Domain - Add Payment Method Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/payment_methods/domain.dart';

class AddPaymentMethodUseCase extends UseCase<PaymentMethod, AddPaymentMethodParams> {
  final PaymentMethodsRepository repository;

  const AddPaymentMethodUseCase(this.repository);

  @override
  Future<DomainResult<PaymentMethod>> call(AddPaymentMethodParams params) {
    return repository.addPaymentMethod(params.request);
  }
}

class AddPaymentMethodParams {
  final AddPaymentMethodRequest request;
  const AddPaymentMethodParams({required this.request});
}