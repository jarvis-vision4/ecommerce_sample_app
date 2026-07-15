// Notifications Domain - Mark As Read Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/features/notifications/domain.dart';

class MarkNotificationReadUseCase extends UseCase<void, MarkNotificationReadParams> {
  final NotificationsRepository repository;

  const MarkNotificationReadUseCase(this.repository);

  @override
  Future<DomainResult<void>> call(MarkNotificationReadParams params) {
    return repository.markAsRead(params.id);
  }
}

class MarkNotificationReadParams {
  final String id;
  const MarkNotificationReadParams({required this.id});
}