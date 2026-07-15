// Hive Local Storage for Caching
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

@injectable
class HiveStorage {
  static const String _productsBox = 'products_cache';
  static const String _categoriesBox = 'categories_cache';
  static const String _cartBox = 'cart_cache';
  static const String _wishlistBox = 'wishlist_cache';
  static const String _searchHistoryBox = 'search_history';
  static const String _recentlyViewedBox = 'recently_viewed';
  static const String _settingsBox = 'app_settings';

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    await Future.wait([
      Hive.openBox(_productsBox),
      Hive.openBox(_categoriesBox),
      Hive.openBox(_cartBox),
      Hive.openBox(_wishlistBox),
      Hive.openBox(_searchHistoryBox),
      Hive.openBox(_recentlyViewedBox),
      Hive.openBox(_settingsBox),
    ]);

    _initialized = true;
  }

  // Products Cache
  Box get productsBox => Hive.box(_productsBox);
  
  Future<void> cacheProducts(String key, dynamic data, {Duration? ttl}) async {
    await productsBox.put(key, {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'ttl': ttl?.inMilliseconds ?? 24 * 60 * 60 * 1000, // 24 hours default
    });
  }

  dynamic getCachedProducts(String key) {
    final cached = productsBox.get(key);
    if (cached == null) return null;
    
    final timestamp = cached['timestamp'] as int;
    final ttl = cached['ttl'] as int;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    if (now - timestamp > ttl) {
      productsBox.delete(key);
      return null;
    }
    
    return cached['data'];
  }

  Future<void> clearProductsCache() async {
    await productsBox.clear();
  }

  // Categories Cache
  Box get categoriesBox => Hive.box(_categoriesBox);

  Future<void> cacheCategories(dynamic data, {Duration? ttl}) async {
    await categoriesBox.put('all_categories', {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'ttl': ttl?.inMilliseconds ?? 7 * 24 * 60 * 60 * 1000, // 7 days
    });
  }

  dynamic getCachedCategories() {
    final cached = categoriesBox.get('all_categories');
    if (cached == null) return null;
    
    final timestamp = cached['timestamp'] as int;
    final ttl = cached['ttl'] as int;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    if (now - timestamp > ttl) {
      categoriesBox.delete('all_categories');
      return null;
    }
    
    return cached['data'];
  }

  // Cart Cache (offline support)
  Box get cartBox => Hive.box(_cartBox);

  Future<void> cacheCart(dynamic data) async {
    await cartBox.put('current_cart', data);
  }

  dynamic getCachedCart() {
    return cartBox.get('current_cart');
  }

  Future<void> clearCartCache() async {
    await cartBox.delete('current_cart');
  }

  // Wishlist Cache
  Box get wishlistBox => Hive.box(_wishlistBox);

  Future<void> cacheWishlist(dynamic data) async {
    await wishlistBox.put('current_wishlist', data);
  }

  dynamic getCachedWishlist() {
    return wishlistBox.get('current_wishlist');
  }

  // Search History
  Box get searchHistoryBox => Hive.box(_searchHistoryBox);

  Future<void> addSearchHistory(String query) async {
    final history = getSearchHistory();
    history.remove(query);
    history.insert(0, query);
    if (history.length > 50) history.removeRange(50, history.length);
    await searchHistoryBox.put('queries', history);
  }

  List<String> getSearchHistory() {
    return List<String>.from(searchHistoryBox.get('queries', defaultValue: []));
  }

  Future<void> clearSearchHistory() async {
    await searchHistoryBox.delete('queries');
  }

  // Recently Viewed
  Box get recentlyViewedBox => Hive.box(_recentlyViewedBox);

  Future<void> addRecentlyViewed(String productId) async {
    final recent = getRecentlyViewed();
    recent.remove(productId);
    recent.insert(0, productId);
    if (recent.length > 20) recent.removeRange(20, recent.length);
    await recentlyViewedBox.put('products', recent);
  }

  List<String> getRecentlyViewed() {
    return List<String>.from(recentlyViewedBox.get('products', defaultValue: []));
  }

  Future<void> clearRecentlyViewed() async {
    await recentlyViewedBox.delete('products');
  }

  // Orders Cache
  Box get ordersBox => Hive.box('orders_cache');

  Future<void> cacheOrders(String key, dynamic data) async {
    await ordersBox.put(key, data);
  }

  dynamic getCachedOrders(String key) {
    return ordersBox.get(key);
  }

  // Addresses Cache
  Box get addressesBox => Hive.box('addresses_cache');

  Future<void> cacheAddresses(String key, dynamic data) async {
    await addressesBox.put(key, data);
  }

  dynamic getCachedAddresses(String key) {
    return addressesBox.get(key);
  }

  // App Settings
  Box get settingsBox => Hive.box(_settingsBox);

  Future<void> setSetting(String key, dynamic value) async {
    await settingsBox.put(key, value);
  }

  T? getSetting<T>(String key, {T? defaultValue}) {
    return settingsBox.get(key, defaultValue: defaultValue);
  }

  Future<void> deleteSetting(String key) async {
    await settingsBox.delete(key);
  }

  Future<void> clearAll() async {
    await Future.wait([
      productsBox.clear(),
      categoriesBox.clear(),
      cartBox.clear(),
      wishlistBox.clear(),
      searchHistoryBox.clear(),
      recentlyViewedBox.clear(),
      ordersBox.clear(),
      addressesBox.clear(),
      settingsBox.clear(),
    ]);
  }
}