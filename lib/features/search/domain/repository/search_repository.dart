// Search Domain - Repository Interface
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';

abstract class SearchRepository {
  Future<DomainResult<SearchResults>> search({
    required String query,
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? sort,
    double? minPrice,
    double? maxPrice,
  });
  Future<DomainResult<List<String>>> getSearchSuggestions(String query);
  Future<DomainResult<List<String>>> getPopularSearches();
  Future<DomainResult<void>> saveRecentSearch(String query);
  Future<DomainResult<List<String>>> getRecentSearches();
  Future<DomainResult<void>> clearRecentSearches();
}