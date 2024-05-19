import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_manager/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await AuthRepository.login(event.username, event.password);
      emit(AuthSuccess());
    } catch (error) {
      emit(AuthFailure(error: error.toString()));
    }
  }
}
