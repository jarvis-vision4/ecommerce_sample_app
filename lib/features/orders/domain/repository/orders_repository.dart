// Orders Domain - Repository Interface
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models.dart';

abstract class OrdersRepository {
  Future<DomainResult<PaginatedResponse<Order>>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
  });
  
  Future<DomainResult<Order>> getOrder(String id);
  Future<DomainResult<Order>> createOrder(CreateOrderRequest request);
  Future<DomainResult<Order>> cancelOrder(String id);
  Future<DomainResult<Order>> reorder(String id);
  Future<DomainResult<OrderTracking>> getOrderTracking(String id);
  Future<DomainResult<ReturnRequest>> requestReturn(String id, CreateReturnRequest request);
}