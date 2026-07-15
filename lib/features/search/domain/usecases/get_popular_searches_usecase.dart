// Search Domain - Get Popular Searches Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/features/search/domain.dart';

class GetPopularSearchesUseCase extends NoParamsUseCase<List<String>> {
  final SearchRepository repository;

  const GetPopularSearchesUseCase(this.repository);

  @override
  Future<DomainResult<List<String>>> call() {
    return repository.getPopularSearches();
  }
}