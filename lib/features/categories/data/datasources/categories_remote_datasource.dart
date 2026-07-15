// Categories Data - Remote Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/network/api_client.dart' hide Result;
import 'package:flutter_ecommerce/shared/models.dart';

class CategoriesRemoteDataSource {
  final ApiClient apiClient;

  CategoriesRemoteDataSource(this.apiClient);

  Future<DomainResult<List<Category>>> getCategories({
    String? parentId,
    bool includeProductsCount = false,
  }) async {
    final result = await apiClient.getCategories(
      parentId: parentId,
      includeProductsCount: includeProductsCount,
    );
    return _convertResult(result);
  }

  Future<DomainResult<Category>> getCategory(String id) async {
    final result = await apiClient.getCategory(id);
    return _convertResult(result);
  }

  Future<DomainResult<List<Category>>> getChildCategories(String id) async {
    final result = await apiClient.getChildCategories(id);
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