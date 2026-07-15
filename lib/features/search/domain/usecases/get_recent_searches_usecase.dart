// Search Domain - Get Recent Searches Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/features/search/domain.dart';

class GetRecentSearchesUseCase extends NoParamsUseCase<List<String>> {
  final SearchRepository repository;

  const GetRecentSearchesUseCase(this.repository);

  @override
  Future<DomainResult<List<String>>> call() {
    return repository.getRecentSearches();
  }
}