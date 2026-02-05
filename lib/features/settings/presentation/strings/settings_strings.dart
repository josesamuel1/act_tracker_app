import 'dart:ui';

import 'settings_strings_en.dart';
import 'settings_strings_pt.dart';

class SettingsStrings {
  static final _locale = PlatformDispatcher.instance.locale;

  static bool get _isPortuguese => _locale.languageCode == 'pt';

  // Elevated Buttons
  static String get logoutButton =>
      _isPortuguese ? SettingsStringsPt.logoutButton : SettingsStringsEn.logoutButton;
}
