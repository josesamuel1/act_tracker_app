import 'package:act_tracker/features/auth/domain/domain.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  // Login a user and return the user if found, otherwise return null
  Future<UserEntity?> call({required String username, required String password}) async {
    return await repository.login(username: username, password: password);
  }
}
