import 'dart:async';
import 'dart:io';

import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class AppWindowManager with TrayListener, WindowListener {
  var _isExiting = false;
  var _hasTray = false;
  Future<void> Function()? onExit;

  AppWindowManager._();

  @override
  void onTrayIconMouseDown() async {
    await _showWindow();
  }

  @override
  void onTrayIconRightMouseDown() async {
    // ignore: deprecated_member_use
    await trayManager.popUpContextMenu(bringAppToFront: Platform.isWindows);
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key) {
      case _exitAppMenuItemKey:
        await destroy();
    }
  }

  @override
  void onWindowClose() async {
    if (_isExiting) {
      return;
    }

    await _hideWindow();
  }

  Future<void> destroy() async {
    _isExiting = true;
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    await onExit?.call();
    await _destroyTray();
    await windowManager.destroy();
  }

  Future<void> launchToTray() async {
    await _createTray();
  }

  Future<void> _initialize() async {
    trayManager.addListener(this);
    windowManager.addListener(this);
    await windowManager.setPreventClose(true);
    await windowManager.waitUntilReadyToShow(WindowOptions(center: true));
  }

  Future<void> _showWindow() async {
    await _destroyTray();

    if (await windowManager.isMinimized()) {
      await windowManager.restore();
    }

    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> _hideWindow() async {
    await _createTray();
    await windowManager.hide();
  }

  Future<void> _createTray() async {
    if (_hasTray) {
      return;
    }

    await trayManager.setIcon(
      Platform.isWindows
          ? 'windows/runner/resources/app_icon.ico'
          : 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png',
    );

    if (!Platform.isLinux) {
      await trayManager.setToolTip('proc-tower');
    }

    await trayManager.setContextMenu(
      Menu(
        items: [MenuItem(key: _exitAppMenuItemKey, label: 'Выход')],
      ),
    );

    _hasTray = true;
  }

  Future<void> _destroyTray() async {
    if (!_hasTray) {
      return;
    }

    await trayManager.destroy();
    _hasTray = false;
  }

  static const _exitAppMenuItemKey = 'exit_app';

  static Future<AppWindowManager>? _instance;

  static Future<AppWindowManager> get instance {
    return _instance ??= _create();
  }

  static Future<AppWindowManager> _create() async {
    final controller = AppWindowManager._();
    await controller._initialize();
    return controller;
  }
}
