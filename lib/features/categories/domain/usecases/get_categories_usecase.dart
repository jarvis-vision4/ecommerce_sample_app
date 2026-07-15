// Categories Domain - Get Categories Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models.dart';
import 'package:flutter_ecommerce/features/categories/domain.dart';

class GetCategoriesUseCase extends UseCase<List<Category>, GetCategoriesParams> {
  final CategoriesRepository repository;

  const GetCategoriesUseCase(this.repository);

  @override
  Future<DomainResult<List<Category>>> call(GetCategoriesParams params) {
    return repository.getCategories(
      parentId: params.parentId,
      includeProductsCount: params.includeProductsCount,
    );
  }
}

class GetCategoriesParams {
  final String? parentId;
  final bool includeProductsCount;

  const GetCategoriesParams({
    this.parentId,
    this.includeProductsCount = false,
  });
}