import 'package:flutter/material.dart';
import 'package:jolt_setup/jolt_setup.dart';

import '/i18n/app_locale_label.dart';
import '/i18n/strings.g.dart';
import '/ui/hooks/use_notification.dart';
import '../../../settings_bootstrap.dart';

class SettingsScreen extends SetupWidget<SettingsScreen> {
  const SettingsScreen({super.key});

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
      final textTheme = Theme.of(context).textTheme;
      final colorScheme = Theme.of(context).colorScheme;

      return Scaffold(
        appBar: AppBar(title: Text(tr.settings.title)),
        body: Padding(
          padding: const .all(16),
          child: SizedBox(
            width: .infinity,
            child: Card(
              margin: .zero,
              child: Padding(
                padding: const .all(16),
                child: Column(
                  crossAxisAlignment: .stretch,
                  mainAxisSize: .min,
                  spacing: 24.0,
                  children: [
                    _WrapSettingsRow(
                      text: Column(
                        crossAxisAlignment: .start,
                        mainAxisSize: .min,
                        spacing: 8,
                        children: [
                          Text(tr.settings.theme.title, style: textTheme.headlineSmall),
                          Text(
                            tr.settings.theme.description,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
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
                            label: Text(tr.settings.theme.system),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            icon: const Icon(Icons.light_mode_outlined),
                            label: Text(tr.settings.theme.light),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            icon: const Icon(Icons.dark_mode_outlined),
                            label: Text(tr.settings.theme.dark),
                          ),
                        ],
                        showSelectedIcon: false,
                      ),
                    ),
                    _WrapSettingsRow(
                      text: Column(
                        crossAxisAlignment: .start,
                        mainAxisSize: .min,
                        spacing: 8,
                        children: [
                          Text(tr.settings.language.title, style: textTheme.headlineSmall),
                          Text(
                            tr.settings.language.description,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      action: DropdownMenuFormField<AppLocale?>(
                        key: ValueKey(settingsStore.locale.value),
                        initialSelection: settingsStore.locale.value,
                        expandedInsets: .zero,
                        requestFocusOnTap: false,
                        label: Text(tr.settings.language.title),
                        inputDecorationTheme: const InputDecorationTheme(),
                        dropdownMenuEntries: localeEntries,
                        onSelected: changeLocale,
                      ),
                    ),
                  ],
                ),
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
  final textMinWidth = 280.0;
  final actionMinWidth = 350.0;
  final actionBasisFraction = 0.3;
  final columnGap = 16.0;
  final rowGap = 12.0;

  const _WrapSettingsRow({
    required this.text,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final actionBasisWidth = availableWidth * actionBasisFraction;
        final actionWidth = actionBasisWidth < actionMinWidth
            ? actionMinWidth
            : actionBasisWidth;
        final textWidth = availableWidth - columnGap - actionWidth;
        final shouldWrap = textWidth < textMinWidth;
        final resolvedTextWidth = shouldWrap ? availableWidth : textWidth;
        final resolvedActionWidth = shouldWrap ? availableWidth : actionWidth;

        return Wrap(
          spacing: columnGap,
          runSpacing: rowGap,
          crossAxisAlignment: .center,
          children: [
            SizedBox(
              width: resolvedTextWidth,
              child: text,
            ),
            SizedBox(
              width: resolvedActionWidth,
              child: SizedBox(
                width: double.infinity,
                child: action,
              ),
            ),
          ],
        );
      },
    );
  }
}
