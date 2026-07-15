// Payment Methods Data - Local Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/storage/hive_storage.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

abstract class PaymentMethodsLocalDataSource {
  Future<DomainResult<void>> cachePaymentMethods(List<PaymentMethod> methods);
  Future<DomainResult<List<PaymentMethod>?>> getCachedPaymentMethods();
  Future<DomainResult<void>> clearPaymentMethodsCache();
}

class PaymentMethodsLocalDataSourceImpl implements PaymentMethodsLocalDataSource {
  final HiveStorage hiveStorage;

  PaymentMethodsLocalDataSourceImpl(this.hiveStorage);

  static const _key = 'payment_methods';

  @override
  Future<DomainResult<void>> cachePaymentMethods(List<PaymentMethod> methods) {
    return DomainResult.safeCall(() async {
      await hiveStorage.settingsBox.put(_key, methods.map((m) => m.toJson()).toList());
    });
  }

  @override
  Future<DomainResult<List<PaymentMethod>?>> getCachedPaymentMethods() {
    return DomainResult.safeCall(() async {
      final data = hiveStorage.settingsBox.get(_key);
      if (data == null) return null;
      final list = data as List;
      return list.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<DomainResult<void>> clearPaymentMethodsCache() {
    return DomainResult.safeCall(() async {
      await hiveStorage.settingsBox.delete(_key);
    });
  }
}