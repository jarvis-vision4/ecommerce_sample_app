// Search Domain - Search Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/shared/models/models.dart';
import 'package:flutter_ecommerce/features/search/domain.dart';

class SearchUseCase extends UseCase<SearchResults, SearchParams> {
  final SearchRepository repository;

  const SearchUseCase(this.repository);

  @override
  Future<DomainResult<SearchResults>> call(SearchParams params) {
    return repository.search(
      query: params.query,
      page: params.page,
      limit: params.limit,
      categoryId: params.categoryId,
      sort: params.sort,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
    );
  }
}

class SearchParams {
  final String query;
  final int page;
  final int limit;
  final String? categoryId;
  final String? sort;
  final double? minPrice;
  final double? maxPrice;

  const SearchParams({
    required this.query,
    this.page = 1,
    this.limit = 20,
    this.categoryId,
    this.sort,
    this.minPrice,
    this.maxPrice,
  });
}