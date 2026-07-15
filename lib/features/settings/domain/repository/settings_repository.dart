// Settings Domain - Repository Interface
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

abstract class SettingsRepository {
  Future<DomainResult<AppSettings>> getAppSettings();
  Future<DomainResult<List<ShippingOption>>> getShippingOptions();
  Future<DomainResult<List<AppCurrency>>> getSupportedCurrencies();
  Future<DomainResult<List<AvailablePaymentMethod>>> getAvailablePaymentMethods();
  Future<DomainResult<void>> updateSettings(AppSettings settings);
}