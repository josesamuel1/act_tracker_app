import 'package:act_tracker/features/auth/auth.dart';

abstract class AuthRepository {
  Future<void> register({required UserEntity user});
  Future<UserEntity?> login({required String username, required String password});
}
