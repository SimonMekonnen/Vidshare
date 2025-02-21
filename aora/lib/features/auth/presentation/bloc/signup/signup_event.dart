part of 'signup_bloc.dart';



abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class Signup extends SignupEvent {
  final String email;
  final String password;
  final String username;

  const Signup({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object> get props => [email, password, username];
}