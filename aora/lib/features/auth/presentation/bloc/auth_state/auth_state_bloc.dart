import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/services/auth_manager.dart';
import '../../../data/models/auth_tokens_model.dart';

part 'auth_state_event.dart';
part 'auth_state_state.dart';

class AuthStateBloc extends Bloc<AuthStateEvent, AuthState> {
  final AuthManager _authManager;

  AuthStateBloc(this._authManager) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<AuthenticateUser>(_onAuthenticateUser);
    on<SignOutUser>(_onSignOutUser);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final isAuthenticated = await _authManager.isAuthenticated;
    emit(isAuthenticated ? Authenticated() : Unauthenticated());
  }

  Future<void> _onAuthenticateUser(
    AuthenticateUser event,
    Emitter<AuthState> emit,
  ) async {
    await _authManager.setTokens(event.tokens);
    emit(Authenticated());
  }

  Future<void> _onSignOutUser(
    SignOutUser event,
    Emitter<AuthState> emit,
  ) async {
    await _authManager.clearTokens();
    emit(Unauthenticated());
  }
}
