import 'dart:convert';

import 'package:act_tracker/features/auth/data/models/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin UserMixin {
  static const _userKey = 'user';

  // Fetch the current user from SharedPreferences
  Future<UserModel?> get currentUser async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final userJson = sharedPreferences.getString(_userKey);

    if (userJson == null) return null;

    final Map<String, dynamic> userMap = jsonDecode(userJson);

    return UserModel.fromJson(userMap);
  }

  // Set the current user in SharedPreferences
  Future<void> setCurrentUser({required UserModel user}) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final userJson = jsonEncode(user.toJson());

    await sharedPreferences.setString(_userKey, userJson);
  }

  // Remove the current user from SharedPreferences
  Future<void> logoutUser() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.remove(_userKey);
  }
}
