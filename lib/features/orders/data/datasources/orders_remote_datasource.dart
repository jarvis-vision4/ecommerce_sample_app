// Orders Data - Remote Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/network/api_client.dart' hide Result;
import 'package:flutter_ecommerce/shared/models.dart';

abstract class OrdersRemoteDataSource {
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

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ApiClient apiClient;

  OrdersRemoteDataSourceImpl(this.apiClient);

  @override
  Future<DomainResult<PaginatedResponse<Order>>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    final result = await apiClient.getOrders(page: page, limit: limit, status: status);
    return _convertResult(result);
  }

  @override
  Future<DomainResult<Order>> getOrder(String id) async {
    final result = await apiClient.getOrder(id);
    return _convertResult(result);
  }

  @override
  Future<DomainResult<Order>> createOrder(CreateOrderRequest request) async {
    final result = await apiClient.createOrder(request);
    return _convertResult(result);
  }

  @override
  Future<DomainResult<Order>> cancelOrder(String id) async {
    final result = await apiClient.cancelOrder(id);
    return _convertResult(result);
  }

  @override
  Future<DomainResult<Order>> reorder(String id) async {
    final result = await apiClient.reorder(id);
    return _convertResult(result);
  }

  @override
  Future<DomainResult<OrderTracking>> getOrderTracking(String id) async {
    final result = await apiClient.getOrderTracking(id);
    return _convertResult(result);
  }

  @override
  Future<DomainResult<ReturnRequest>> requestReturn(String id, CreateReturnRequest request) async {
    final result = await apiClient.requestReturn(id, request);
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