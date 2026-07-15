// Auth Data - Local Data Source
import 'dart:convert';

import 'package:flutter_ecommerce/core/storage/secure_storage.dart';
import 'package:flutter_ecommerce/shared/models.dart';

class AuthLocalDataSource {
  final SecureStorage secureStorage;

  AuthLocalDataSource(this.secureStorage);

  static const _userKey = 'cached_user';

  Future<void> saveAuthTokens(AuthResponse response) async {
    await Future.wait([
      secureStorage.saveAccessToken(response.tokens.accessToken),
      secureStorage.saveRefreshToken(response.tokens.refreshToken),
    ]);
    await cacheUser(response.user);
  }

  Future<void> updateAccessToken(String token) async {
    await secureStorage.saveAccessToken(token);
  }

  Future<void> clearAuthTokens() async {
    await secureStorage.clearAuthTokens();
  }

  Future<void> cacheUser(UserProfile user) async {
    final json = user.toJson();
    await secureStorage.write(_userKey, jsonEncode(json));
  }

  Future<UserProfile?> getCachedUser() async {
    final jsonStr = await secureStorage.read(_userKey);
    if (jsonStr == null) return null;
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    return UserProfile.fromJson(json);
  }

  Future<String?> getAccessToken() async => secureStorage.getAccessToken();
  Future<String?> getRefreshToken() async => secureStorage.getRefreshToken();

  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}