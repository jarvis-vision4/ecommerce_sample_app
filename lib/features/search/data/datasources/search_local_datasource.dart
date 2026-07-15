// Search Data - Local Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/storage/hive_storage.dart';


abstract class SearchLocalDataSource {
  Future<DomainResult<void>> saveRecentSearch(String query);
  Future<DomainResult<List<String>>> getRecentSearches();
  Future<DomainResult<void>> clearRecentSearches();
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final HiveStorage hiveStorage;

  SearchLocalDataSourceImpl(this.hiveStorage);

  @override
  Future<DomainResult<void>> saveRecentSearch(String query) {
    return DomainResult.safeCall(() async {
      await hiveStorage.addSearchHistory(query);
    });
  }

  @override
  Future<DomainResult<List<String>>> getRecentSearches() {
    return DomainResult.safeCall(() async {
      return hiveStorage.getSearchHistory();
    });
  }

  @override
  Future<DomainResult<void>> clearRecentSearches() {
    return DomainResult.safeCall(() async {
      await hiveStorage.clearSearchHistory();
    });
  }
}