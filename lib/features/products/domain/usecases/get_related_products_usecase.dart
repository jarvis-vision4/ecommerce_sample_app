// Products Domain - Get Related Products Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/products/domain.dart';

class GetRelatedProductsUseCase extends UseCase<List<Product>, GetRelatedProductsParams> {
  final ProductsRepository repository;

  const GetRelatedProductsUseCase(this.repository);

  @override
  Future<DomainResult<List<Product>>> call(GetRelatedProductsParams params) {
    return repository.getRelatedProducts(params.productId, limit: params.limit);
  }
}

class GetRelatedProductsParams {
  final String productId;
  final int limit;
  const GetRelatedProductsParams({required this.productId, this.limit = 8});
}