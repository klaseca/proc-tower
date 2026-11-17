import 'package:jolt_setup/jolt_setup.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mix/mix.dart';

import '/i18n/app_locale_label.dart';
import '/i18n/strings.g.dart';
import '/ui/hooks/use_notification.dart';
import '/ui/theme/app_styles.dart';
import '../../../settings_bootstrap.dart';

class SettingsScreen extends SetupWidget<SettingsScreen> {
  const SettingsScreen({super.key});

  static final _descriptionStyle = AppStyles.compactColumn.crossAxisAlignment(.start);

  @override
  setup(context, props) {
    final showError = useNotification();
    final settingsStore = settingsStoreProvider.of(context);

    Future<void> changeThemeMode(Set<ThemeMode> selection) async {
      final saveFailedMessage = context.tr.settings.errors.saveFailed;

      try {
        await settingsStore.setThemeMode(selection.first);
      } catch (_) {
        showError(saveFailedMessage);
      }
    }

    Future<void> changeLocale(AppLocale? nextLocale) async {
      final saveFailedMessage = context.tr.settings.errors.saveFailed;

      try {
        await settingsStore.setLocale(nextLocale);

        if (nextLocale == null) {
          await LocaleSettings.useDeviceLocale();
        } else {
          await LocaleSettings.setLocale(nextLocale);
        }
      } catch (_) {
        showError(saveFailedMessage);
      }
    }

    return () {
      final tr = context.tr;
      final localeEntries = [
        DropdownMenuEntry<AppLocale?>(value: null, label: tr.settings.language.system),
        for (final locale in AppLocale.values)
          DropdownMenuEntry<AppLocale?>(value: locale, label: locale.label),
      ];
      final storageLabels = tr.settings.dataDirectory;
      final storageSource = switch (settingsStore.dataDirectorySource) {
        .standard => storageLabels.sourceStandard,
        .portable => storageLabels.sourcePortable,
        .environment => storageLabels.sourceEnvironment,
      };
      final storageHint = switch (settingsStore.dataDirectorySource) {
        .portable => storageLabels.portableHint,
        _ => storageLabels.environmentHint,
      };

      return Scaffold(
        appBar: AppBar(title: StyledText(tr.settings.title)),
        body: SingleChildScrollView(
          child: Box(
            style: AppStyles.page,
            child: Card(
              margin: .zero,
              child: ColumnBox(
                style: AppStyles.panel,
                children: [
                  _WrapSettingsRow(
                    text: ColumnBox(
                      style: _descriptionStyle,
                      children: [
                        StyledText(tr.settings.theme.title, style: AppTextStyles.heading),
                        StyledText(tr.settings.theme.description, style: AppTextStyles.description),
                      ],
                    ),
                    action: SegmentedButton(
                      expandedInsets: EdgeInsets.zero,
                      selected: {settingsStore.themeMode.value},
                      onSelectionChanged: changeThemeMode,
                      segments: [
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: const Icon(Icons.brightness_auto_outlined),
                          label: StyledText(tr.settings.theme.system),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: const Icon(Icons.light_mode_outlined),
                          label: StyledText(tr.settings.theme.light),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: const Icon(Icons.dark_mode_outlined),
                          label: StyledText(tr.settings.theme.dark),
                        ),
                      ],
                      showSelectedIcon: false,
                    ),
                  ),
                  _WrapSettingsRow(
                    text: ColumnBox(
                      style: _descriptionStyle,
                      children: [
                        StyledText(tr.settings.language.title, style: AppTextStyles.heading),
                        StyledText(
                          tr.settings.language.description,
                          style: AppTextStyles.description,
                        ),
                      ],
                    ),
                    action: DropdownMenuFormField<AppLocale?>(
                      key: ValueKey(settingsStore.locale.value),
                      initialSelection: settingsStore.locale.value,
                      expandedInsets: .zero,
                      requestFocusOnTap: false,
                      label: StyledText(tr.settings.language.title),
                      inputDecorationTheme: const InputDecorationTheme(),
                      dropdownMenuEntries: localeEntries,
                      onSelected: changeLocale,
                    ),
                  ),
                  _WrapSettingsRow(
                    text: ColumnBox(
                      style: _descriptionStyle,
                      children: [
                        StyledText(tr.settings.dataDirectory.title, style: AppTextStyles.heading),
                        StyledText(
                          tr.settings.dataDirectory.description,
                          style: AppTextStyles.description,
                        ),
                      ],
                    ),
                    action: ColumnBox(
                      style: AppStyles.compactColumn
                          .crossAxisAlignment(.start)
                          .spacing(AppTokens.mediumSpace()),
                      children: [
                        SelectableText(settingsStore.dataDirectory),
                        StyledText(storageSource),
                        StyledText(storageHint),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    };
  }
}

class _WrapSettingsRow extends StatelessWidget {
  final Widget text;
  final Widget action;

  const _WrapSettingsRow({required this.text, required this.action});

  static const _textMinWidth = 280.0;
  static const _actionMinWidth = 350.0;
  static const _actionBasisFraction = 0.3;
  static final _style = WrapBoxStyler()
      .spacing(AppTokens.largeSpace())
      .runSpacing(AppTokens.mediumSpace())
      .crossAxisAlignment(.center);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final columnGap = AppTokens.largeSpace.resolve(context);
        final actionBasisWidth = availableWidth * _actionBasisFraction;
        final actionWidth = actionBasisWidth < _actionMinWidth ? _actionMinWidth : actionBasisWidth;
        final textWidth = availableWidth - columnGap - actionWidth;
        final shouldWrap = textWidth < _textMinWidth;

        return WrapBox(
          style: _style,
          children: [
            Box(style: BoxStyler().width(shouldWrap ? availableWidth : textWidth), child: text),
            Box(style: BoxStyler().width(shouldWrap ? availableWidth : actionWidth), child: action),
          ],
        );
      },
    );
  }
}
