// Products Domain - Repository Interface
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

abstract class ProductsRepository {
  Future<DomainResult<PaginatedResponse<Product>>> getProducts({
    int page,
    int limit,
    String? categoryId,
    String? search,
    String? sort,
    double? minPrice,
    double? maxPrice,
    String? brand,
    bool? inStock,
  });

  Future<DomainResult<Product>> getProduct(String id);

  Future<DomainResult<List<Product>>> getFeaturedProducts({int limit});

  Future<DomainResult<List<Product>>> getNewArrivals({int limit});

  Future<DomainResult<List<Product>>> getBestSellers({int limit});

  Future<DomainResult<List<Product>>> getRelatedProducts(String id, {int limit});

  Future<DomainResult<PaginatedResponse<Review>>> getProductReviews(
    String id, {
    int page,
    int limit,
  });

  Future<DomainResult<Review>> addReview(String id, CreateReviewRequest request);
}