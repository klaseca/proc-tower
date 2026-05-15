import 'package:flutter/material.dart';

import '../../../settings_bootstrap.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = themeProvider.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: Padding(
        padding: const .all(16),
        child: SizedBox(
          width: .infinity,
          child: Card(
            margin: .zero,
            child: Padding(
              padding: const .all(16),
              child: OverflowBar(
                alignment: .spaceBetween,
                overflowAlignment: .start,
                spacing: 24,
                overflowSpacing: 24,
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    mainAxisSize: .min,
                    spacing: 8,
                    children: [
                      Text('Тема приложения', style: textTheme.headlineSmall),
                      Text(
                        'Выбери режим отображения для всего приложения.',
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  SegmentedButton(
                    selected: {themeMode.value},
                    onSelectionChanged: (selection) => themeMode.value = selection.first,
                    segments: [
                      ButtonSegment(
                        value: ThemeMode.system,
                        icon: Icon(Icons.brightness_auto_outlined),
                        label: Text('Система'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        icon: Icon(Icons.light_mode_outlined),
                        label: Text('Светлая'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        icon: Icon(Icons.dark_mode_outlined),
                        label: Text('Тёмная'),
                      ),
                    ],
                    showSelectedIcon: false,
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
