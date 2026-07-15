// Payment Methods Domain - Set Default Payment Method Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/payment_methods/domain.dart';

class SetDefaultPaymentMethodUseCase extends UseCase<PaymentMethod, SetDefaultPaymentMethodParams> {
  final PaymentMethodsRepository repository;

  const SetDefaultPaymentMethodUseCase(this.repository);

  @override
  Future<DomainResult<PaymentMethod>> call(SetDefaultPaymentMethodParams params) {
    return repository.setDefaultPaymentMethod(params.id);
  }
}

class SetDefaultPaymentMethodParams {
  final String id;
  const SetDefaultPaymentMethodParams({required this.id});
}