import 'package:flutter/material.dart';
import 'package:jolt_setup/hooks.dart';
import 'package:jolt_setup/jolt_setup.dart';

import '../../domain/process.dart';
import '../process_ui_labels.dart';

class ProcessForm {
  final String name;
  final ProcessLaunchType launchType;
  final String startCommand;

  const ProcessForm({required this.name, required this.launchType, required this.startCommand});
}

class ProcessModificationDialog extends SetupWidget<ProcessModificationDialog> {
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
    final commandController = useTextEditingController(text: props().initialInput?.startCommand);
    final launchType = useSignal(props().initialInput?.launchType ?? .manual);
    final buttonTextStyle = Theme.of(context).textTheme.labelLarge?.copyWith(height: 1);
    final cancelButtonStyle = TextButton.styleFrom(
      minimumSize: const Size(120, 40),
      textStyle: buttonTextStyle,
    );
    final submitButtonStyle = FilledButton.styleFrom(
      minimumSize: const Size(120, 40),
      textStyle: buttonTextStyle,
    );

    return () => AlertDialog(
      constraints: const BoxConstraints(maxWidth: 1200),
      scrollable: true,
      title: Text(props().dialogTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            spacing: 16,
            children: [
              TextFormField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Укажи название процесса';
                  }

                  return null;
                },
              ),
              DropdownMenuFormField(
                initialSelection: launchType.value,
                expandedInsets: .zero,
                label: const Text('Тип запуска'),
                inputDecorationTheme: const InputDecorationTheme(),
                dropdownMenuEntries: ProcessLaunchType.values
                    .map((type) => DropdownMenuEntry(value: type, label: type.label))
                    .toList(growable: false),
                onSelected: (value) {
                  if (value != null) {
                    launchType.value = value;
                  }
                },
              ),
              TextFormField(
                controller: commandController,
                minLines: 5,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Команда запуска',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Укажи команду запуска';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: 120,
          child: TextButton(
            style: cancelButtonStyle,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
        ),
        SizedBox(
          width: 120,
          child: FilledButton(
            style: submitButtonStyle,
            onPressed: () {
              if (!formKey.currentState!.validate()) return;

              Navigator.of(context).pop(
                ProcessForm(
                  name: nameController.text.trim(),
                  launchType: launchType.value,
                  startCommand: commandController.text.trim(),
                ),
              );
            },
            child: Text(props().submitLabel),
          ),
        ),
      ],
    );
  }
}
