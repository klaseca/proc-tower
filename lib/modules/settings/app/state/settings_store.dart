import 'package:jolt/jolt.dart';
import 'package:material_ui/material_ui.dart';

import '/i18n/strings.g.dart';
import '/infra/app_data_storage/app_data_location.dart';
import '/infra/app_data_storage/app_data_storage.dart';
import '../../infra/dao/settings_dao.dart';

class SettingsStore {
  final SettingsDao _dao;
  final AppDataStorage _storage;
  final themeMode = Signal(ThemeMode.system);
  final locale = Signal<AppLocale?>(null);

  String get dataDirectory => _storage.directory.path;
  AppDataSource get dataDirectorySource => _storage.source;

  SettingsStore(this._dao, this._storage);

  Future<void> restore() async {
    final settings = await _dao.getSettings();
    themeMode.value = settings.themeMode;
    locale.value = settings.locale;
  }

  Future<void> setThemeMode(ThemeMode nextThemeMode) async {
    if (themeMode.peek == nextThemeMode) {
      return;
    }

    await _dao.saveSettings(SettingsData(themeMode: nextThemeMode, locale: locale.peek));
    themeMode.value = nextThemeMode;
  }

  Future<void> setLocale(AppLocale? nextLocale) async {
    if (locale.peek == nextLocale) {
      return;
    }

    await _dao.saveSettings(SettingsData(themeMode: themeMode.peek, locale: nextLocale));
    locale.value = nextLocale;
  }
}
