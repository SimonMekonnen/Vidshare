import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokensModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String username);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<AuthTokensModel> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/token'),
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return AuthTokensModel.fromJson(json.decode(response.body));
      } else {
        final errorBody = json.decode(response.body);
        throw ServerException(
          message: errorBody['message'] ?? 'Failed to login',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'An error occurred during login: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel> register(String email, String password, String username) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/signup'),
        body: json.encode({
          'email': email,
          'password': password,
          'username': username,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        final errorBody = json.decode(response.body);
        throw ServerException(
          message: errorBody['message'] ?? 'Failed to register',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'An error occurred during registration: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        final errorBody = json.decode(response.body);
        throw ServerException(
          message: errorBody['message'] ?? 'Failed to logout',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'An error occurred during logout: ${e.toString()}',
      );
    }
  }
}