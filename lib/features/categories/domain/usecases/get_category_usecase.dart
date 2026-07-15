// Categories Domain - Get Category Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/categories/domain.dart';

class GetCategoryUseCase extends UseCase<Category, GetCategoryParams> {
  final CategoriesRepository repository;

  const GetCategoryUseCase(this.repository);

  @override
  Future<DomainResult<Category>> call(GetCategoryParams params) {
    return repository.getCategory(params.id);
  }
}

class GetCategoryParams {
  final String id;
  const GetCategoryParams({required this.id});
}