// Payment Methods Domain - Repository Interface
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

abstract class PaymentMethodsRepository {
  Future<DomainResult<List<PaymentMethod>>> getPaymentMethods();
  Future<DomainResult<PaymentMethod>> addPaymentMethod(AddPaymentMethodRequest request);
  Future<DomainResult<void>> removePaymentMethod(String id);
  Future<DomainResult<PaymentMethod>> setDefaultPaymentMethod(String id);
}