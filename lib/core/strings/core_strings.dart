import 'dart:ui';

import 'core_strings_en.dart';
import 'core_strings_pt.dart';

class CoreStrings {
  static final _locale = PlatformDispatcher.instance.locale;
  static bool get isPortuguese => _locale.languageCode == 'pt';

  static String get appName => isPortuguese ? CoreStringsPt.appName : CoreStringsEn.appName;

  static String get error => isPortuguese ? CoreStringsPt.error : CoreStringsEn.error;
}
