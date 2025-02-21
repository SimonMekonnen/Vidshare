import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/usecases/register_usecase.dart';
import '../../../../../core/error/failures.dart';

part 'signup_state.dart';
part 'signup_event.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final RegisterUseCase registerUseCase;

  SignupBloc({
    required this.registerUseCase,
  }) : super(SignupInitial()) {
    on<Signup>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
    Signup event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());

    final result = await registerUseCase(
      RegisterParams(
        email: event.email,
        password: event.password,
        username: event.username,
      ),
    );

    result.fold(
      (failure) => emit(SignupFailure(error: failure)),
      (user) => emit(SignupSuccess(user: user)),
    );
  }
}
