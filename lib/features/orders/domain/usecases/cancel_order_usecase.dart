// Orders Domain - Cancel Order Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/orders/domain.dart';

class CancelOrderUseCase extends UseCase<Order, CancelOrderParams> {
  final OrdersRepository repository;

  const CancelOrderUseCase(this.repository);

  @override
  Future<DomainResult<Order>> call(CancelOrderParams params) {
    return repository.cancelOrder(params.id);
  }
}

class CancelOrderParams {
  final String id;
  const CancelOrderParams({required this.id});
}