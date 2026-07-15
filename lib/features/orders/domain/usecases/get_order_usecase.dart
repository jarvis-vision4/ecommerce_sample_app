// Orders Domain - Get Order Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/orders/domain.dart';

class GetOrderUseCase extends UseCase<Order, GetOrderParams> {
  final OrdersRepository repository;

  const GetOrderUseCase(this.repository);

  @override
  Future<DomainResult<Order>> call(GetOrderParams params) {
    return repository.getOrder(params.id);
  }
}

class GetOrderParams {
  final String id;
  const GetOrderParams({required this.id});
}