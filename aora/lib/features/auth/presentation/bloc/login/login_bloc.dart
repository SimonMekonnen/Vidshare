import 'package:aora/features/auth/data/models/auth_tokens_model.dart';
import 'package:aora/features/auth/domain/entities/auth_tokens.dart';
import 'package:aora/features/auth/presentation/bloc/auth_state/auth_state_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/login_usecase.dart';

part 'login_state.dart';
part 'login_event.dart';
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final AuthStateBloc authStateBloc;

  LoginBloc({
    required this.loginUseCase,
    required this.authStateBloc,
  }) : super(LoginInitial()) {
    on<Login>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(Login event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
  
    final result = await loginUseCase(
      LoginParams(username: event.username, password: event.password),
    );
  
    result.fold(
      (failure) => emit(LoginFailure(error: failure)),
      (tokens) {
        authStateBloc.add(AuthenticateUser(tokens: tokens as AuthTokensModel));
        emit(LoginSuccess(tokens: tokens));
      },
    );
  }
}