// Products Data - Remote Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/network/api_client.dart' hide Result;
import 'package:flutter_ecommerce/shared/models.dart';

class ProductsRemoteDataSource {
  final ApiClient apiClient;

  ProductsRemoteDataSource(this.apiClient);

  Future<DomainResult<PaginatedResponse<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? search,
    String? sort,
    double? minPrice,
    double? maxPrice,
    String? brand,
    bool? inStock,
  }) async {
    final result = await apiClient.getProducts(
      page: page,
      limit: limit,
      categoryId: categoryId,
      search: search,
      sort: sort,
      minPrice: minPrice,
      maxPrice: maxPrice,
      brand: brand,
      inStock: inStock,
    );
    return _convertResult(result);
  }

  Future<DomainResult<Product>> getProduct(String id) async {
    final result = await apiClient.getProduct(id);
    return _convertResult(result);
  }

  Future<DomainResult<List<Product>>> getFeaturedProducts({int limit = 10}) async {
    final result = await apiClient.getFeaturedProducts(limit: limit);
    return _convertResult(result);
  }

  Future<DomainResult<List<Product>>> getNewArrivals({int limit = 10}) async {
    final result = await apiClient.getNewArrivals(limit: limit);
    return _convertResult(result);
  }

  Future<DomainResult<List<Product>>> getBestSellers({int limit = 10}) async {
    final result = await apiClient.getBestSellers(limit: limit);
    return _convertResult(result);
  }

  Future<DomainResult<List<Product>>> getRelatedProducts(String id, {int limit = 8}) async {
    final result = await apiClient.getRelatedProducts(id, limit: limit);
    return _convertResult(result);
  }

  Future<DomainResult<PaginatedResponse<Review>>> getProductReviews(
    String id, {
    int page = 1,
    int limit = 10,
  }) async {
    final result = await apiClient.getProductReviews(id, page: page, limit: limit);
    return _convertResult(result);
  }

  Future<DomainResult<Review>> addReview(String id, CreateReviewRequest request) async {
    final result = await apiClient.addReview(id, request);
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