// App Configuration - Environment-based config

enum Environment { development, staging, production }

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String apiVersion;
  final String appName;
  final bool enableLogging;
  final bool enableAnalytics;
  final int connectTimeout;
  final int receiveTimeout;
  final int sendTimeout;

  const AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.apiVersion,
    required this.appName,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.sendTimeout,
  });

  static AppConfig get current => _instance ??= _createConfig();
  static AppConfig? _instance;

  static AppConfig _createConfig() {
    // In production, this would come from --dart-define or flavor config
    const env = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    return switch (env) {
      'production' => _production(),
      'staging' => _staging(),
      _ => _development(),
    };
  }

  static AppConfig _development() => const AppConfig._(
        environment: Environment.development,
        apiBaseUrl: 'https://api-dev.example.com',
        apiVersion: 'v1',
        appName: 'E-Commerce Dev',
        enableLogging: true,
        enableAnalytics: false,
        connectTimeout: 30000,
        receiveTimeout: 30000,
        sendTimeout: 30000,
      );

  static AppConfig _staging() => const AppConfig._(
        environment: Environment.staging,
        apiBaseUrl: 'https://api-staging.example.com',
        apiVersion: 'v1',
        appName: 'E-Commerce Staging',
        enableLogging: true,
        enableAnalytics: true,
        connectTimeout: 20000,
        receiveTimeout: 20000,
        sendTimeout: 20000,
      );

  static AppConfig _production() => const AppConfig._(
        environment: Environment.production,
        apiBaseUrl: 'https://api.example.com',
        apiVersion: 'v1',
        appName: 'E-Commerce',
        enableLogging: false,
        enableAnalytics: true,
        connectTimeout: 15000,
        receiveTimeout: 15000,
        sendTimeout: 15000,
      );

  String get fullApiUrl => '$apiBaseUrl/$apiVersion';

  bool get isDevelopment => environment == Environment.development;
  bool get isStaging => environment == Environment.staging;
  bool get isProduction => environment == Environment.production;

  @override
  String toString() => 'AppConfig(environment: $environment, apiBaseUrl: $apiBaseUrl)';
}

/// Feature flags for progressive rollout
class FeatureFlags {
  const FeatureFlags();

  static const bool enableNewCheckout = true;
  static const bool enableWishlist = true;
  static const bool enableProductReviews = true;
  static const bool enableSocialLogin = true;
  static const bool enablePushNotifications = true;
  static const bool enableDarkMode = true;
  static const bool enableOfflineMode = false;
  static const bool enableBetaFeatures = false;
}

/// App constants
class AppConstants {
  const AppConstants();

  static const String appName = 'E-Commerce';
  static const String bundleId = 'com.example.ecommerce';
  static const String version = '1.0.0';
  static const int buildNumber = 1;

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeModeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String cartKey = 'cart_items';
  static const String recentlyViewedKey = 'recently_viewed';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const Duration imageCacheExpiration = Duration(days: 7);

  // Animation
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  // Debounce
  static const Duration searchDebounce = Duration(milliseconds: 300);
  static const Duration apiDebounce = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxAddressLength = 200;
  static const int maxPhoneLength = 20;
  static const int minPhoneLength = 10;

  // Image
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  static const double productImageRatio = 1.0;
  static const double bannerImageRatio = 16 / 9;

  // Currency
  static const String defaultCurrency = 'USD';
  static const String currencySymbol = '\$';
  static const int currencyDecimalDigits = 2;
}