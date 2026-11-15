import 'package:disco/disco.dart';
import 'package:jolt_setup/jolt_setup.dart';
import 'package:material_ui/material_ui.dart';

import 'i18n/strings.g.dart';
import 'infra/app_data_storage/app_data_storage.dart';
import 'infra/app_data_storage/app_data_storage_bootstrap.dart';
import 'infra/app_window_manager/app_window_manager.dart';
import 'infra/app_window_manager/app_window_manager_bootstrap.dart';
import 'modules/process/process.dart';
import 'modules/settings/settings.dart';
import 'ui/layouts/main_layout.dart';
import 'ui/screens/app_data_startup_error_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleSettings.useDeviceLocale();
  final appWindowManager = await AppWindowManager.instance;
  final AppDataStorage appDataStorage;

  try {
    appDataStorage = await createAppDataStorage();
  } catch (error) {
    runApp(
      TranslationProvider(
        child: AppDataStartupErrorApp(error: error, onExit: appWindowManager.destroy),
      ),
    );
    await appWindowManager.show();
    return;
  }

  final settingsStore = createSettingsStore(appDataStorage);
  final processStore = createProcessStore(appDataStorage);

  try {
    await settingsStore.restore();
    final preferredLocale = settingsStore.locale.peek;
    if (preferredLocale != null) {
      await LocaleSettings.setLocale(preferredLocale);
    }
  } catch (error) {
    debugPrint('Failed to restore settings: $error');
  }

  appWindowManager.onExit = () => processStore.dispose();
  await appWindowManager.launchToTray();

  runApp(
    TranslationProvider(
      child: ProviderScope(
        providers: [
          settingsStoreProvider(settingsStore),
          processStoreProvider(processStore),
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
