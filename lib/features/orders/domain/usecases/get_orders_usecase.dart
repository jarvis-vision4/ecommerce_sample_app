// Orders Domain - Get Orders Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/orders/domain.dart';

class GetOrdersUseCase extends UseCase<PaginatedResponse<Order>, GetOrdersParams> {
  final OrdersRepository repository;

  const GetOrdersUseCase(this.repository);

  @override
  Future<DomainResult<PaginatedResponse<Order>>> call(GetOrdersParams params) {
    return repository.getOrders(
      page: params.page,
      limit: params.limit,
      status: params.status,
    );
  }
}

class GetOrdersParams {
  final int page;
  final int limit;
  final String? status;
  const GetOrdersParams({
    this.page = 1,
    this.limit = 20,
    this.status,
  });
}