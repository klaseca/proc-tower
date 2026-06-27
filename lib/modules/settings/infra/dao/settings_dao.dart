import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '/i18n/strings.g.dart';

class SettingsData {
  final ThemeMode themeMode;
  final AppLocale? locale;

  const SettingsData({
    this.themeMode = ThemeMode.system,
    this.locale,
  });
}

class SettingsDao {
  final _file = _initFile();

  Future<SettingsData> getSettings() async {
    try {
      if (!await _file.exists()) {
        return const SettingsData();
      }

      final contents = await _file.readAsString();

      if (contents.trim().isEmpty) {
        return const SettingsData();
      }

      final decoded = jsonDecode(contents) as Map<String, dynamic>;
      final rawThemeMode = decoded['themeMode'] as String?;
      final rawLocaleCode = decoded['locale'] as String?;

      return SettingsData(
        themeMode: ThemeMode.values.firstWhere(
          (themeMode) => themeMode.name == rawThemeMode,
          orElse: () => ThemeMode.system,
        ),
        locale: _parseLocale(rawLocaleCode),
      );
    } on FileSystemException {
      return const SettingsData();
    } on FormatException {
      return const SettingsData();
    }
  }

  Future<void> saveSettings(SettingsData settings) async {
    await _file.parent.create(recursive: true);

    final contents = const JsonEncoder.withIndent('  ').convert({
      'themeMode': settings.themeMode.name,
      if (settings.locale case final locale?) 'locale': locale.languageCode,
    });

    await _file.writeAsString(contents);
  }

  static File _initFile() {
    final directory = File(Platform.resolvedExecutable).parent;
    final filePath = '${directory.path}${Platform.pathSeparator}settings.json';
    return File(filePath);
  }
}

AppLocale? _parseLocale(String? rawLocaleCode) {
  if (rawLocaleCode == null || rawLocaleCode.isEmpty) {
    return null;
  }

  for (final locale in AppLocale.values) {
    if (locale.languageCode == rawLocaleCode) {
      return locale;
    }
  }

  return null;
}
