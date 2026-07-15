// Checkout Domain - Create Order Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/checkout/domain.dart';

class CreateOrderUseCase extends UseCase<Order, CreateOrderParams> {
  final CheckoutRepository repository;

  const CreateOrderUseCase(this.repository);

  @override
  Future<DomainResult<Order>> call(CreateOrderParams params) {
    return repository.placeOrder(params.request);
  }
}

class CreateOrderParams {
  final CreateOrderRequest request;
  const CreateOrderParams({required this.request});
}