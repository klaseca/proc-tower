import 'package:flutter/material.dart';
import 'package:jolt/jolt.dart';

import '/i18n/strings.g.dart';
import '../../infra/dao/settings_dao.dart';

class SettingsStore {
  final SettingsDao _dao;
  final themeMode = Signal(ThemeMode.system);
  final locale = Signal<AppLocale?>(null);

  SettingsStore(this._dao);

  Future<void> restore() async {
    final settings = await _dao.getSettings();
    themeMode.value = settings.themeMode;
    locale.value = settings.locale;
  }

  Future<void> setThemeMode(ThemeMode nextThemeMode) async {
    if (themeMode.peek == nextThemeMode) {
      return;
    }

    await _dao.saveSettings(
      SettingsData(
        themeMode: nextThemeMode,
        locale: locale.peek,
      ),
    );
    themeMode.value = nextThemeMode;
  }

  Future<void> setLocale(AppLocale? nextLocale) async {
    if (locale.peek == nextLocale) {
      return;
    }

    await _dao.saveSettings(
      SettingsData(
        themeMode: themeMode.peek,
        locale: nextLocale,
      ),
    );
    locale.value = nextLocale;
  }
}
