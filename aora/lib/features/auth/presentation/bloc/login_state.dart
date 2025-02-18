part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final AuthTokens tokens;

  const LoginSuccess({required this.tokens});

  @override
  List<Object> get props => [tokens];
}

class LoginFailure extends LoginState {
  final Failure error;

  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}
