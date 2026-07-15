// Products Domain - Add Review Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/products/domain.dart';

class AddReviewUseCase extends UseCase<Review, AddReviewParams> {
  final ProductsRepository repository;

  const AddReviewUseCase(this.repository);

  @override
  Future<DomainResult<Review>> call(AddReviewParams params) {
    return repository.addReview(params.productId, params.request);
  }
}

class AddReviewParams {
  final String productId;
  final CreateReviewRequest request;
  const AddReviewParams({required this.productId, required this.request});
}