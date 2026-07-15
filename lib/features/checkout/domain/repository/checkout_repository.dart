// Checkout Domain - Repository Interface
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models.dart';

abstract class CheckoutRepository {
  Future<DomainResult<CheckoutValidation>> validateCheckout(CheckoutRequest request);
  Future<DomainResult<PaymentIntent>> createPaymentIntent(CreatePaymentIntentRequest request);
  Future<DomainResult<PaymentConfirmation>> confirmPayment(ConfirmPaymentRequest request);
  Future<DomainResult<Order>> placeOrder(CreateOrderRequest request);
}