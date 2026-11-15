import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app_data_location.dart';
import 'app_data_storage.dart';

Future<AppDataStorage> createAppDataStorage() async {
  final portableRoot = _portableRoot();
  final location = await AppDataLocation.resolve(
    environment: Platform.environment,
    portableRoot: portableRoot,
    standardDirectory: getApplicationSupportDirectory,
  );
  return AppDataStorage.create(location);
}

Directory _portableRoot() {
  final executableDirectory = File(Platform.resolvedExecutable).parent;

  if (Platform.isMacOS) {
    final contents = executableDirectory.parent;
    final bundle = contents.parent;

    if (p.basename(contents.path) == 'Contents' && p.extension(bundle.path) == '.app') {
      return bundle.parent;
    }
  }

  return executableDirectory;
}
