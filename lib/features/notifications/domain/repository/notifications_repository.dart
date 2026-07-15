// Notifications Domain - Repository Interface
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

abstract class NotificationsRepository {
  Future<DomainResult<PaginatedResponse<AppNotification>>> getNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  });
  Future<DomainResult<void>> markAsRead(String id);
  Future<DomainResult<void>> markAllAsRead();
  Future<DomainResult<void>> deleteNotification(String id);
}