// Checkout Data - Remote Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/network/api_client.dart' hide Result;
import 'package:flutter_ecommerce/shared/models/models.dart';

class CheckoutRemoteDataSource {
  final ApiClient apiClient;

  CheckoutRemoteDataSource(this.apiClient);

  Future<DomainResult<CheckoutValidation>> validateCheckout(CheckoutRequest request) async {
    final result = await apiClient.validateCheckout(request);
    return _convertResult(result);
  }

  Future<DomainResult<Order>> placeOrder(CreateOrderRequest request) async {
    final result = await apiClient.createOrder(request);
    return _convertResult(result);
  }

  Future<DomainResult<PaymentIntent>> createPaymentIntent(CreatePaymentIntentRequest request) async {
    final result = await apiClient.createPaymentIntent(request);
    return _convertResult(result);
  }

  Future<DomainResult<PaymentConfirmation>> confirmPayment(ConfirmPaymentRequest request) async {
    final result = await apiClient.confirmPayment(request);
    return _convertResult(result);
  }

  DomainResult<T> _convertResult<T>(dynamic apiResult) {
    if (apiResult is Success) {
      return DomainSuccess(apiResult.data as T);
    } else if (apiResult is ApiFailure) {
      return DomainFailure(apiResult.error);
    }
    return DomainFailure(Exception('Unknown result type'));
  }
}