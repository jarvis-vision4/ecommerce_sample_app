// Products Domain - Get Best Sellers Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/products/domain.dart';

class GetBestSellersUseCase extends UseCase<List<Product>, GetBestSellersParams> {
  final ProductsRepository repository;

  const GetBestSellersUseCase(this.repository);

  @override
  Future<DomainResult<List<Product>>> call(GetBestSellersParams params) {
    return repository.getBestSellers(limit: params.limit);
  }
}

class GetBestSellersParams {
  final int limit;
  const GetBestSellersParams({this.limit = 10});
}