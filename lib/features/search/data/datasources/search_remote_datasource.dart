// Search Data - Remote Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/network/api_client.dart' hide Result;
import 'package:flutter_ecommerce/shared/models.dart';

class SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSource(this.apiClient);

  Future<DomainResult<SearchResults>> search({
    required String query,
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? sort,
    double? minPrice,
    double? maxPrice,
  }) async {
    final result = await apiClient.search(
      query: query,
      page: page,
      limit: limit,
      categoryId: categoryId,
      sort: sort,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    return _convertResult(result);
  }

  Future<DomainResult<List<String>>> getSearchSuggestions(String query) async {
    final result = await apiClient.getSearchSuggestions(query);
    return _convertResult(result);
  }

  Future<DomainResult<List<String>>> getPopularSearches() async {
    final result = await apiClient.getPopularSearches();
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