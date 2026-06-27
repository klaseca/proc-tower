import 'strings.g.dart';

extension AppLocaleLabel on AppLocale {
  String get label => switch (this) {
    AppLocale.en => 'English',
    AppLocale.ru => 'Русский',
  };
}
