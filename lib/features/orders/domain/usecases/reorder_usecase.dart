// Orders Domain - Reorder Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/orders/domain.dart';

class ReorderUseCase extends UseCase<Order, ReorderParams> {
  final OrdersRepository repository;

  const ReorderUseCase(this.repository);

  @override
  Future<DomainResult<Order>> call(ReorderParams params) {
    return repository.reorder(params.id);
  }
}

class ReorderParams {
  final String id;
  const ReorderParams({required this.id});
}