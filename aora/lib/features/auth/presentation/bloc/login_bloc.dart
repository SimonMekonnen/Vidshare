import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/usecases/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<Login>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(Login event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    final result = await loginUseCase(
      LoginParams(username: event.username, password: event.password),
    );

    result.fold(
      (failure) => emit(LoginFailure(error: failure)),
      (tokens) => emit(LoginSuccess(tokens: tokens)),
    );
  }
}
