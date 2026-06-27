import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jolt_setup/jolt_setup.dart';
import 'package:window_manager/window_manager.dart';

import 'i18n/strings.g.dart';
import 'infra/app_window_manager/app_window_manager.dart';
import 'infra/app_window_manager/app_window_manager_bootstrap.dart';
import 'modules/process/process.dart';
import 'modules/settings/settings.dart';
import 'ui/layouts/main_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await LocaleSettings.useDeviceLocale();

  try {
    await settingsStore.restore();
    final preferredLocale = settingsStore.locale.peek;
    if (preferredLocale != null) {
      await LocaleSettings.setLocale(preferredLocale);
    }
  } catch (error) {
    debugPrint('Failed to restore settings: $error');
  }

  final appWindowManager = await AppWindowManager.instance;
  appWindowManager.onExit = () => processStore.dispose();
  await appWindowManager.launchToTray();

  runApp(
    TranslationProvider(
      child: ProviderScope(
        providers: [
          settingsStoreProvider,
          processStoreProvider,
          appWindowManagerProvider(appWindowManager),
        ],
        child: const App(),
      ),
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
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: .dark),
      ),
      themeMode: settingsStore.themeMode.value,
      home: const MainLayout(),
    );
  }
}
