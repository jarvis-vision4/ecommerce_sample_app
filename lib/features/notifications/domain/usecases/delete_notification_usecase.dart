// Notifications Domain - Delete Notification Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/features/notifications/domain.dart';

class DeleteNotificationUseCase extends UseCase<void, DeleteNotificationParams> {
  final NotificationsRepository repository;

  const DeleteNotificationUseCase(this.repository);

  @override
  Future<DomainResult<void>> call(DeleteNotificationParams params) {
    return repository.deleteNotification(params.id);
  }
}

class DeleteNotificationParams {
  final String id;
  const DeleteNotificationParams({required this.id});
}