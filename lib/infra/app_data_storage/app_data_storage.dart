import 'dart:io';

import 'package:path/path.dart' as p;

import 'app_data_location.dart';

class AppDataStorage {
  static const settingsFileName = 'settings.json';
  static const processesFileName = 'processes.json';

  final Directory directory;
  final AppDataSource source;
  Future<void> _pending = Future.value();

  AppDataStorage._(this.directory, this.source);

  static Future<AppDataStorage> create(AppDataLocation location) async {
    final directory = location.directory;

    try {
      if (location.source == AppDataSource.environment) {
        if (!await directory.exists()) {
          throw AppDataException(AppDataError.unavailableDirectory, path: directory.path);
        }
      } else {
        await directory.create(recursive: true);
      }
    } catch (_) {
      throw AppDataException(AppDataError.unavailableDirectory, path: directory.path);
    }

    return AppDataStorage._(directory, location.source);
  }

  Future<T> withFile<T>(String name, Future<T> Function(File file) action) {
    final result = _pending.then((_) => action(File(p.join(directory.path, name))));
    _pending = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }
}
