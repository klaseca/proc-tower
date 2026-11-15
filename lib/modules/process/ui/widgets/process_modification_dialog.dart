import 'package:jolt_setup/hooks.dart';
import 'package:jolt_setup/jolt_setup.dart';
import 'package:material_ui/material_ui.dart';

import '/i18n/strings.g.dart';
import '../../app/launch_command_error_message.dart';
import '../../domain/process.dart';
import '../../infra/runtime/launch_command.dart';
import '../process_ui_labels.dart';
import 'process_environment_editor.dart';

class ProcessForm {
  final String name;
  final ProcessLaunchType launchType;
  final String executable;
  final String arguments;
  final Map<String, String> environment;

  ProcessForm({
    required this.name,
    required this.launchType,
    required this.executable,
    required this.arguments,
    Map<String, String> environment = const {},
  }) : environment = Map.unmodifiable(environment);
}

class ProcessModificationDialog extends SetupWidget<ProcessModificationDialog> {
  static const _maxWidth = 1200.0;

  final String dialogTitle;
  final String submitLabel;
  final ProcessForm? initialInput;

  const ProcessModificationDialog({
    super.key,
    required this.dialogTitle,
    required this.submitLabel,
    this.initialInput,
  });

  @override
  setup(context, props) {
    final formKey = GlobalKey<FormState>();
    final nameController = useTextEditingController(text: props().initialInput?.name);
    final executableController = useTextEditingController(text: props().initialInput?.executable);
    final argumentsController = useTextEditingController(text: props().initialInput?.arguments);
    final argumentsText = useSignal(props().initialInput?.arguments ?? '');
    final environmentEntries = useSignal.list<ProcessEnvironmentEntry>([
      for (final entry in props().initialInput?.environment.entries ?? <MapEntry<String, String>>[])
        (key: UniqueKey(), name: entry.key, value: entry.value),
    ]);
    final launchType = useSignal(props().initialInput?.launchType ?? .manual);
    final launchValidation = useComputed<_LaunchValidation>(() {
      try {
        final launchArguments = parseLaunchArguments(
          argumentsText.value,
          environment: environmentEntries.map((entry) => MapEntry(entry.name, entry.value)),
        );

        return (environment: launchArguments.environment, error: null);
      } on LaunchCommandException catch (error) {
        return (environment: const {}, error: error);
      }
    });

    return () {
      final tr = context.tr;
      final theme = Theme.of(context);
      final buttonTextStyle = theme.textTheme.labelLarge?.copyWith(height: 1);
      final cancelButtonStyle = TextButton.styleFrom(
        minimumSize: const Size(120, 40),
        textStyle: buttonTextStyle,
      );
      final submitButtonStyle = FilledButton.styleFrom(
        minimumSize: const Size(120, 40),
        textStyle: buttonTextStyle,
      );
      final validation = launchValidation.value;
      final launchError = validation.error;

      final nameField = TextFormField(
        controller: nameController,
        autofocus: true,
        decoration: InputDecoration(labelText: tr.processes.form.nameLabel),
        validator: (value) =>
            value == null || value.trim().isEmpty ? tr.processes.form.nameRequired : null,
      );

      final launchTypeField = DropdownMenuFormField<ProcessLaunchType>(
        initialSelection: launchType.value,
        expandedInsets: .zero,
        requestFocusOnTap: false,
        label: Text(tr.processes.form.launchTypeLabel),
        inputDecorationTheme: const InputDecorationTheme(),
        dropdownMenuEntries: ProcessLaunchType.values
            .map((type) => DropdownMenuEntry(value: type, label: type.label))
            .toList(growable: false),
        onSelected: (value) {
          if (value != null) launchType.value = value;
        },
      );

      return AlertDialog(
        constraints: const .tightFor(width: _maxWidth),
        scrollable: true,
        title: Text(props().dialogTitle),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            spacing: 16,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return Column(
                      crossAxisAlignment: .stretch,
                      spacing: 16,
                      children: [nameField, launchTypeField],
                    );
                  }

                  return Row(
                    crossAxisAlignment: .start,
                    spacing: 16,
                    children: [
                      Expanded(flex: 3, child: nameField),
                      Expanded(flex: 2, child: launchTypeField),
                    ],
                  );
                },
              ),
              TextFormField(
                controller: executableController,
                decoration: InputDecoration(labelText: tr.processes.form.executableLabel),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return tr.processes.form.executableRequired;
                  }

                  return null;
                },
              ),
              ProcessEnvironmentEditor(entries: environmentEntries),
              Stack(
                children: [
                  TextFormField(
                    controller: argumentsController,
                    onChanged: (value) => argumentsText.value = value,
                    minLines: 5,
                    maxLines: 10,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      labelText: tr.processes.form.argumentsLabel,
                      alignLabelWithHint: true,
                      errorText: launchError == null
                          ? null
                          : launchCommandErrorMessage(launchError, tr),
                      errorMaxLines: 3,
                    ),
                  ),
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    child: Tooltip(
                      message: tr.processes.form.argumentsHint,
                      child: SizedBox.square(
                        dimension: 24,
                        child: Icon(
                          Icons.help_outline,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            width: 120,
            child: TextButton(
              style: cancelButtonStyle,
              onPressed: () => Navigator.of(context).pop(),
              child: Text(tr.common.cancel),
            ),
          ),
          SizedBox(
            width: 120,
            child: FilledButton(
              style: submitButtonStyle,
              onPressed: launchError != null
                  ? null
                  : () {
                      if (!formKey.currentState!.validate()) return;

                      Navigator.of(context).pop(
                        ProcessForm(
                          name: nameController.text.trim(),
                          launchType: launchType.value,
                          executable: executableController.text.trim(),
                          arguments: argumentsController.text.trim(),
                          environment: validation.environment,
                        ),
                      );
                    },
              child: Text(props().submitLabel),
            ),
          ),
        ],
      );
    };
  }
}

typedef _LaunchValidation = ({Map<String, String> environment, LaunchCommandException? error});
