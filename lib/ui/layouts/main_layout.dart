import 'package:flutter/material.dart';
import 'package:jolt_setup/hooks.dart';
import 'package:jolt_setup/jolt_setup.dart';

import '../../modules/process/process.dart';
import '../../modules/settings/settings.dart';

class MainLayout extends SetupWidget<MainLayout> {
  const MainLayout({super.key});

  @override
  setup(context, props) {
    final selectedIndex = useSignal(0);

    final navigationDestinations = const [
      NavigationRailDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: Text('Home'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: Text('Settings'),
      ),
    ];

    final pages = const [ProcessesScreen(), SettingsScreen()];

    return () {
      final navigationRail = NavigationRail(
        selectedIndex: selectedIndex.value,
        onDestinationSelected: (index) {
          selectedIndex.value = index;
        },
        destinations: navigationDestinations,
        labelType: .none,
        extended: false,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      );

      return Scaffold(
        body: Row(
          children: [
            navigationRail,
            Expanded(child: pages[selectedIndex.value]),
          ],
        ),
      );
    };
  }
}
