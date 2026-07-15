// Categories Data - Repository Implementation
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/errors/failures.dart';
import 'package:flutter_ecommerce/core/network/network_info.dart';
import 'package:flutter_ecommerce/features/categories/data/datasources/categories_local_datasource.dart';
import 'package:flutter_ecommerce/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:flutter_ecommerce/features/categories/domain/repository/categories_repository.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;
  final CategoriesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CategoriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<DomainResult<List<Category>>> getCategories({
    String? parentId,
    bool includeProductsCount = false,
  }) async {
    const cacheKey = 'all_categories';
    
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getCategories(
        parentId: parentId,
        includeProductsCount: includeProductsCount,
      );
      if (result.isSuccess) {
        await localDataSource.cacheCategories(result.data!);
      }
      return result;
    } else {
      final cached = await localDataSource.getCachedCategories();
      if (cached.isSuccess && cached.data != null) {
        return DomainSuccess(cached.data! as List<Category>);
      }
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<Category>> getCategory(String id) async {
    final cacheKey = 'category_$id';
    
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getCategory(id);
      if (result.isSuccess) {
        await localDataSource.cacheCategories({cacheKey: result.data!});
      }
      return result;
    } else {
      // For single category, we don't have a great cache strategy without proper indexing
      // Fall back to network error
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<List<Category>>> getChildCategories(String id) async {
    final cacheKey = 'child_categories_$id';
    
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getChildCategories(id);
      if (result.isSuccess) {
        await localDataSource.cacheCategories({cacheKey: result.data!});
      }
      return result;
    } else {
      // Similar to getCategory, fallback
      return DomainFailure(NetworkFailure.noConnection());
    }
  }
}