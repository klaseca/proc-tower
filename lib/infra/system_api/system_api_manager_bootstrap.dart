import 'package:disco/disco.dart';

import 'system_api_manager.dart';

final systemApiManagerProvider = Provider.withArgument(
  (_, SystemApiManager systemApiManager) => systemApiManager,
  dispose: (controller) => controller.dispose(),
);
