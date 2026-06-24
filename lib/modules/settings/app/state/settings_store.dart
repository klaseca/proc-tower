import 'package:flutter/material.dart';
import 'package:jolt/jolt.dart';

import '../../infra/dao/settings_dao.dart';

class SettingsStore {
  final SettingsDao _dao;
  final themeMode = Signal(ThemeMode.system);

  SettingsStore(this._dao);

  Future<void> restore() async {
    themeMode.value = await _dao.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode nextThemeMode) async {
    if (themeMode.peek == nextThemeMode) {
      return;
    }

    await _dao.saveThemeMode(nextThemeMode);
    themeMode.value = nextThemeMode;
  }
}
