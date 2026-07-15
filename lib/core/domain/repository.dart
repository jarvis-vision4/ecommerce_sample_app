// Core Domain - Base Repository Interface
import 'package:flutter_ecommerce/core/domain/result.dart';

abstract class BaseRepository {
  // Base repository - can be extended for common functionality
  // All feature repositories should implement this or extend it
}

abstract class CacheRepository<T> {
  Future<DomainResult<void>> cache(T data, String key);
  Future<DomainResult<T?>> getCached(String key);
  Future<DomainResult<void>> clearCache(String key);
  Future<DomainResult<void>> clearAllCache();
}

abstract class RemoteRepository<T> {
  Future<DomainResult<T>> fetchRemote(/* params */);
  Future<DomainResult<void>> sendRemote(/* params */);
}