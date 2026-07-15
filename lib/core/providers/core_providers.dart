// Riverpod Providers - Core providers for DI, Network, Storage, etc.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/app_config.dart';
import '../network/dio_client.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../storage/secure_storage.dart';
import '../storage/preferences_storage.dart';
import '../storage/hive_storage.dart';
import '../errors/failures.dart';
import '../../shared/models/models.dart';

// ==================== Config Providers ====================

final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.current);

final featureFlagsProvider = Provider<FeatureFlags>((ref) => const FeatureFlags());

final appConstantsProvider = Provider<AppConstants>((ref) => const AppConstants());

// ==================== Network Providers ====================

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  
  final dio = Dio(BaseOptions(
    baseUrl: config.fullApiUrl,
    connectTimeout: Duration(milliseconds: config.connectTimeout),
    receiveTimeout: Duration(milliseconds: config.receiveTimeout),
    sendTimeout: Duration(milliseconds: config.sendTimeout),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    validateStatus: (status) => status != null && status < 500,
  ));

  // Auth Interceptor
  dio.interceptors.add(AuthInterceptor(secureStorage));

  // Logging Interceptor
  if (config.enableLogging) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: false,
      maxWidth: 120,
    ));
  }

  // Error Handling
  dio.interceptors.add(ErrorHandlingInterceptor());

  // Retry
  dio.interceptors.add(RetryInterceptor());

  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});

// ==================== Storage Providers ====================

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage.create();
});

final preferencesStorageProvider = Provider<PreferencesStorage>((ref) {
  return PreferencesStorage();
});

final hiveStorageProvider = Provider<HiveStorage>((ref) {
  return HiveStorage();
});

// ==================== Hive Boxes Providers ====================

final productsBoxProvider = Provider<Box>((ref) {
  final storage = ref.watch(hiveStorageProvider);
  return storage.productsBox;
});

final categoriesBoxProvider = Provider<Box>((ref) {
  final storage = ref.watch(hiveStorageProvider);
  return storage.categoriesBox;
});

final cartBoxProvider = Provider<Box>((ref) {
  final storage = ref.watch(hiveStorageProvider);
  return storage.cartBox;
});

final wishlistBoxProvider = Provider<Box>((ref) {
  final storage = ref.watch(hiveStorageProvider);
  return storage.wishlistBox;
});

final ordersBoxProvider = Provider<Box>((ref) {
  final storage = ref.watch(hiveStorageProvider);
  return storage.ordersBox;
});

final addressesBoxProvider = Provider<Box>((ref) {
  final storage = ref.watch(hiveStorageProvider);
  return storage.addressesBox;
});

// ==================== Connectivity ====================

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfo(ref.watch(connectivityProvider));
});

// ==================== Auth State Providers ====================

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    apiClient: ref.watch(apiClientProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

final currentUserProvider = Provider<UserProfile?>((ref) {
  return ref.watch(authStateProvider).user;
});

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

final authTokenProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).accessToken;
});

// ==================== Cart State ====================

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(
    apiClient: ref.watch(apiClientProvider),
    hiveStorage: ref.watch(hiveStorageProvider),
  );
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).total;
});

// ==================== Wishlist State ====================

final wishlistProvider = StateNotifierProvider<WishlistNotifier, WishlistState>((ref) {
  return WishlistNotifier(
    apiClient: ref.watch(apiClientProvider),
    hiveStorage: ref.watch(hiveStorageProvider),
  );
});

final wishlistCountProvider = Provider<int>((ref) {
  return ref.watch(wishlistProvider).count;
});

// ==================== Product State ====================

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier(
    apiClient: ref.watch(apiClientProvider),
    hiveStorage: ref.watch(hiveStorageProvider),
  );
});

final categoriesProvider = StateNotifierProvider<CategoriesNotifier, CategoriesState>((ref) {
  return CategoriesNotifier(
    apiClient: ref.watch(apiClientProvider),
    hiveStorage: ref.watch(hiveStorageProvider),
  );
});

final featuredProductsProvider = FutureProvider<List<Product>>((ref) {
  final api = ref.watch(apiClientProvider);
  return api.getFeaturedProducts().then((r) => r.data!);
});

final newArrivalsProvider = FutureProvider<List<Product>>((ref) {
  final api = ref.watch(apiClientProvider);
  return api.getNewArrivals().then((r) => r.data!);
});

final bestSellersProvider = FutureProvider<List<Product>>((ref) {
  final api = ref.watch(apiClientProvider);
  return api.getBestSellers().then((r) => r.data!);
});

// ==================== Search State ====================

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(
    apiClient: ref.watch(apiClientProvider),
    preferencesStorage: ref.watch(preferencesStorageProvider),
  );
});

// ==================== Order State ====================

final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  return OrdersNotifier(
    apiClient: ref.watch(apiClientProvider),
    hiveStorage: ref.watch(hiveStorageProvider),
  );
});

// ==================== Address State ====================

final addressesProvider = StateNotifierProvider<AddressesNotifier, AddressesState>((ref) {
  return AddressesNotifier(
    apiClient: ref.watch(apiClientProvider),
    hiveStorage: ref.watch(hiveStorageProvider),
  );
});

// ==================== Payment Methods ====================

final paymentMethodsProvider = StateNotifierProvider<PaymentMethodsNotifier, PaymentMethodsState>((ref) {
  return PaymentMethodsNotifier(
    apiClient: ref.watch(apiClientProvider),
  );
});

// ==================== Notifications ====================

final pushNotificationsProvider = StateNotifierProvider<PushNotificationsNotifier, bool>((ref) {
  return PushNotificationsNotifier(
    preferencesStorage: ref.watch(preferencesStorageProvider),
  );
});

final emailNotificationsProvider = StateNotifierProvider<EmailNotificationsNotifier, bool>((ref) {
  return EmailNotificationsNotifier(
    preferencesStorage: ref.watch(preferencesStorageProvider),
  );
});

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier(
    apiClient: ref.watch(apiClientProvider),
  );
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).unreadCount;
});

// ==================== Analytics ====================

final analyticsConsentProvider = StateNotifierProvider<AnalyticsConsentNotifier, bool>((ref) {
  return AnalyticsConsentNotifier(
    preferencesStorage: ref.watch(preferencesStorageProvider),
  );
});

// ==================== Theme ====================

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(
    preferencesStorage: ref.watch(preferencesStorageProvider),
  );
});

// ==================== Language ====================

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier(
    preferencesStorage: ref.watch(preferencesStorageProvider),
  );
});

// ==================== Currency ====================

final currencyProvider = StateNotifierProvider<CurrencyNotifier, String>((ref) {
  return CurrencyNotifier(
    preferencesStorage: ref.watch(preferencesStorageProvider),
  );
});

// ==================== Placeholder State Classes ====================
// These will be implemented in their respective feature files

class AuthState {
  final UserProfile? user;
  final String? accessToken;
  final String? refreshToken;
  final bool isAuthenticated;
  final bool isLoading;
  final Failure? error;

  AuthState({
    this.user,
    this.accessToken,
    this.refreshToken,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserProfile? user,
    String? accessToken,
    String? refreshToken,
    bool? isAuthenticated,
    bool? isLoading,
    Failure? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CartState {
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double shipping;
  final double discount;
  final double total;
  final String currency;
  final Coupon? appliedCoupon;
  final bool isLoading;
  final Failure? error;

  CartState({
    this.items = const [],
    this.subtotal = 0,
    this.tax = 0,
    this.shipping = 0,
    this.discount = 0,
    this.total = 0,
    this.currency = 'USD',
    this.appliedCoupon,
    this.isLoading = false,
    this.error,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? tax,
    double? shipping,
    double? discount,
    double? total,
    String? currency,
    Coupon? appliedCoupon,
    bool? isLoading,
    Failure? error,
  }) {
    return CartState(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      shipping: shipping ?? this.shipping,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      currency: currency ?? this.currency,
      appliedCoupon: appliedCoupon ?? this.appliedCoupon,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class WishlistState {
  final List<WishlistItem> items;
  final bool isLoading;
  final Failure? error;

  WishlistState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  int get count => items.length;
  bool get isEmpty => items.isEmpty;

  WishlistState copyWith({
    List<WishlistItem>? items,
    bool? isLoading,
    Failure? error,
  }) {
    return WishlistState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProductsState {
  final List<Product> products;
  final PaginationMeta? pagination;
  final bool isLoading;
  final bool isLoadingMore;
  final Failure? error;
  final String? currentSearch;
  final String? currentCategory;
  final String? currentSort;

  ProductsState({
    this.products = const [],
    this.pagination,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentSearch,
    this.currentCategory,
    this.currentSort,
  });

  ProductsState copyWith({
    List<Product>? products,
    PaginationMeta? pagination,
    bool? isLoading,
    bool? isLoadingMore,
    Failure? error,
    String? currentSearch,
    String? currentCategory,
    String? currentSort,
  }) {
    return ProductsState(
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentSearch: currentSearch ?? this.currentSearch,
      currentCategory: currentCategory ?? this.currentCategory,
      currentSort: currentSort ?? this.currentSort,
    );
  }
}

class CategoriesState {
  final List<Category> categories;
  final bool isLoading;
  final Failure? error;

  CategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  CategoriesState copyWith({
    List<Category>? categories,
    bool? isLoading,
    Failure? error,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SearchState {
  final List<Product> results;
  final List<Category> categories;
  final List<String> suggestions;
  final SearchFilters? filters;
  final PaginationMeta? pagination;
  final bool isLoading;
  final String? currentQuery;
  final Failure? error;
  final List<String> recentSearches;

  SearchState({
    this.results = const [],
    this.categories = const [],
    this.suggestions = const [],
    this.filters,
    this.pagination,
    this.isLoading = false,
    this.currentQuery,
    this.error,
    this.recentSearches = const [],
  });

  SearchState copyWith({
    List<Product>? results,
    List<Category>? categories,
    List<String>? suggestions,
    SearchFilters? filters,
    PaginationMeta? pagination,
    bool? isLoading,
    String? currentQuery,
    Failure? error,
    List<String>? recentSearches,
  }) {
    return SearchState(
      results: results ?? this.results,
      categories: categories ?? this.categories,
      suggestions: suggestions ?? this.suggestions,
      filters: filters ?? this.filters,
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
      currentQuery: currentQuery ?? this.currentQuery,
      error: error,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}

class OrdersState {
  final List<Order> orders;
  final PaginationMeta? pagination;
  final bool isLoading;
  final bool isLoadingMore;
  final Failure? error;

  OrdersState({
    this.orders = const [],
    this.pagination,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  OrdersState copyWith({
    List<Order>? orders,
    PaginationMeta? pagination,
    bool? isLoading,
    bool? isLoadingMore,
    Failure? error,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
    );
  }
}

class AddressesState {
  final List<Address> addresses;
  final bool isLoading;
  final Failure? error;

  AddressesState({
    this.addresses = const [],
    this.isLoading = false,
    this.error,
  });

  AddressesState copyWith({
    List<Address>? addresses,
    bool? isLoading,
    Failure? error,
  }) {
    return AddressesState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PaymentMethodsState {
  final List<PaymentMethod> methods;
  final bool isLoading;
  final Failure? error;

  PaymentMethodsState({
    this.methods = const [],
    this.isLoading = false,
    this.error,
  });

  PaymentMethodsState copyWith({
    List<PaymentMethod>? methods,
    bool? isLoading,
    Failure? error,
  }) {
    return PaymentMethodsState(
      methods: methods ?? this.methods,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NotificationsState {
  final List<AppNotification> notifications;
  final PaginationMeta? pagination;
  final bool isLoading;
  final Failure? error;

  NotificationsState({
    this.notifications = const [],
    this.pagination,
    this.isLoading = false,
    this.error,
  });

  int get unreadCount => notifications.where((n) => !n.read).length;

  NotificationsState copyWith({
    List<AppNotification>? notifications,
    PaginationMeta? pagination,
    bool? isLoading,
    Failure? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// ==================== Placeholder Notifiers ====================
// These will be fully implemented in feature files

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient apiClient;
  final SecureStorage secureStorage;

  AuthNotifier({required this.apiClient, required this.secureStorage})
      : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(
      user: UserProfile(
        id: 'user_1',
        email: email,
        firstName: 'John',
        lastName: 'Doe',
        emailVerified: true,
      ),
      accessToken: 'demo_access_token',
      refreshToken: 'demo_refresh_token',
      isAuthenticated: true,
      isLoading: false,
    );
  }

  Future<void> logout() async {
    await secureStorage.clearAuthTokens();
    state = AuthState();
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    final token = await secureStorage.getAccessToken();
    if (token != null) {
      state = state.copyWith(
        user: UserProfile(
          id: 'user_1',
          email: 'john@example.com',
          firstName: 'John',
          lastName: 'Doe',
          emailVerified: true,
        ),
        isAuthenticated: true,
        isLoading: false,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final ApiClient apiClient;
  final HiveStorage hiveStorage;

  CartNotifier({required this.apiClient, required this.hiveStorage})
      : super(CartState());

  Future<void> loadCart() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 300));
    final items = [
      CartItem(
        id: 'ci_1', productId: 'prod_1', name: 'Premium Wireless Headphones',
        price: 299.99, originalPrice: 399.99, quantity: 1,
        imageUrl: 'https://picsum.photos/seed/headphones/400/400', variantName: 'Black',
      ),
      CartItem(
        id: 'ci_2', productId: 'prod_2', name: 'Leather Messenger Bag',
        price: 149.99, quantity: 2,
        imageUrl: 'https://picsum.photos/seed/bag/400/400',
      ),
      CartItem(
        id: 'ci_3', productId: 'prod_3', name: 'Smart Watch Pro',
        price: 449.99, originalPrice: 549.99, quantity: 1,
        imageUrl: 'https://picsum.photos/seed/watch/400/400',
      ),
    ];
    final subtotal = items.fold(0.0, (sum, item) => sum + item.total);
    final tax = subtotal * 0.08;
    const shipping = 9.99;
    state = state.copyWith(
      items: items,
      subtotal: subtotal,
      tax: tax,
      shipping: shipping,
      total: subtotal + tax + shipping,
      isLoading: false,
    );
  }

  Future<void> addItem(AddToCartRequest request) async {
    final existingIndex = state.items.indexWhere((i) => i.productId == request.productId);
    if (existingIndex >= 0) {
      final items = [...state.items];
      items[existingIndex] = CartItem(
        id: items[existingIndex].id,
        productId: items[existingIndex].productId,
        name: items[existingIndex].name,
        price: items[existingIndex].price,
        quantity: items[existingIndex].quantity + request.quantity,
        imageUrl: items[existingIndex].imageUrl,
      );
      _recalculate(items);
    } else {
      final newItem = CartItem(
        id: 'ci_${DateTime.now().millisecondsSinceEpoch}',
        productId: request.productId,
        name: 'Product',
        price: 0,
        quantity: request.quantity,
      );
      _recalculate([...state.items, newItem]);
    }
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) { await removeItem(itemId); return; }
    final items = state.items.map((i) => i.id == itemId ? CartItem(id: i.id, productId: i.productId, name: i.name, price: i.price, quantity: quantity, imageUrl: i.imageUrl) : i).toList();
    _recalculate(items);
  }

  Future<void> removeItem(String itemId) async {
    _recalculate(state.items.where((i) => i.id != itemId).toList());
  }

  Future<void> clearCart() async {
    state = state.copyWith(items: [], subtotal: 0, tax: 0, shipping: 0, discount: 0, total: 0);
  }

  Future<void> applyCoupon(String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      appliedCoupon: Coupon(code: code, discountPercent: 10),
      discount: state.subtotal * 0.1,
      total: state.total - state.subtotal * 0.1,
    );
  }

  Future<void> removeCoupon() async {
    state = state.copyWith(
      appliedCoupon: null,
      discount: 0,
      total: state.subtotal + state.tax + state.shipping,
    );
  }

  void _recalculate(List<CartItem> items) {
    final subtotal = items.fold(0.0, (sum, item) => sum + item.total);
    final tax = subtotal * 0.08;
    const shipping = 9.99;
    final discount = state.appliedCoupon != null ? subtotal * (state.appliedCoupon!.discountPercent / 100) : 0.0;
    state = state.copyWith(
      items: items,
      subtotal: subtotal,
      tax: tax,
      shipping: shipping,
      discount: discount,
      total: subtotal + tax + shipping - discount,
    );
  }
}

class WishlistNotifier extends StateNotifier<WishlistState> {
  final ApiClient apiClient;
  final HiveStorage hiveStorage;

  WishlistNotifier({required this.apiClient, required this.hiveStorage})
      : super(WishlistState());

  Future<void> loadWishlist() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(
      items: [
        WishlistItem(id: 'wi_1', productId: 'prod_1', name: 'Premium Wireless Headphones', price: 299.99, originalPrice: 399.99),
        WishlistItem(id: 'wi_2', productId: 'prod_4', name: 'Minimalist Desk Lamp', price: 89.99),
        WishlistItem(id: 'wi_3', productId: 'prod_5', name: 'Running Shoes Ultra', price: 189.99, originalPrice: 239.99),
        WishlistItem(id: 'wi_4', productId: 'prod_6', name: 'Organic Skincare Set', price: 79.99),
      ],
      isLoading: false,
    );
  }

  Future<void> addItem(AddToWishlistRequest request) async {
    if (state.items.any((i) => i.productId == request.productId)) return;
    state = state.copyWith(
      items: [
        ...state.items,
        WishlistItem(id: 'wi_${DateTime.now().millisecondsSinceEpoch}', productId: request.productId, name: 'Product', price: 0),
      ],
    );
  }

  Future<void> removeItem(String productId) async {
    state = state.copyWith(items: state.items.where((i) => i.productId != productId).toList());
  }

  Future<void> clearWishlist() async {
    state = state.copyWith(items: []);
  }
}

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ApiClient apiClient;
  final HiveStorage hiveStorage;

  ProductsNotifier({required this.apiClient, required this.hiveStorage})
      : super(ProductsState());

  Future<void> loadProducts({
    int page = 1,
    String? categoryId,
    String? search,
    String? sort,
    double? minPrice,
    double? maxPrice,
    String? brand,
    bool? inStock,
  }) async {
    state = state.copyWith(isLoading: page == 1, isLoadingMore: page > 1);
    await Future.delayed(const Duration(milliseconds: 500));
    final mockProducts = _generateMockProducts(20, categoryId: categoryId, search: search);
    state = state.copyWith(
      products: mockProducts,
      pagination: PaginationMeta(
        currentPage: page,
        totalPages: 5,
        totalItems: mockProducts.length * 5,
        hasNextPage: page < 5,
      ),
      currentSearch: search,
      currentCategory: categoryId,
      currentSort: sort,
      isLoading: false,
      isLoadingMore: false,
    );
  }

  Future<void> refresh() async {
    await loadProducts();
  }

  List<Product> _generateMockProducts(int count, {String? categoryId, String? search}) {
    final names = [
      'Premium Wireless Headphones', 'Leather Messenger Bag', 'Smart Watch Pro',
      'Minimalist Desk Lamp', 'Running Shoes Ultra', 'Organic Skincare Set',
      'Bluetooth Speaker Pro', 'Bamboo Cutting Board', 'Yoga Mat Premium',
      'Coffee Maker Deluxe', 'Denim Jacket Classic', 'Sunglasses Aviator',
      'Backpack Travel Pro', 'Wallet Minimalist', 'Sneakers White',
      'Sweater Cashmere', 'Keyboard Mechanical', 'Mouse Wireless',
      'Monitor 27" 4K', 'Webcam HD Pro',
    ];
    return List.generate(count, (i) {
      final idx = i % names.length;
      final discount = i % 3 == 0 ? 50.0 : null;
      return Product(
        id: 'prod_${i + 1}',
        name: names[idx],
        description: 'High-quality product designed for everyday use with premium materials and exceptional craftsmanship.',
        price: 19.99 + (i * 17.5),
        originalPrice: discount != null ? (19.99 + (i * 17.5) + discount) : null,
        images: ['https://picsum.photos/seed/${names[idx].replaceAll(' ', '')}/400/400'],
        rating: 3.5 + (i % 3) * 0.5,
        reviewCount: 100 + i * 25,
        categoryId: categoryId ?? 'cat_${(i % 6) + 1}',
        categoryName: ['Electronics', 'Fashion', 'Home', 'Sports', 'Beauty', 'Toys'][i % 6],
        inStock: i % 7 != 0,
        stockQuantity: 10 + i * 5,
        features: ['Feature 1', 'Feature 2', 'Feature 3'],
        specs: {'Material': 'Premium', 'Weight': '250g', 'Color': 'Black'},
        discountPercent: discount != null ? 15 : 0,
      );
    });
  }
}

class CategoriesNotifier extends StateNotifier<CategoriesState> {
  final ApiClient apiClient;
  final HiveStorage hiveStorage;

  CategoriesNotifier({required this.apiClient, required this.hiveStorage})
      : super(CategoriesState());

  Future<void> loadCategories({String? parentId}) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 300));
    final categories = [
      Category(id: 'cat_1', name: 'Electronics', productCount: 245, imageUrl: 'https://picsum.photos/seed/electronics/200/200'),
      Category(id: 'cat_2', name: 'Fashion', productCount: 512, imageUrl: 'https://picsum.photos/seed/fashion/200/200'),
      Category(id: 'cat_3', name: 'Home & Garden', productCount: 189, imageUrl: 'https://picsum.photos/seed/home/200/200'),
      Category(id: 'cat_4', name: 'Sports', productCount: 98, imageUrl: 'https://picsum.photos/seed/sports/200/200'),
      Category(id: 'cat_5', name: 'Beauty', productCount: 334, imageUrl: 'https://picsum.photos/seed/beauty/200/200'),
      Category(id: 'cat_6', name: 'Toys', productCount: 156, imageUrl: 'https://picsum.photos/seed/toys/200/200'),
    ];
    state = state.copyWith(categories: categories, isLoading: false);
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final ApiClient apiClient;
  final PreferencesStorage preferencesStorage;

  SearchNotifier({required this.apiClient, required this.preferencesStorage})
      : super(SearchState());

  Future<void> search(String query, {int page = 1}) async {
    state = state.copyWith(isLoading: true, currentQuery: query);
    await Future.delayed(const Duration(milliseconds: 500));
    final results = List.generate(8, (i) => Product(
      id: 'prod_s_$i', name: '$query - Result ${i + 1}',
      price: 29.99 + (i * 10.0), rating: 4.0 + (i % 2) * 0.5,
      images: ['https://picsum.photos/seed/$query$i/400/400'],
      inStock: true,
    ));
    state = state.copyWith(
      results: results,
      pagination: PaginationMeta(totalItems: 24, hasNextPage: page < 3),
      isLoading: false,
    );
  }

  Future<void> loadSuggestions(String query) async {
    state = state.copyWith(suggestions: ['$query wireless', '$query pro', '$query premium', '$query lite']);
  }

  Future<void> loadRecentSearches() async {
    final history = await preferencesStorage.getSearchHistory();
    state = state.copyWith(recentSearches: history);
  }

  Future<void> clearRecentSearches() async {
    await preferencesStorage.clearSearchHistory();
    state = state.copyWith(recentSearches: []);
  }
}

class OrdersNotifier extends StateNotifier<OrdersState> {
  final ApiClient apiClient;
  final HiveStorage hiveStorage;

  OrdersNotifier({required this.apiClient, required this.hiveStorage})
      : super(OrdersState());

  Future<void> loadOrders({int page = 1, String? status}) async {
    state = state.copyWith(isLoading: page == 1, isLoadingMore: page > 1);
    await Future.delayed(const Duration(milliseconds: 400));
    final allOrders = [
      Order(id: 'ord_1', orderNumber: 'ORD-2025-001', status: 'delivered', total: 349.98, items: [
        CartItem(id: 'oi_1', productId: 'prod_1', name: 'Premium Wireless Headphones', price: 299.99, quantity: 1),
        CartItem(id: 'oi_2', productId: 'prod_7', name: 'Bluetooth Speaker Pro', price: 49.99, quantity: 1),
      ]),
      Order(id: 'ord_2', orderNumber: 'ORD-2025-002', status: 'shipped', total: 189.99, items: [
        CartItem(id: 'oi_3', productId: 'prod_5', name: 'Running Shoes Ultra', price: 189.99, quantity: 1),
      ]),
      Order(id: 'ord_3', orderNumber: 'ORD-2025-003', status: 'processing', total: 239.98, items: [
        CartItem(id: 'oi_4', productId: 'prod_2', name: 'Leather Messenger Bag', price: 149.99, quantity: 1),
        CartItem(id: 'oi_5', productId: 'prod_8', name: 'Bamboo Cutting Board', price: 89.99, quantity: 1),
      ]),
      Order(id: 'ord_4', orderNumber: 'ORD-2025-004', status: 'pending', total: 79.99, items: [
        CartItem(id: 'oi_6', productId: 'prod_6', name: 'Organic Skincare Set', price: 79.99, quantity: 1),
      ]),
    ];
    final filtered = status != null ? allOrders.where((o) => o.status == status).toList() : allOrders;
    state = state.copyWith(
      orders: filtered,
      pagination: PaginationMeta(totalItems: filtered.length),
      isLoading: false, isLoadingMore: false,
    );
  }
}

class AddressesNotifier extends StateNotifier<AddressesState> {
  final ApiClient apiClient;
  final HiveStorage hiveStorage;

  AddressesNotifier({required this.apiClient, required this.hiveStorage})
      : super(AddressesState());

  Future<void> loadAddresses() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(
      addresses: [
        Address(id: 'addr_1', label: 'Home', fullName: 'John Doe', street: '123 Main St', street2: 'Apt 4B', city: 'New York', state: 'NY', zipCode: '10001', phone: '+1 (555) 123-4567', isDefault: true),
        Address(id: 'addr_2', label: 'Work', fullName: 'John Doe', street: '456 Office Blvd', city: 'New York', state: 'NY', zipCode: '10002', phone: '+1 (555) 987-6543'),
        Address(id: 'addr_3', label: 'Vacation Home', fullName: 'John Doe', street: '789 Beach Ave', city: 'Miami', state: 'FL', zipCode: '33101'),
      ],
      isLoading: false,
    );
  }
}

class PaymentMethodsNotifier extends StateNotifier<PaymentMethodsState> {
  final ApiClient apiClient;

  PaymentMethodsNotifier({required this.apiClient})
      : super(PaymentMethodsState());

  Future<void> loadPaymentMethods() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(
      methods: [
        PaymentMethod(id: 'pm_1', type: 'card', brand: 'Visa', last4: '4242', expiryMonth: '12', expiryYear: '27', isDefault: true, holderName: 'John Doe'),
        PaymentMethod(id: 'pm_2', type: 'card', brand: 'Mastercard', last4: '8888', expiryMonth: '08', expiryYear: '26', holderName: 'John Doe'),
        PaymentMethod(id: 'pm_3', type: 'paypal', brand: 'PayPal', last4: 'john@example.com'),
      ],
      isLoading: false,
    );
  }
}

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final ApiClient apiClient;

  NotificationsNotifier({required this.apiClient})
      : super(NotificationsState());

  Future<void> loadNotifications({int page = 1, bool unreadOnly = false}) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 400));
    final all = [
      AppNotification(id: 'notif_1', title: 'Order Shipped!', body: 'Your order ORD-2025-002 has been shipped and is on its way.', type: 'order', read: false),
      AppNotification(id: 'notif_2', title: 'Flash Sale Alert', body: 'Up to 50% off on electronics for the next 24 hours!', type: 'promo', read: false),
      AppNotification(id: 'notif_3', title: 'Price Drop', body: 'The item in your wishlist has dropped in price by 15%.', type: 'price_drop', read: true),
      AppNotification(id: 'notif_4', title: 'Order Delivered', body: 'Your order ORD-2025-001 has been delivered. Enjoy!', type: 'order', read: true),
      AppNotification(id: 'notif_5', title: 'Review Request', body: 'How was your Premium Wireless Headphones? Share your review!', type: 'review', read: false),
    ];
    final filtered = unreadOnly ? all.where((n) => !n.read).toList() : all;
    state = state.copyWith(notifications: filtered, isLoading: false);
  }

  Future<void> markAsRead(String id) async {
    state = state.copyWith(
      notifications: state.notifications.map((n) => n.id == id ? n.copyWith(read: true) : n).toList(),
    );
  }

  Future<void> markAllAsRead() async {
    state = state.copyWith(
      notifications: state.notifications.map((n) => n.copyWith(read: true)).toList(),
    );
  }
}

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final PreferencesStorage preferencesStorage;

  ThemeModeNotifier({required this.preferencesStorage})
      : super(ThemeMode.system);

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final modeString = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await preferencesStorage.setThemeMode(modeString);
  }
}

class LanguageNotifier extends StateNotifier<Locale> {
  final PreferencesStorage preferencesStorage;

  LanguageNotifier({required this.preferencesStorage})
      : super(const Locale('en'));

  Future<void> setLanguage(String languageCode) async {
    state = Locale(languageCode);
    await preferencesStorage.setLanguage(languageCode);
  }
}

class CurrencyNotifier extends StateNotifier<String> {
  final PreferencesStorage preferencesStorage;

  CurrencyNotifier({required this.preferencesStorage})
      : super('USD');

  Future<void> setCurrency(String currencyCode) async {
    state = currencyCode;
    await preferencesStorage.setCurrency(currencyCode);
  }
}

class PushNotificationsNotifier extends StateNotifier<bool> {
  final PreferencesStorage preferencesStorage;

  PushNotificationsNotifier({required this.preferencesStorage})
      : super(true);

  Future<void> setPushEnabled(bool enabled) async {
    state = enabled;
    await preferencesStorage.setNotificationsEnabled(enabled);
  }
}

class EmailNotificationsNotifier extends StateNotifier<bool> {
  final PreferencesStorage preferencesStorage;

  EmailNotificationsNotifier({required this.preferencesStorage})
      : super(true);

  Future<void> setEmailEnabled(bool enabled) async {
    state = enabled;
    await preferencesStorage.setEmailEnabled(enabled);
  }
}

class AnalyticsConsentNotifier extends StateNotifier<bool> {
  final PreferencesStorage preferencesStorage;

  AnalyticsConsentNotifier({required this.preferencesStorage})
      : super(true);

  Future<void> setAnalyticsConsent(bool consent) async {
    state = consent;
    await preferencesStorage.setAnalyticsEnabled(consent);
  }
}