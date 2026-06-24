import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class SettingsDao {
  final _file = _initFile();

  Future<ThemeMode> getThemeMode() async {
    try {
      if (!await _file.exists()) {
        return ThemeMode.system;
      }

      final contents = await _file.readAsString();

      if (contents.trim().isEmpty) {
        return ThemeMode.system;
      }

      final decoded = jsonDecode(contents) as Map<String, dynamic>;
      final rawThemeMode = decoded['themeMode'] as String?;

      return ThemeMode.values.firstWhere(
        (themeMode) => themeMode.name == rawThemeMode,
        orElse: () => ThemeMode.system,
      );
    } on FileSystemException {
      return ThemeMode.system;
    } on FormatException {
      return ThemeMode.system;
    }
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    await _file.parent.create(recursive: true);

    final contents = const JsonEncoder.withIndent('  ').convert({
      'themeMode': themeMode.name,
    });

    await _file.writeAsString(contents);
  }

  static File _initFile() {
    final directory = File(Platform.resolvedExecutable).parent;
    final filePath = '${directory.path}${Platform.pathSeparator}settings.json';
    return File(filePath);
  }
}
