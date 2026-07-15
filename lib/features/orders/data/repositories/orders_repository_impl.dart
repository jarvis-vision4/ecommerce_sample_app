// Orders Data - Repository Implementation
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/errors/failures.dart';
import 'package:flutter_ecommerce/core/network/network_info.dart';
import 'package:flutter_ecommerce/features/orders/data/datasources/orders_local_datasource.dart';
import 'package:flutter_ecommerce/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:flutter_ecommerce/features/orders/domain/repository/orders_repository.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;
  final OrdersLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<DomainResult<PaginatedResponse<Order>>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    final cacheKey = 'orders_${page}_${limit}_${status ?? ''}';
    
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getOrders(page: page, limit: limit, status: status);
      if (result.isSuccess && page == 1) {
        await localDataSource.cacheOrders(cacheKey, result.data!);
      }
      return result;
    } else {
      final cached = await localDataSource.getCachedOrders(cacheKey);
      if (cached.isSuccess && cached.data != null) {
        return DomainSuccess(cached.data! as PaginatedResponse<Order>);
      }
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<Order>> getOrder(String id) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.getOrder(id);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<Order>> createOrder(CreateOrderRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.createOrder(request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<Order>> cancelOrder(String id) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.cancelOrder(id);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<Order>> reorder(String id) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.reorder(id);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<OrderTracking>> getOrderTracking(String id) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.getOrderTracking(id);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<ReturnRequest>> requestReturn(String id, CreateReturnRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.requestReturn(id, request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }
}