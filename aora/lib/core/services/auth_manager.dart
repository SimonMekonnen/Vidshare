import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/models/auth_tokens_model.dart';

class AuthManager {
  final AuthLocalDataSource _localDataSource;

  AuthManager(this._localDataSource);

  AuthTokensModel? _currentTokens;

  Future<AuthTokensModel?> get tokens async {
    if (_currentTokens != null) return _currentTokens;
    try {
      _currentTokens = await _localDataSource.getAuthTokens();
      return _currentTokens;
    } catch (e) {
      return null;
    }
  }

  Future<bool> get isAuthenticated async => await tokens != null;

  Future<void> setTokens(AuthTokensModel tokens) async {
    _currentTokens = tokens;
    await _localDataSource.cacheAuthTokens(tokens);
  }

  Future<void> clearTokens() async {
    _currentTokens = null;
    await _localDataSource.clearAuthTokens();
  }
}
