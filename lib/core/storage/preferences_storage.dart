// SharedPreferences Wrapper
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesStorage {
  late SharedPreferences _prefs;
  bool _initialized = false;

  static const String _themeModeKey = 'theme_mode';
  static const String _languageKey = 'language';
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _firstLaunchKey = 'first_launch';
  static const String _currencyKey = 'currency';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _analyticsEnabledKey = 'analytics_enabled';
  static const String _lastSyncKey = 'last_sync';

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  Future<void> ensureInitialized() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  Future<void> _ensureReady() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // Theme
  Future<void> setThemeMode(String mode) async {
    await _ensureReady();
    await _prefs.setString(_themeModeKey, mode);
  }

  Future<String> getThemeMode() async {
    await _ensureReady();
    return _prefs.getString(_themeModeKey) ?? 'system';
  }

  // Language
  Future<void> setLanguage(String languageCode) async {
    await _ensureReady();
    await _prefs.setString(_languageKey, languageCode);
  }

  Future<String> getLanguage() async {
    await _ensureReady();
    return _prefs.getString(_languageKey) ?? 'en';
  }

  // Onboarding
  Future<void> setOnboardingComplete(bool complete) async {
    await _ensureReady();
    await _prefs.setBool(_onboardingCompleteKey, complete);
  }

  Future<bool> isOnboardingComplete() async {
    await _ensureReady();
    return _prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  Future<void> setFirstLaunch(bool firstLaunch) async {
    await _ensureReady();
    await _prefs.setBool(_firstLaunchKey, firstLaunch);
  }

  Future<bool> isFirstLaunch() async {
    await _ensureReady();
    return _prefs.getBool(_firstLaunchKey) ?? true;
  }

  // Currency
  Future<void> setCurrency(String currencyCode) async {
    await _ensureReady();
    await _prefs.setString(_currencyKey, currencyCode);
  }

  Future<String> getCurrency() async {
    await _ensureReady();
    return _prefs.getString(_currencyKey) ?? 'USD';
  }

  // Notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _ensureReady();
    await _prefs.setBool(_notificationsEnabledKey, enabled);
  }

  Future<bool> areNotificationsEnabled() async {
    await _ensureReady();
    return _prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  Future<void> setEmailEnabled(bool enabled) async {
    await _ensureReady();
    await _prefs.setBool('email_notifications_enabled', enabled);
  }

  Future<bool> isEmailEnabled() async {
    await _ensureReady();
    return _prefs.getBool('email_notifications_enabled') ?? true;
  }

  // Analytics
  Future<void> setAnalyticsEnabled(bool enabled) async {
    await _ensureReady();
    await _prefs.setBool(_analyticsEnabledKey, enabled);
  }

  Future<bool> isAnalyticsEnabled() async {
    await _ensureReady();
    return _prefs.getBool(_analyticsEnabledKey) ?? true;
  }

  // Last Sync
  Future<void> setLastSync(DateTime dateTime) async {
    await _ensureReady();
    await _prefs.setString(_lastSyncKey, dateTime.toIso8601String());
  }

  Future<DateTime?> getLastSync() async {
    await _ensureReady();
    final string = _prefs.getString(_lastSyncKey);
    return string != null ? DateTime.parse(string) : null;
  }

  // Generic
  Future<void> setString(String key, String value) async {
    await _ensureReady();
    await _prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    await _ensureReady();
    return _prefs.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _ensureReady();
    await _prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    await _ensureReady();
    return _prefs.getBool(key);
  }

  Future<void> setInt(String key, int value) async {
    await _ensureReady();
    await _prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    await _ensureReady();
    return _prefs.getInt(key);
  }

  Future<void> setDouble(String key, double value) async {
    await _ensureReady();
    await _prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    await _ensureReady();
    return _prefs.getDouble(key);
  }

  Future<void> remove(String key) async {
    await _ensureReady();
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _ensureReady();
    await _prefs.clear();
  }

  static const String _searchHistoryKey = 'search_history';

  Future<List<String>> getSearchHistory() async {
    await _ensureReady();
    final list = _prefs.getStringList(_searchHistoryKey);
    return list ?? [];
  }

  Future<void> clearSearchHistory() async {
    await _ensureReady();
    await _prefs.remove(_searchHistoryKey);
  }
}