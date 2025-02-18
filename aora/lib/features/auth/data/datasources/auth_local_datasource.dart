import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/auth_tokens_model.dart';

abstract class AuthLocalDataSource {
  Future<AuthTokensModel> getAuthTokens();
  Future<void> cacheAuthTokens(AuthTokensModel tokens);
  Future<void> clearAuthTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const CACHED_AUTH_TOKENS = 'CACHED_AUTH_TOKENS';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<AuthTokensModel> getAuthTokens() {
    try {
      final jsonString = sharedPreferences.getString(CACHED_AUTH_TOKENS);
      if (jsonString != null) {
        return Future.value(AuthTokensModel.fromJson(json.decode(jsonString)));
      } else {
        throw CacheException(message: 'No cached auth tokens found');
      }
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(
        message: 'Error retrieving cached tokens: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> cacheAuthTokens(AuthTokensModel tokens) async {
    try {
      await sharedPreferences.setString(
        CACHED_AUTH_TOKENS,
        json.encode(tokens.toJson()),
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache auth tokens: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> clearAuthTokens() async {
    try {
      await sharedPreferences.remove(CACHED_AUTH_TOKENS);
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear auth tokens: ${e.toString()}',
      );
    }
  }
}