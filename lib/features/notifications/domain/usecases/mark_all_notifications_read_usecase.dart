// Notifications Domain - Mark All As Read Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/features/notifications/domain.dart';

class MarkAllNotificationsReadUseCase extends NoParamsUseCase<void> {
  final NotificationsRepository repository;

  const MarkAllNotificationsReadUseCase(this.repository);

  @override
  Future<DomainResult<void>> call() {
    return repository.markAllAsRead();
  }
}