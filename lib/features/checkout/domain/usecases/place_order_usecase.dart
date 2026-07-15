// Checkout Domain - Place Order Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/checkout/domain.dart';

class PlaceOrderUseCase extends UseCase<Order, PlaceOrderParams> {
  final CheckoutRepository repository;

  const PlaceOrderUseCase(this.repository);

  @override
  Future<DomainResult<Order>> call(PlaceOrderParams params) {
    return repository.placeOrder(params.request);
  }
}

class PlaceOrderParams {
  final CreateOrderRequest request;
  const PlaceOrderParams({required this.request});
}