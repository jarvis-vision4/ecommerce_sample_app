// Notifications Data - Local Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/storage/hive_storage.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

abstract class NotificationsLocalDataSource {
  Future<DomainResult<void>> cacheNotifications(List<AppNotification> notifications);
  Future<DomainResult<List<AppNotification>?>> getCachedNotifications();
  Future<DomainResult<void>> clearNotificationsCache();
}

class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  final HiveStorage hiveStorage;

  NotificationsLocalDataSourceImpl(this.hiveStorage);

  @override
  Future<DomainResult<void>> cacheNotifications(List<AppNotification> notifications) {
    return DomainResult.safeCall(() async {
      await hiveStorage.settingsBox.put(
        'notifications',
        notifications.map((n) => n.toJson()).toList(),
      );
    });
  }

  @override
  Future<DomainResult<List<AppNotification>?>> getCachedNotifications() {
    return DomainResult.safeCall(() async {
      final data = hiveStorage.settingsBox.get('notifications');
      if (data == null) return null;
      final list = data as List;
      return list.map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<DomainResult<void>> clearNotificationsCache() {
    return DomainResult.safeCall(() async {
      await hiveStorage.settingsBox.delete('notifications');
    });
  }
}