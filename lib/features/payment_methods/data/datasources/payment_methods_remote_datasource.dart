// Payment Methods Data - Remote Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/network/api_client.dart' hide Result;
import 'package:flutter_ecommerce/shared/models.dart';

class PaymentMethodsRemoteDataSource {
  final ApiClient apiClient;

  PaymentMethodsRemoteDataSource(this.apiClient);

  Future<DomainResult<List<PaymentMethod>>> getPaymentMethods() async {
    final result = await apiClient.getPaymentMethods();
    return _convertResult(result);
  }

  Future<DomainResult<PaymentMethod>> addPaymentMethod(AddPaymentMethodRequest request) async {
    final result = await apiClient.addPaymentMethod(request);
    return _convertResult(result);
  }

  Future<DomainResult<void>> removePaymentMethod(String id) async {
    final result = await apiClient.removePaymentMethod(id);
    return _convertResult(result);
  }

  Future<DomainResult<PaymentMethod>> setDefaultPaymentMethod(String id) async {
    final result = await apiClient.setDefaultPaymentMethod(id);
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