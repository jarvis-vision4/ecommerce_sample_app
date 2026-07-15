// Wishlist Data - Remote Data Source
import 'package:flutter_ecommerce/core/domain.dart';
import 'package:flutter_ecommerce/core/network/api_client.dart' hide Result;
import 'package:flutter_ecommerce/shared/models.dart';

class WishlistRemoteDataSource {
  final ApiClient apiClient;

  WishlistRemoteDataSource(this.apiClient);

  Future<DomainResult<Wishlist>> getWishlist() async {
    final result = await apiClient.getWishlist();
    return _convertResult(result);
  }

  Future<DomainResult<WishlistItem>> addItem(AddToWishlistRequest request) async {
    final result = await apiClient.addToWishlist(request);
    return _convertResult(result);
  }

  Future<DomainResult<void>> removeItem(String productId) async {
    final result = await apiClient.removeFromWishlist(productId);
    return _convertResult(result);
  }

  Future<DomainResult<void>> clearWishlist() async {
    final result = await apiClient.clearWishlist();
    return _convertResult(result);
  }

  DomainResult<T> _convertResult<T>(dynamic apiResult) {
    if (apiResult is Success) {
      return DomainSuccess(apiResult.data as T);
    } else if (apiResult is ApiFailure) {
      return DomainFailure(apiResult.error);
    }
    return DomainFailure(Exception('Unknown result type'));
  }
}