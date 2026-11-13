import 'dart:async';
import 'dart:io';

import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '/i18n/strings.g.dart';

class AppWindowManager {
  final Window _window;
  late final ListenerId _windowListenerId;
  TrayIcon? _trayIcon;
  Menu? _trayMenu;
  MenuItem? _exitMenuItem;
  var _isExiting = false;
  Future<void> Function()? onExit;

  AppWindowManager._(this._window) {
    _windowListenerId = _window.addListener(_onWindowEvent);
    _window.center();
  }

  void _onWindowEvent(WindowEvent event) {
    if (event is WindowCloseRequestedEvent) {
      event.request.cancel();

      if (!_isExiting) {
        _hideWindow();
      }
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
    _window.removeListener(_windowListenerId);
    _window.close();
  }

  Future<void> launchToTray() async {
    _hideWindow();
  }

  void _showWindow() {
    _trayIcon?.setVisible(false);

    if (_window.isMinimized) {
      _window.restore();
    }

    _window
      ..show()
      ..focus();
  }

  void _hideWindow() {
    _createTray();
    _window.hide();
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
        ..addListener((event) {
          if (event is TrayIconClickedEvent && !_isExiting) {
            _showWindow();
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
    final window = WindowManager.instance.getCurrent();

    if (window == null) {
      throw StateError('Could not find the application window.');
    }

    return AppWindowManager._(window);
  }
}
