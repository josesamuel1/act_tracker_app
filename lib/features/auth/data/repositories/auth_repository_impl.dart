import 'package:act_tracker/core/crypto/password_hasher.dart';
import 'package:act_tracker/core/data/mixins/user.mixin.dart';
import 'package:act_tracker/features/auth/auth.dart';

class AuthRepositoryImpl with UserMixin implements AuthRepository {
  final AuthLocalDatasource local;

  AuthRepositoryImpl({required this.local});

  // Register a new user in the repository
  @override
  Future<void> register({required UserEntity user}) async {
    final passwordHash = PasswordHasher.hash(password: user.password);

    final userModel = UserModel(username: user.username, password: passwordHash);

    return await local.register(user: userModel);
  }

  // Login a user and return the user if found, otherwise return null
  @override
  Future<UserEntity?> login({required String username, required String password}) async {
    final passwordHash = PasswordHasher.hash(password: password);

    final user = await local.login(username: username, passwordHash: passwordHash);

    if (user == null) return null;

    await setCurrentUser(user: user);

    return user;
  }
}
