import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:jolt_setup/jolt_setup.dart';
import 'package:window_manager/window_manager.dart';

import 'infra/app_window_manager/app_window_manager.dart';
import 'infra/app_window_manager/app_window_manager_bootstrap.dart';
import 'modules/process/process.dart';
import 'modules/settings/settings.dart';
import 'ui/layouts/main_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  try {
    await settingsStore.restore();
  } catch (error) {
    debugPrint('Failed to restore settings: $error');
  }

  final appWindowManager = await AppWindowManager.instance;
  appWindowManager.onExit = () => processStore.dispose();
  await appWindowManager.launchToTray();

  runApp(
    ProviderScope(
      providers: [settingsStoreProvider, processStoreProvider, appWindowManagerProvider(appWindowManager)],
      child: const App(),
    ),
  );
}

class App extends SetupWidget<App> {
  const App({super.key});

  @override
  setup(context, props) {
    final settingsStore = settingsStoreProvider.of(context);

    return () => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Runner',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: .dark),
      ),
      themeMode: settingsStore.themeMode.value,
      home: const MainLayout(),
    );
  }
}
