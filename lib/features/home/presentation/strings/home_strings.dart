import 'dart:ui';

import 'home_strings_en.dart';
import 'home_strings_pt.dart';

class HomeStrings {
  static final _locale = PlatformDispatcher.instance.locale;

  static bool get _isPortuguese => _locale.languageCode == 'pt';

  // NavBar
  static String get homeNavBar =>
      _isPortuguese ? HomeStringsPt.homeNavBar : HomeStringsEn.homeNavBar;
}
