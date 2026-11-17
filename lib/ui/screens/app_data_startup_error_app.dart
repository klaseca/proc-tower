import 'package:material_ui/material_ui.dart';
import 'package:mix/mix.dart';

import '/i18n/strings.g.dart';
import '/infra/app_data_storage/app_data_location.dart';
import '/ui/theme/app_styles.dart';

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
      builder: (_, child) => AppStyleScope(child: child!),
      home: Scaffold(
        appBar: AppBar(title: StyledText(labels.title)),
        body: Box(
          style: BoxStyler().alignment(.center),
          child: SingleChildScrollView(
            child: Box(
              style: BoxStyler().padding(.all(AppTokens.sectionSpace())).maxWidth(688),
              child: ColumnBox(
                style: AppStyles.form,
                children: [
                  StyledText(message),
                  if (failure?.path case final String path when path.isNotEmpty)
                    SelectableText(path),
                  StyledText(labels.hint),
                  Box(
                    style: AppStyles.alignEnd,
                    child: FilledButton(onPressed: onExit, child: StyledText(tr.common.exit)),
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
