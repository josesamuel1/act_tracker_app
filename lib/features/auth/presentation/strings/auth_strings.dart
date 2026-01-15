import 'dart:ui';

import 'auth_strings_en.dart';
import 'auth_strings_pt.dart';

class AuthStrings {
  static final _locale = PlatformDispatcher.instance.locale;
  static bool get _isPortuguese => _locale.languageCode == 'pt';

  static String get appName => _isPortuguese ? AuthStringsPt.appName : AuthStringsEn.appName;

  // Titles
  static String get loginTitle =>
      _isPortuguese ? AuthStringsPt.loginTitle : AuthStringsEn.loginTitle;

  static String get registerTitle =>
      _isPortuguese ? AuthStringsPt.registerTitle : AuthStringsEn.registerTitle;

  // Elevated Buttons
  static String get loginElevatedButton =>
      _isPortuguese ? AuthStringsPt.loginElevatedButton : AuthStringsEn.loginElevatedButton;

  static String get registerElevatedButton =>
      _isPortuguese ? AuthStringsPt.registerElevatedButton : AuthStringsEn.registerElevatedButton;

  // Text Buttons
  static String get loginTextButton =>
      _isPortuguese ? AuthStringsPt.loginTextButton : AuthStringsEn.loginTextButton;

  static String get registerTextButton =>
      _isPortuguese ? AuthStringsPt.registerTextButton : AuthStringsEn.registerTextButton;

  // Label Texts
  static String get usernameLabel =>
      _isPortuguese ? AuthStringsPt.usernameLabel : AuthStringsEn.usernameLabel;

  static String get passwordLabel =>
      _isPortuguese ? AuthStringsPt.passwordLabel : AuthStringsEn.passwordLabel;

  // Validators
  static String get usernameValidator =>
      _isPortuguese ? AuthStringsPt.usernameValidator : AuthStringsEn.usernameValidator;

  static String get passwordValidator =>
      _isPortuguese ? AuthStringsPt.passwordValidator : AuthStringsEn.passwordValidator;
}
