// Products Domain - Get Product Reviews Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/products/domain.dart';

class GetProductReviewsUseCase extends UseCase<PaginatedResponse<Review>, GetProductReviewsParams> {
  final ProductsRepository repository;

  const GetProductReviewsUseCase(this.repository);

  @override
  Future<DomainResult<PaginatedResponse<Review>>> call(GetProductReviewsParams params) {
    return repository.getProductReviews(params.productId, page: params.page, limit: params.limit);
  }
}

class GetProductReviewsParams {
  final String productId;
  final int page;
  final int limit;
  const GetProductReviewsParams({
    required this.productId,
    this.page = 1,
    this.limit = 10,
  });
}