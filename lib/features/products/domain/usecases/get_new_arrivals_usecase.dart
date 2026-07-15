// Products Domain - Get New Arrivals Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/products/domain.dart';

class GetNewArrivalsUseCase extends UseCase<List<Product>, GetNewArrivalsParams> {
  final ProductsRepository repository;

  const GetNewArrivalsUseCase(this.repository);

  @override
  Future<DomainResult<List<Product>>> call(GetNewArrivalsParams params) {
    return repository.getNewArrivals(limit: params.limit);
  }
}

class GetNewArrivalsParams {
  final int limit;
  const GetNewArrivalsParams({this.limit = 10});
}