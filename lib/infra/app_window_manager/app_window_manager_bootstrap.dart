import 'package:disco/disco.dart';

import 'app_window_manager.dart';

final appWindowManagerProvider = Provider.withArgument(
  (_, AppWindowManager appWindowManager) => appWindowManager,
);
