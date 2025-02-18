import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String username;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object> get props => [email, password, username];
}

class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      params.email,
      params.password,
      params.username,
    );
  }
}
