// Search Domain - Get Search Suggestions Use Case
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/features/search/domain.dart';

class GetSearchSuggestionsUseCase extends UseCase<List<String>, GetSearchSuggestionsParams> {
  final SearchRepository repository;

  const GetSearchSuggestionsUseCase(this.repository);

  @override
  Future<DomainResult<List<String>>> call(GetSearchSuggestionsParams params) {
    return repository.getSearchSuggestions(params.query);
  }
}

class GetSearchSuggestionsParams {
  final String query;
  const GetSearchSuggestionsParams({required this.query});
}