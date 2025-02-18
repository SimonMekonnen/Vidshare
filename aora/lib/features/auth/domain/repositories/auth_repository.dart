import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_tokens.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokens>> login(String email, String password);
  Future<Either<Failure, User>> register(String email, String password, String username);
  Future<Either<Failure, void>> logout();
}
