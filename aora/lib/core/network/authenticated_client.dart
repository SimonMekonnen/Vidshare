import 'package:http/http.dart' as http;
import '../services/auth_manager.dart';

class AuthenticatedClient extends http.BaseClient {
  final http.Client _inner;
  final AuthManager _authManager;

  AuthenticatedClient(this._inner, this._authManager);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final tokens = await _authManager.tokens;
    if (tokens != null) {
      request.headers['Authorization'] = 'JWT ${tokens.accessToken}';
    }
    return _inner.send(request);
  }
}