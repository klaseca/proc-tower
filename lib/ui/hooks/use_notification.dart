import 'package:jolt_setup/hooks.dart';
import 'package:jolt_setup/jolt_setup.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mix/mix.dart';

@defineHook
void Function(String) useNotification() {
  final context = useContext();
  final messenger = ScaffoldMessenger.of(context);

  return (message) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: StyledText(message)));
  };
}
