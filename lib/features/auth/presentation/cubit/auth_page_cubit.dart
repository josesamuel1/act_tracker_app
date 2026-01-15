import 'package:act_tracker/features/auth/domain/entities/user.entity.dart';
import 'package:act_tracker/features/auth/domain/usecases/usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_page_state.dart';

class AuthPageCubit extends Cubit<AuthPageState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthPageCubit({required this.loginUseCase, required this.registerUseCase})
    : super(AuthPageState.initial());

  void onUsernameChanged(String value) {
    emit(state.copyWith(username: value));
  }

  void onPasswordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void switchToRegister() {
    emit(state.copyWith(mode: AuthMode.register, status: AuthStatus.initial, errorMessage: null));
  }

  void switchToLogin() {
    emit(state.copyWith(mode: AuthMode.login, status: AuthStatus.initial, errorMessage: null));
  }

  Future<void> _register() async {
    final user = UserEntity(username: state.username, password: state.password);

    await registerUseCase.call(user: user);
  }

  Future<UserEntity?> _login() async {
    final user = await loginUseCase.call(username: state.username, password: state.password);

    return user;
  }

  Future<void> submit() async {
    if (!state.isFormValid) return;

    try {
      emit(state.copyWith(status: AuthStatus.loading));

      switch (state.mode) {
        case AuthMode.register:
          await _register();
          break;
        case AuthMode.login:
          await _login();
          break;
      }

      emit(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.toString()));
    }
  }
}
