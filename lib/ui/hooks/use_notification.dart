import 'package:jolt_setup/hooks.dart';
import 'package:jolt_setup/jolt_setup.dart';
import 'package:material_ui/material_ui.dart';

@defineHook
void Function(String) useNotification() {
  final context = useContext();
  final messenger = ScaffoldMessenger.of(context);

  return (message) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  };
}
