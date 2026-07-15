// Settings Data - Local Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/storage/hive_storage.dart';
import 'package:flutter_ecommerce/shared/models.dart';

abstract class SettingsLocalDataSource {
  Future<DomainResult<void>> cacheSettings(AppSettings settings);
  Future<DomainResult<AppSettings?>> getCachedSettings();
  Future<DomainResult<void>> clearSettingsCache();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final HiveStorage hiveStorage;

  SettingsLocalDataSourceImpl(this.hiveStorage);

  static const _key = 'app_settings';

  @override
  Future<DomainResult<void>> cacheSettings(AppSettings settings) {
    return DomainResult.safeCall(() async {
      await hiveStorage.settingsBox.put(_key, settings.toJson());
    });
  }

  @override
  Future<DomainResult<AppSettings?>> getCachedSettings() {
    return DomainResult.safeCall(() async {
      final data = hiveStorage.settingsBox.get(_key);
      if (data == null) return null;
      return AppSettings.fromJson(data as Map<String, dynamic>);
    });
  }

  @override
  Future<DomainResult<void>> clearSettingsCache() {
    return DomainResult.safeCall(() async {
      await hiveStorage.settingsBox.delete(_key);
    });
  }
}