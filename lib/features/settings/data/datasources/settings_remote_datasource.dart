// Settings Data - Remote Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/network/api_client.dart' hide Result;
import 'package:flutter_ecommerce/shared/models/models.dart';

class SettingsRemoteDataSource {
  final ApiClient apiClient;

  SettingsRemoteDataSource(this.apiClient);

  Future<DomainResult<AppSettings>> getAppSettings() async {
    final result = await apiClient.getAppSettings();
    return _convertResult(result);
  }

  Future<DomainResult<List<ShippingOption>>> getShippingOptions() async {
    final result = await apiClient.getShippingOptions();
    return _convertResult(result);
  }

  Future<DomainResult<List<AppCurrency>>> getSupportedCurrencies() async {
    final result = await apiClient.getSupportedCurrencies();
    return _convertResult(result);
  }

  Future<DomainResult<List<AvailablePaymentMethod>>> getAvailablePaymentMethods() async {
    final result = await apiClient.getAvailablePaymentMethods();
    return _convertResult(result);
  }

  Future<DomainResult<void>> updateSettings(AppSettings settings) async {
    final result = await apiClient.getAppSettings(); // Assuming PUT endpoint returns updated settings
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