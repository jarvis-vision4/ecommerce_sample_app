// Orders Domain - Get Order Tracking Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/orders/domain.dart';

class GetOrderTrackingUseCase extends UseCase<OrderTracking, GetOrderTrackingParams> {
  final OrdersRepository repository;

  const GetOrderTrackingUseCase(this.repository);

  @override
  Future<DomainResult<OrderTracking>> call(GetOrderTrackingParams params) {
    return repository.getOrderTracking(params.id);
  }
}

class GetOrderTrackingParams {
  final String id;
  const GetOrderTrackingParams({required this.id});
}