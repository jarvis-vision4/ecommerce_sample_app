// Search Data - Repository Implementation
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/errors/failures.dart';
import 'package:flutter_ecommerce/core/network/network_info.dart';
import 'package:flutter_ecommerce/features/search/data/datasources/search_local_datasource.dart';
import 'package:flutter_ecommerce/features/search/data/datasources/search_remote_datasource.dart';
import 'package:flutter_ecommerce/features/search/domain/repository/search_repository.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<DomainResult<SearchResults>> search({
    required String query,
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? sort,
    double? minPrice,
    double? maxPrice,
  }) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.search(
        query: query,
        page: page,
        limit: limit,
        categoryId: categoryId,
        sort: sort,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<List<String>>> getSearchSuggestions(String query) async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.getSearchSuggestions(query);
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<List<String>>> getPopularSearches() async {
    if (await networkInfo.isConnected) {
      return remoteDataSource.getPopularSearches();
    } else {
      return DomainFailure(NetworkFailure.noConnection());
    }
  }

  @override
  Future<DomainResult<void>> saveRecentSearch(String query) {
    return localDataSource.saveRecentSearch(query);
  }

  @override
  Future<DomainResult<List<String>>> getRecentSearches() {
    return localDataSource.getRecentSearches();
  }

  @override
  Future<DomainResult<void>> clearRecentSearches() {
    return localDataSource.clearRecentSearches();
  }
}