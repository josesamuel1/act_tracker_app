import 'dart:convert';

import 'package:crypto/crypto.dart';

class PasswordHasher {
  // Hash a password using SHA-256
  static String hash({required String password}) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
