import 'package:material_ui/material_ui.dart';

import '/i18n/strings.g.dart';
import '/infra/app_data_storage/app_data_location.dart';

class AppDataStartupErrorApp extends StatelessWidget {
  final Object error;
  final Future<void> Function() onExit;

  const AppDataStartupErrorApp({super.key, required this.error, required this.onExit});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final labels = tr.storageStartup;
    final failure = error is AppDataException ? error as AppDataException : null;
    final message = switch (failure?.reason) {
      AppDataError.invalidDirectory => labels.invalidDirectory,
      AppDataError.unavailableDirectory => labels.unavailableDirectory,
      AppDataError.unavailableSystemDirectory => labels.unavailableSystemDirectory,
      null => labels.unknown,
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: Scaffold(
        appBar: AppBar(title: Text(labels.title)),
        body: Center(
          child: SingleChildScrollView(
            padding: const .all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                spacing: 16,
                children: [
                  Text(message),
                  if (failure?.path case final String path when path.isNotEmpty)
                    SelectableText(path),
                  Text(labels.hint),
                  Align(
                    alignment: .centerRight,
                    child: FilledButton(onPressed: onExit, child: Text(tr.common.exit)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
