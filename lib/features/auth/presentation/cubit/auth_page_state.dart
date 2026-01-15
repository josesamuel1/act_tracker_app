part of 'auth_page_cubit.dart';

enum AuthMode { login, register }

enum AuthStatus { initial, loading, success, error }

class AuthPageState extends Equatable {
  final String username;
  final String password;
  final AuthMode mode;
  final AuthStatus status;
  final String? errorMessage;
  final bool obscurePassword;

  const AuthPageState({
    required this.username,
    required this.password,
    required this.mode,
    required this.status,
    required this.errorMessage,
    required this.obscurePassword,
  });

  @override
  List<Object?> get props => [username, password, mode, status, errorMessage, obscurePassword];

  factory AuthPageState.initial() => AuthPageState(
    username: '',
    password: '',
    mode: AuthMode.login,
    status: AuthStatus.initial,
    errorMessage: null,
    obscurePassword: true,
  );

  bool get isLogin => mode == AuthMode.login;
  bool get isRegister => mode == AuthMode.register;

  bool get isFormValid => username.isNotEmpty && password.isNotEmpty;

  AuthPageState copyWith({
    String? username,
    String? password,
    AuthMode? mode,
    AuthStatus? status,
    String? errorMessage,
    bool? obscurePassword,
  }) {
    return AuthPageState(
      username: username ?? this.username,
      password: password ?? this.password,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}
