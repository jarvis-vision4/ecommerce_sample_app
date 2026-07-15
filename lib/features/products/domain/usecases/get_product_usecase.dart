// Products Domain - Get Product Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/products/domain.dart';

class GetProductUseCase extends UseCase<Product, GetProductParams> {
  final ProductsRepository repository;

  const GetProductUseCase(this.repository);

  @override
  Future<DomainResult<Product>> call(GetProductParams params) {
    return repository.getProduct(params.id);
  }
}

class GetProductParams {
  final String id;
  const GetProductParams({required this.id});
}