// Notifications Domain - Get Notifications Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/notifications/domain.dart';

class GetNotificationsUseCase
    extends UseCase<PaginatedResponse<AppNotification>, GetNotificationsParams> {
  final NotificationsRepository repository;

  const GetNotificationsUseCase(this.repository);

  @override
  Future<DomainResult<PaginatedResponse<AppNotification>>> call(GetNotificationsParams params) {
    return repository.getNotifications(
      page: params.page,
      limit: params.limit,
      unreadOnly: params.unreadOnly,
    );
  }
}

class GetNotificationsParams {
  final int page;
  final int limit;
  final bool unreadOnly;
  const GetNotificationsParams({
    this.page = 1,
    this.limit = 20,
    this.unreadOnly = false,
  });
}