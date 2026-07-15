// Notifications Data - Remote Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/network/api_client.dart' hide Result;
import 'package:flutter_ecommerce/shared/models.dart';

class NotificationsRemoteDataSource {
  final ApiClient apiClient;

  NotificationsRemoteDataSource(this.apiClient);

  Future<DomainResult<PaginatedResponse<AppNotification>>> getNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    final result = await apiClient.getNotifications(
      page: page,
      limit: limit,
      unreadOnly: unreadOnly,
    );
    return _convertResult(result);
  }

  Future<DomainResult<void>> markAsRead(String id) async {
    final result = await apiClient.markNotificationRead(id);
    return _convertResult(result);
  }

  Future<DomainResult<void>> markAllAsRead() async {
    final result = await apiClient.markAllNotificationsRead();
    return _convertResult(result);
  }

  Future<DomainResult<void>> deleteNotification(String id) async {
    final result = await apiClient.deleteNotification(id);
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