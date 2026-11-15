import 'dart:io';

import 'package:path/path.dart' as p;

enum AppDataSource { standard, portable, environment }

enum AppDataError { invalidDirectory, unavailableDirectory, unavailableSystemDirectory }

class AppDataException implements Exception {
  final AppDataError reason;
  final String? path;

  const AppDataException(this.reason, {this.path});
}

class AppDataLocation {
  final Directory directory;
  final AppDataSource source;

  const AppDataLocation({required this.directory, required this.source});

  static Future<AppDataLocation> resolve({
    required Map<String, String> environment,
    required Directory portableRoot,
    required Future<Directory> Function() standardDirectory,
  }) async {
    final marker = File(p.join(portableRoot.path, 'portable.flag'));

    if (await marker.exists()) {
      return AppDataLocation(
        directory: Directory(p.join(portableRoot.path, 'app_data')),
        source: AppDataSource.portable,
      );
    }

    final environmentPath = environment['PROC_TOWER_DATA_DIR'];

    if (environmentPath != null) {
      _validateAbsolutePath(environmentPath);
      return AppDataLocation(
        directory: Directory(p.normalize(environmentPath)),
        source: AppDataSource.environment,
      );
    }

    final Directory directory;

    try {
      directory = await standardDirectory();
    } catch (_) {
      throw const AppDataException(AppDataError.unavailableSystemDirectory);
    }

    _validateAbsolutePath(directory.path);
    return AppDataLocation(directory: directory, source: AppDataSource.standard);
  }

  static void _validateAbsolutePath(String path) {
    if (path.trim().isEmpty || !p.isAbsolute(path) || path.contains('\u0000')) {
      throw AppDataException(AppDataError.invalidDirectory, path: path);
    }
  }
}
