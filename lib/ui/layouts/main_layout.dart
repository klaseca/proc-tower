import 'package:flutter/material.dart';
import 'package:jolt_setup/hooks.dart';
import 'package:jolt_setup/jolt_setup.dart';

import '/i18n/strings.g.dart';
import '/modules/process/process.dart';
import '/modules/settings/settings.dart';

class MainLayout extends SetupWidget<MainLayout> {
  const MainLayout({super.key});

  @override
  setup(context, props) {
    final selectedIndex = useSignal(0);
    final pages = const [ProcessesScreen(), SettingsScreen()];

    return () {
      final tr = context.tr;
      final navigationDestinations = [
        NavigationRailDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: Text(tr.app.navigation.processes),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: Text(tr.app.navigation.settings),
        ),
      ];

      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex.value,
              onDestinationSelected: (index) {
                selectedIndex.value = index;
              },
              destinations: navigationDestinations,
              labelType: .none,
              extended: false,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            ),
            Expanded(child: pages[selectedIndex.value]),
          ],
        ),
      );
    };
  }
}
