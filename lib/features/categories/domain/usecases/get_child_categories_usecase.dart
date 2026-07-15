// Categories Domain - Get Child Categories Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/categories/domain.dart';

class GetChildCategoriesUseCase extends UseCase<List<Category>, GetChildCategoriesParams> {
  final CategoriesRepository repository;

  const GetChildCategoriesUseCase(this.repository);

  @override
  Future<DomainResult<List<Category>>> call(GetChildCategoriesParams params) {
    return repository.getChildCategories(params.id);
  }
}

class GetChildCategoriesParams {
  final String id;
  const GetChildCategoriesParams({required this.id});
}