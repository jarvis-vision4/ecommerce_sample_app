// Products Domain - Get Featured Products Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/products/domain.dart';

class GetFeaturedProductsUseCase extends UseCase<List<Product>, GetFeaturedProductsParams> {
  final ProductsRepository repository;

  const GetFeaturedProductsUseCase(this.repository);

  @override
  Future<DomainResult<List<Product>>> call(GetFeaturedProductsParams params) {
    return repository.getFeaturedProducts(limit: params.limit);
  }
}

class GetFeaturedProductsParams {
  final int limit;
  const GetFeaturedProductsParams({this.limit = 10});
}