part of 'auth_state_bloc.dart';

sealed class AuthStateEvent extends Equatable {
  const AuthStateEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthStatus extends AuthStateEvent {}

class AuthenticateUser extends AuthStateEvent {
  final AuthTokensModel tokens;
  
  const AuthenticateUser({required this.tokens});

  @override
  List<Object> get props => [tokens];
}

class SignOutUser extends AuthStateEvent {}