// Products Data - Repository Implementation
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/errors/failures.dart';
import 'package:flutter_ecommerce/core/network/network_info.dart';
import 'package:flutter_ecommerce/features/products/data/datasources/products_local_datasource.dart';
import 'package:flutter_ecommerce/features/products/data/datasources/products_remote_datasource.dart';
import 'package:flutter_ecommerce/features/products/domain/repository/products_repository.dart';
import 'package:flutter_ecommerce/shared/models.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;
  final ProductsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<DomainResult<PaginatedResponse<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? search,
    String? sort,
    double? minPrice,
    double? maxPrice,
    String? brand,
    bool? inStock,
  }) async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getProducts(
        page: page,
        limit: limit,
        categoryId: categoryId,
        search: search,
        sort: sort,
        minPrice: minPrice,
        maxPrice: maxPrice,
        brand: brand,
        inStock: inStock,
      );
      if (result.isSuccess && page == 1) {
        await localDataSource.cacheProducts('products_page_1', result.data!);
      }
      return result;
    } else {
      final cached = await localDataSource.getCachedProducts('products_page_1');
      if (cached.isSuccess && cached.data != null) {
        return DomainSuccess(cached.data! as PaginatedResponse<Product>);
      }
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<Product>> getProduct(String id) async {
    final cacheKey = 'product_$id';
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getProduct(id);
      if (result.isSuccess) {
        await localDataSource.cacheProduct(cacheKey, result.data!);
      }
      return result;
    } else {
      final cached = await localDataSource.getCachedProduct(cacheKey);
      if (cached.isSuccess && cached.data != null) {
        return DomainSuccess(cached.data!);
      }
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<List<Product>>> getFeaturedProducts({int limit = 10}) async {
    const cacheKey = 'featured_products';
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getFeaturedProducts(limit: limit);
      if (result.isSuccess) {
        await localDataSource.cacheProductsList(cacheKey, result.data!);
      }
      return result;
    } else {
      final cached = await localDataSource.getCachedProductsList(cacheKey);
      if (cached.isSuccess && cached.data != null) {
        return DomainSuccess(cached.data!);
      }
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<List<Product>>> getNewArrivals({int limit = 10}) async {
    const cacheKey = 'new_arrivals';
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getNewArrivals(limit: limit);
      if (result.isSuccess) {
        await localDataSource.cacheProductsList(cacheKey, result.data!);
      }
      return result;
    } else {
      final cached = await localDataSource.getCachedProductsList(cacheKey);
      if (cached.isSuccess && cached.data != null) {
        return DomainSuccess(cached.data!);
      }
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<List<Product>>> getBestSellers({int limit = 10}) async {
    const cacheKey = 'best_sellers';
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getBestSellers(limit: limit);
      if (result.isSuccess) {
        await localDataSource.cacheProductsList(cacheKey, result.data!);
      }
      return result;
    } else {
      final cached = await localDataSource.getCachedProductsList(cacheKey);
      if (cached.isSuccess && cached.data != null) {
        return DomainSuccess(cached.data!);
      }
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<List<Product>>> getRelatedProducts(String id, {int limit = 8}) async {
    final cacheKey = 'related_${id}_$limit';
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getRelatedProducts(id, limit: limit);
      if (result.isSuccess) {
        await localDataSource.cacheProductsList(cacheKey, result.data!);
      }
      return result;
    } else {
      final cached = await localDataSource.getCachedProductsList(cacheKey);
      if (cached.isSuccess && cached.data != null) {
        return DomainSuccess(cached.data!);
      }
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<PaginatedResponse<Review>>> getProductReviews(
    String id, {
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.getProductReviews(id, page: page, limit: limit);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<Review>> addReview(String id, CreateReviewRequest request) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.addReview(id, request);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }
}