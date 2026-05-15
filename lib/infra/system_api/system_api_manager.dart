import 'dart:async';
import 'dart:io';

import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class SystemApiManager with TrayListener, WindowListener {
  var _isDisposed = false;
  var _isExiting = false;
  var _hasTray = false;

  SystemApiManager._();

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
        await _exitApp();
    }
  }

  @override
  void onWindowClose() async {
    if (_isExiting) {
      return;
    }

    await _hideWindow();
  }

  Future<void> dispose() async {
    _isDisposed = true;
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    await _destroyTray();
  }

  Future<void> launchToTray() async {
    await windowManager.waitUntilReadyToShow(null, () => unawaited(_createTray()));
  }

  Future<void> _initialize() async {
    if (_isDisposed) return;

    trayManager.addListener(this);
    windowManager.addListener(this);
    await windowManager.setPreventClose(true);
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

  Future<void> _exitApp() async {
    _isExiting = true;
    await _destroyTray();
    await windowManager.destroy();
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

  static Future<SystemApiManager>? _instance;

  static Future<SystemApiManager> get instance {
    return _instance ??= _create();
  }

  static Future<SystemApiManager> _create() async {
    final controller = SystemApiManager._();
    await controller._initialize();
    return controller;
  }
}
