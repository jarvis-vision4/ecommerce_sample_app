// Notifications Data - Repository Implementation
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/errors/failures.dart';
import 'package:flutter_ecommerce/core/network/network_info.dart';
import 'package:flutter_ecommerce/features/notifications/data/datasources/notifications_local_datasource.dart';
import 'package:flutter_ecommerce/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:flutter_ecommerce/features/notifications/domain/repository/notifications_repository.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  final NotificationsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NotificationsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<DomainResult<PaginatedResponse<AppNotification>>> getNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getNotifications(
        page: page,
        limit: limit,
        unreadOnly: unreadOnly,
      );
      if (result.isSuccess && page == 1) {
        await localDataSource.cacheNotifications(result.data!.data);
      }
      return result;
    } else {
      final cached = await localDataSource.getCachedNotifications();
      if (cached.isSuccess && cached.data != null) {
        // Create a simple paginated response from cache
        return DomainSuccess(PaginatedResponse<AppNotification>(
          data: cached.data!,
          meta: PaginationMeta(currentPage: 1, totalPages: 1, totalItems: cached.data!.length),
        ));
      }
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<void>> markAsRead(String id) {
    return remoteDataSource.markAsRead(id);
  }

  @override
  Future<DomainResult<void>> markAllAsRead() {
    return remoteDataSource.markAllAsRead();
  }

  @override
  Future<DomainResult<void>> deleteNotification(String id) {
    return remoteDataSource.deleteNotification(id);
  }
}