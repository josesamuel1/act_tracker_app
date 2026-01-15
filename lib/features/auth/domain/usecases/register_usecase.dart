import 'package:act_tracker/features/auth/domain/domain.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  // Register a new user in the repository
  Future<void> call({required UserEntity user}) async {
    return await repository.register(user: user);
  }
}
