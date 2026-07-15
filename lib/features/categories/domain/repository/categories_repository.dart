// Categories Domain - Repository Interface
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models.dart';

abstract class CategoriesRepository {
  Future<DomainResult<List<Category>>> getCategories({
    String? parentId,
    bool includeProductsCount,
  });
  
  Future<DomainResult<Category>> getCategory(String id);
  Future<DomainResult<List<Category>>> getChildCategories(String id);
}