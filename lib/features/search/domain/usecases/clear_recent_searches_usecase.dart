// Search Domain - Clear Recent Searches Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/features/search/domain.dart';

class ClearRecentSearchesUseCase extends NoParamsUseCase<void> {
  final SearchRepository repository;

  const ClearRecentSearchesUseCase(this.repository);

  @override
  Future<DomainResult<void>> call() {
    return repository.clearRecentSearches();
  }
}