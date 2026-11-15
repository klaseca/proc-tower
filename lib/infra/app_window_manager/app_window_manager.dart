import 'dart:async';
import 'dart:io';

import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart'
    show WindowListener, WindowOptions, windowManager;

import '/i18n/strings.g.dart';

class AppWindowManager with WindowListener {
  TrayIcon? _trayIcon;
  Menu? _trayMenu;
  MenuItem? _exitMenuItem;
  var _isExiting = false;
  Future<void> Function()? onExit;

  AppWindowManager._();

  Future<void> _initialize() async {
    await windowManager.ensureInitialized();
    windowManager.addListener(this);
    await windowManager.setPreventClose(true);
    await windowManager.waitUntilReadyToShow(const WindowOptions(center: true));
  }

  @override
  void onWindowClose() async {
    if (!_isExiting) {
      await _hideWindow();
    }
  }

  Future<void> destroy() async {
    if (_isExiting) return;

    _isExiting = true;
    try {
      await onExit?.call();
    } catch (_) {
      _isExiting = false;
      rethrow;
    }
    _destroyTray();
    windowManager.removeListener(this);
    await windowManager.destroy();
  }

  Future<void> launchToTray() async {
    await _hideWindow();
  }

  Future<void> show() async {
    _trayIcon?.setVisible(false);

    if (await windowManager.isMinimized()) {
      await windowManager.restore();
    }

    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> _hideWindow() async {
    _createTray();
    await windowManager.hide();
  }

  void _createTray() {
    if (_trayIcon == null) {
      final iconPath = Platform.isWindows
          ? 'windows/runner/resources/app_icon.ico'
          : 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png';
      final image = ImageAsset.fromAsset(iconPath);

      if (image == null) {
        throw StateError('Could not load the tray icon: $iconPath');
      }

      final trayIcon = TrayIcon.createWithIdentifier('proc_tower');
      final menu = Menu.create();
      final exitItem = MenuItem.createWithLabelAndType(tr.common.exit, MenuItemType.normal);

      if (trayIcon == null || menu == null || exitItem == null) {
        trayIcon?.dispose();
        menu?.dispose();
        exitItem?.dispose();
        image.dispose();
        throw StateError('Could not create the system tray.');
      }

      exitItem.addListener((event) async {
        if (event is MenuItemClickedEvent) {
          await destroy();
        }
      });

      menu.addItem(exitItem);

      trayIcon
        ..icon = image
        ..setTooltip('Proc Tower')
        ..setContextMenu(menu)
        ..setContextMenuTrigger(ContextMenuTrigger.rightClicked)
        ..addListener((event) async {
          if (event is TrayIconClickedEvent && !_isExiting) {
            await show();
          }
        });
      image.dispose();

      _trayIcon = trayIcon;
      _trayMenu = menu;
      _exitMenuItem = exitItem;
    }

    _exitMenuItem!.label = tr.common.exit;
    _trayIcon!.setVisible(true);
  }

  void _destroyTray() {
    _trayIcon?.dispose();
    _trayMenu?.dispose();
    _exitMenuItem?.dispose();
    _trayIcon = null;
    _trayMenu = null;
    _exitMenuItem = null;
  }

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
