// API Client - Manual Dio wrapper for REST API calls
import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../errors/failures.dart';
import '../../shared/models/models.dart';

/// Base API client using Dio directly
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  /// Create API client with default configuration
  factory ApiClient.create() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConfig.current.fullApiUrl,
      connectTimeout: Duration(milliseconds: AppConfig.current.connectTimeout),
      receiveTimeout: Duration(milliseconds: AppConfig.current.receiveTimeout),
      sendTimeout: Duration(milliseconds: AppConfig.current.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) => status != null && status < 500,
    ));

    return ApiClient(dio);
  }

  // Helper methods for common patterns

  Future<Result<T>> _safeCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Success<T>(result);
    } on DioException catch (e) {
      return ApiFailure<T>(_mapError(e));
    } catch (e, s) {
      return ApiFailure<T>(UnknownFailure.fromError(e, s));
    }
  }

  Failure _mapError(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerFailure.fromDioError(err);
      case DioExceptionType.connectionError:
        return NetworkFailure.noConnection();
      case DioExceptionType.badResponse:
        return ServerFailure.fromDioError(err);
      case DioExceptionType.cancel:
        return const UnknownFailure(
          message: 'Request cancelled',
          code: 'REQUEST_CANCELLED',
        );
      case DioExceptionType.badCertificate:
        return const UnknownFailure(
          message: 'SSL Certificate error',
          code: 'BAD_CERTIFICATE',
        );
      case DioExceptionType.unknown:
        if (err.message?.contains('SocketException') == true) {
          return NetworkFailure.noConnection();
        }
        return UnknownFailure.fromError(err);
      default:
        return UnknownFailure.fromError(err);
    }
  }

  // ==================== AUTH ====================
  
  Future<Result<AuthResponse>> login(LoginRequest request) async {
    return _safeCall(() async {
      final response = await _dio.post('/auth/login', data: request.toJson());
      return AuthResponse.fromJson(response.data);
    });
  }

  Future<Result<AuthResponse>> register(RegisterRequest request) async {
    return _safeCall(() async {
      final response = await _dio.post('/auth/register', data: request.toJson());
      return AuthResponse.fromJson(response.data);
    });
  }

  Future<Result<TokenResponse>> refreshToken(RefreshTokenRequest request) async {
    return _safeCall(() async {
      final response = await _dio.post('/auth/refresh', data: request.toJson());
      return TokenResponse.fromJson(response.data);
    });
  }

  Future<Result<void>> logout() async {
    return _safeCall(() async {
      await _dio.post('/auth/logout');
    });
  }

  Future<Result<void>> forgotPassword(ForgotPasswordRequest request) async {
    return _safeCall(() async {
      await _dio.post('/auth/forgot-password', data: request.toJson());
    });
  }

  Future<Result<void>> resetPassword(ResetPasswordRequest request) async {
    return _safeCall(() async {
      await _dio.post('/auth/reset-password', data: request.toJson());
    });
  }

  Future<Result<void>> verifyEmail(VerifyEmailRequest request) async {
    return _safeCall(() async {
      await _dio.post('/auth/verify-email', data: request.toJson());
    });
  }

  Future<Result<UserProfile>> getCurrentUser() async {
    return _safeCall(() async {
      final response = await _dio.get('/auth/me');
      return UserProfile.fromJson(response.data);
    });
  }

  Future<Result<UserProfile>> updateProfile(UpdateProfileRequest request) async {
    return _safeCall(() async {
      final response = await _dio.patch('/auth/me', data: request.toJson());
      return UserProfile.fromJson(response.data);
    });
  }

  Future<Result<void>> changePassword(ChangePasswordRequest request) async {
    return _safeCall(() async {
      await _dio.post('/auth/change-password', data: request.toJson());
    });
  }

  // ==================== PRODUCTS ====================
  
  Future<Result<PaginatedResponse<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? search,
    String? sort,
    double? minPrice,
    double? maxPrice,
    String? brand,
    bool? inStock,
  }) async {
    return _safeCall(() async {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (categoryId != null) 'category_id': categoryId,
        if (search != null) 'search': search,
        if (sort != null) 'sort': sort,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (brand != null) 'brand': brand,
        if (inStock != null) 'in_stock': inStock,
      };
      
      final response = await _dio.get('/products', queryParameters: queryParams);
      return PaginatedResponse<Product>.fromJson(
        response.data,
        (json) => Product.fromJson(json),
      );
    });
  }

  Future<Result<Product>> getProduct(String id) async {
    return _safeCall(() async {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    });
  }

  Future<Result<List<Product>>> getFeaturedProducts({int limit = 10}) async {
    return _safeCall(() async {
      final response = await _dio.get('/products/featured', queryParameters: {'limit': limit});
      return (response.data as List).map((e) => Product.fromJson(e)).toList();
    });
  }

  Future<Result<List<Product>>> getNewArrivals({int limit = 10}) async {
    return _safeCall(() async {
      final response = await _dio.get('/products/new-arrivals', queryParameters: {'limit': limit});
      return (response.data as List).map((e) => Product.fromJson(e)).toList();
    });
  }

  Future<Result<List<Product>>> getBestSellers({int limit = 10}) async {
    return _safeCall(() async {
      final response = await _dio.get('/products/best-sellers', queryParameters: {'limit': limit});
      return (response.data as List).map((e) => Product.fromJson(e)).toList();
    });
  }

  Future<Result<List<Product>>> getRelatedProducts(String id, {int limit = 8}) async {
    return _safeCall(() async {
      final response = await _dio.get('/products/$id/related', queryParameters: {'limit': limit});
      return (response.data as List).map((e) => Product.fromJson(e)).toList();
    });
  }

  Future<Result<PaginatedResponse<Review>>> getProductReviews(
    String id, {
    int page = 1,
    int limit = 10,
  }) async {
    return _safeCall(() async {
      final response = await _dio.get('/products/$id/reviews', queryParameters: {
        'page': page,
        'limit': limit,
      });
      return PaginatedResponse<Review>.fromJson(
        response.data,
        (json) => Review.fromJson(json),
      );
    });
  }

  Future<Result<Review>> addReview(String id, CreateReviewRequest request) async {
    return _safeCall(() async {
      final response = await _dio.post('/products/$id/reviews', data: request.toJson());
      return Review.fromJson(response.data);
    });
  }

  // ==================== CATEGORIES ====================
  
  Future<Result<List<Category>>> getCategories({
    String? parentId,
    bool includeProductsCount = false,
  }) async {
    return _safeCall(() async {
      final response = await _dio.get('/categories', queryParameters: {
        if (parentId != null) 'parent_id': parentId,
        'include_products_count': includeProductsCount,
      });
      return (response.data as List).map((e) => Category.fromJson(e)).toList();
    });
  }

  Future<Result<Category>> getCategory(String id) async {
    return _safeCall(() async {
      final response = await _dio.get('/categories/$id');
      return Category.fromJson(response.data);
    });
  }

  Future<Result<List<Category>>> getChildCategories(String id) async {
    return _safeCall(() async {
      final response = await _dio.get('/categories/$id/children');
      return (response.data as List).map((e) => Category.fromJson(e)).toList();
    });
  }

  // ==================== CART ====================
  
  Future<Result<Cart>> getCart() async {
    return _safeCall(() async {
      final response = await _dio.get('/cart');
      return Cart.fromJson(response.data);
    });
  }

  Future<Result<CartItem>> addToCart(AddToCartRequest request) async {
    return _safeCall(() async {
      final response = await _dio.post('/cart/items', data: request.toJson());
      return CartItem.fromJson(response.data);
    });
  }

  Future<Result<CartItem>> updateCartItem(String itemId, UpdateCartItemRequest request) async {
    return _safeCall(() async {
      final response = await _dio.patch('/cart/items/$itemId', data: request.toJson());
      return CartItem.fromJson(response.data);
    });
  }

  Future<Result<void>> removeFromCart(String itemId) async {
    return _safeCall(() async {
      await _dio.delete('/cart/items/$itemId');
    });
  }

  Future<Result<void>> clearCart() async {
    return _safeCall(() async {
      await _dio.delete('/cart');
    });
  }

  Future<Result<Cart>> applyCoupon(ApplyCouponRequest request) async {
    return _safeCall(() async {
      final response = await _dio.post('/cart/apply-coupon', data: request.toJson());
      return Cart.fromJson(response.data);
    });
  }

  Future<Result<Cart>> removeCoupon() async {
    return _safeCall(() async {
      final response = await _dio.delete('/cart/coupon');
      return Cart.fromJson(response.data);
    });
  }

  // ==================== CHECKOUT / ORDERS ====================
  
  Future<Result<CheckoutValidation>> validateCheckout(CheckoutRequest request) async {
    return _safeCall(() async {
      final response = await _dio.post('/checkout/validate', data: request.toJson());
      return CheckoutValidation.fromJson(response.data);
    });
  }

  Future<Result<Order>> createOrder(CreateOrderRequest request) async {
    return _safeCall(() async {
      final response = await _dio.post('/orders', data: request.toJson());
      return Order.fromJson(response.data);
    });
  }

  Future<Result<PaginatedResponse<Order>>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    return _safeCall(() async {
      final response = await _dio.get('/orders', queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
      });
      return PaginatedResponse<Order>.fromJson(
        response.data,
        (json) => Order.fromJson(json),
      );
    });
  }

  Future<Result<Order>> getOrder(String id) async {
    return _safeCall(() async {
      final response = await _dio.get('/orders/$id');
      return Order.fromJson(response.data);
    });
  }

  Future<Result<Order>> cancelOrder(String id) async {
    return _safeCall(() async {
      final response = await _dio.post('/orders/$id/cancel');
      return Order.fromJson(response.data);
    });
  }

  Future<Result<Order>> reorder(String id) async {
    return _safeCall(() async {
      final response = await _dio.post('/orders/$id/reorder');
      return Order.fromJson(response.data);
    });
  }

  Future<Result<OrderTracking>> getOrderTracking(String id) async {
    return _safeCall(() async {
      final response = await _dio.get('/orders/$id/tracking');
      return OrderTracking.fromJson(response.data);
    });
  }

  Future<Result<ReturnRequest>> requestReturn(String id, CreateReturnRequest request) async {
    return _safeCall(() async {
      final response = await _dio.post('/orders/$id/return', data: request.toJson());
      return ReturnRequest.fromJson(response.data);
    });
  }

  // ==================== PAYMENTS ====================
  
  Future<Result<PaymentIntent>> createPaymentIntent(CreatePaymentIntentRequest request) async {
    return _safeCall(() async {
      final response = await _dio.post('/payments/intent', data: request.toJson());
      return PaymentIntent.fromJson(response.data);
    });
  }

  Future<Result<PaymentConfirmation>> confirmPayment(ConfirmPaymentRequest request) async {
    return _safeCall(() async {
      final response = await _dio.post('/payments/confirm', data: request.toJson());
      return PaymentConfirmation.fromJson(response.data);
    });
  }

  Future<Result<List<PaymentMethod>>> getPaymentMethods() async {
    return _safeCall(() async {
      final response = await _dio.get('/payments/methods');
      return (response.data as List).map((e) => PaymentMethod.fromJson(e)).toList();
    });
  }

  Future<Result<PaymentMethod>> addPaymentMethod(AddPaymentMethodRequest request) async {
    return _safeCall(() async {
      final response = await _dio.post('/payments/methods', data: request.toJson());
      return PaymentMethod.fromJson(response.data);
    });
  }

  Future<Result<void>> removePaymentMethod(String id) async {
    return _safeCall(() async {
      await _dio.delete('/payments/methods/$id');
    });
  }

  Future<Result<PaymentMethod>> setDefaultPaymentMethod(String id) async {
    return _safeCall(() async {
      final response = await _dio.patch('/payments/methods/$id/default');
      return PaymentMethod.fromJson(response.data);
    });
  }

  // ==================== ADDRESSES ====================
  
  Future<Result<List<Address>>> getAddresses() async {
    return _safeCall(() async {
      final response = await _dio.get('/addresses');
      return (response.data as List).map((e) => Address.fromJson(e)).toList();
    });
  }

  Future<Result<Address>> getAddress(String id) async {
    return _safeCall(() async {
      final response = await _dio.get('/addresses/$id');
      return Address.fromJson(response.data);
    });
  }

  Future<Result<Address>> createAddress(CreateAddressRequest request) async {
    return _safeCall(() async {
      final response = await _dio.post('/addresses', data: request.toJson());
      return Address.fromJson(response.data);
    });
  }

  Future<Result<Address>> updateAddress(String id, UpdateAddressRequest request) async {
    return _safeCall(() async {
      final response = await _dio.patch('/addresses/$id', data: request.toJson());
      return Address.fromJson(response.data);
    });
  }

  Future<Result<void>> deleteAddress(String id) async {
    return _safeCall(() async {
      await _dio.delete('/addresses/$id');
    });
  }

  Future<Result<Address>> setDefaultAddress(String id) async {
    return _safeCall(() async {
      final response = await _dio.patch('/addresses/$id/default');
      return Address.fromJson(response.data);
    });
  }

  // ==================== WISHLIST ====================
  
  Future<Result<Wishlist>> getWishlist() async {
    return _safeCall(() async {
      final response = await _dio.get('/wishlist');
      return Wishlist.fromJson(response.data);
    });
  }

  Future<Result<WishlistItem>> addToWishlist(AddToWishlistRequest request) async {
    return _safeCall(() async {
      final response = await _dio.post('/wishlist/items', data: request.toJson());
      return WishlistItem.fromJson(response.data);
    });
  }

  Future<Result<void>> removeFromWishlist(String productId) async {
    return _safeCall(() async {
      await _dio.delete('/wishlist/items/$productId');
    });
  }

  Future<Result<void>> clearWishlist() async {
    return _safeCall(() async {
      await _dio.delete('/wishlist');
    });
  }

  // ==================== SEARCH ====================
  
  Future<Result<SearchResults>> search({
    required String query,
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? sort,
    double? minPrice,
    double? maxPrice,
  }) async {
    return _safeCall(() async {
      final response = await _dio.get('/search', queryParameters: {
        'q': query,
        'page': page,
        'limit': limit,
        if (categoryId != null) 'category_id': categoryId,
        if (sort != null) 'sort': sort,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
      });
      return SearchResults.fromJson(response.data);
    });
  }

  Future<Result<List<String>>> getSearchSuggestions(String query) async {
    return _safeCall(() async {
      final response = await _dio.get('/search/suggestions', queryParameters: {'q': query});
      return (response.data as List).map((e) => e.toString()).toList();
    });
  }

  Future<Result<List<String>>> getPopularSearches() async {
    return _safeCall(() async {
      final response = await _dio.get('/search/popular');
      return (response.data as List).map((e) => e.toString()).toList();
    });
  }

  // ==================== NOTIFICATIONS ====================
  
  Future<Result<PaginatedResponse<AppNotification>>> getNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    return _safeCall(() async {
      final response = await _dio.get('/notifications', queryParameters: {
        'page': page,
        'limit': limit,
        'unread_only': unreadOnly,
      });
      return PaginatedResponse<AppNotification>.fromJson(
        response.data,
        (json) => AppNotification.fromJson(json),
      );
    });
  }

  Future<Result<void>> markNotificationRead(String id) async {
    return _safeCall(() async {
      await _dio.patch('/notifications/$id/read');
    });
  }

  Future<Result<void>> markAllNotificationsRead() async {
    return _safeCall(() async {
      await _dio.patch('/notifications/read-all');
    });
  }

  Future<Result<void>> deleteNotification(String id) async {
    return _safeCall(() async {
      await _dio.delete('/notifications/$id');
    });
  }

  // ==================== SETTINGS ====================
  
  Future<Result<AppSettings>> getAppSettings() async {
    return _safeCall(() async {
      final response = await _dio.get('/settings/app');
      return AppSettings.fromJson(response.data);
    });
  }

  Future<Result<List<ShippingOption>>> getShippingOptions() async {
    return _safeCall(() async {
      final response = await _dio.get('/settings/shipping');
      return (response.data as List).map((e) => ShippingOption.fromJson(e)).toList();
    });
  }

  Future<Result<List<AppCurrency>>> getSupportedCurrencies() async {
    return _safeCall(() async {
      final response = await _dio.get('/settings/currencies');
      return (response.data as List).map((e) => AppCurrency.fromJson(e)).toList();
    });
  }

  Future<Result<List<AvailablePaymentMethod>>> getAvailablePaymentMethods() async {
    return _safeCall(() async {
      final response = await _dio.get('/settings/payment-methods');
      return (response.data as List).map((e) => AvailablePaymentMethod.fromJson(e)).toList();
    });
  }
}

/// Result wrapper for API calls
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ApiFailure<T>;

  T? get data => this is Success<T> ? (this as Success<T>).data : null;
  Failure? get error => this is ApiFailure<T> ? (this as ApiFailure<T>).error : null;

  T getOrElse(T defaultValue) => isSuccess ? (this as Success<T>).data : defaultValue;
  T getOrThrow() => isSuccess ? (this as Success<T>).data : throw (this as ApiFailure<T>).error;
}

class Success<T> extends Result<T> {
  @override
  final T data;
  const Success(this.data);
}

class ApiFailure<T> extends Result<T> {
  @override
  final Failure error;
  const ApiFailure(this.error);
}

/// Extension for easier Result handling
extension ResultX<T> on Result<T> {
  Future<Result<U>> asyncMap<U>(Future<U> Function(T) fn) async {
    if (this is Success<T>) {
      try {
        return Success(await fn((this as Success<T>).data));
      } catch (e, s) {
        return ApiFailure(UnknownFailure.fromError(e, s));
      }
    }
    return this as Result<U>;
  }

  Result<U> map<U>(U Function(T) fn) {
    if (this is Success<T>) {
      return Success(fn((this as Success<T>).data));
    }
    return this as Result<U>;
  }

  void onSuccess(void Function(T) fn) {
    if (this is Success<T>) fn((this as Success<T>).data);
  }

  void onFailure(void Function(Failure) fn) {
    if (this is ApiFailure<T>) fn((this as ApiFailure<T>).error);
  }
}