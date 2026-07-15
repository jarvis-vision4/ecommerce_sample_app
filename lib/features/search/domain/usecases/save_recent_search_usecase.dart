// Search Domain - Save Recent Search Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/features/search/domain.dart';

class SaveRecentSearchUseCase extends UseCase<void, SaveRecentSearchParams> {
  final SearchRepository repository;

  const SaveRecentSearchUseCase(this.repository);

  @override
  Future<DomainResult<void>> call(SaveRecentSearchParams params) {
    return repository.saveRecentSearch(params.query);
  }
}

class SaveRecentSearchParams {
  final String query;
  const SaveRecentSearchParams({required this.query});
}