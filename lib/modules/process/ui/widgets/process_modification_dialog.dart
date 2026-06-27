import 'package:flutter/material.dart';
import 'package:jolt_setup/hooks.dart';
import 'package:jolt_setup/jolt_setup.dart';

import '/i18n/strings.g.dart';
import '../../domain/process.dart';
import '../process_ui_labels.dart';

class ProcessForm {
  final String name;
  final ProcessLaunchType launchType;
  final String executable;
  final String arguments;

  const ProcessForm({
    required this.name,
    required this.launchType,
    required this.executable,
    required this.arguments,
  });
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
    final executableController = useTextEditingController(text: props().initialInput?.executable);
    final argumentsController = useTextEditingController(text: props().initialInput?.arguments);
    final launchType = useSignal(props().initialInput?.launchType ?? .manual);

    return () {
      final tr = context.tr;
      final buttonTextStyle = Theme.of(context).textTheme.labelLarge?.copyWith(height: 1);
      final cancelButtonStyle = TextButton.styleFrom(
        minimumSize: const Size(120, 40),
        textStyle: buttonTextStyle,
      );
      final submitButtonStyle = FilledButton.styleFrom(
        minimumSize: const Size(120, 40),
        textStyle: buttonTextStyle,
      );

      return AlertDialog(
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
                  decoration: InputDecoration(labelText: tr.processes.form.nameLabel),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return tr.processes.form.nameRequired;
                    }

                    return null;
                  },
                ),
                DropdownMenuFormField<ProcessLaunchType>(
                  initialSelection: launchType.value,
                  expandedInsets: .zero,
                  requestFocusOnTap: false,
                  label: Text(tr.processes.form.launchTypeLabel),
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
                  controller: executableController,
                  decoration: InputDecoration(labelText: tr.processes.form.executableLabel),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return tr.processes.form.executableRequired;
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: argumentsController,
                  minLines: 5,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: tr.processes.form.argumentsLabel,
                    alignLabelWithHint: true,
                  ),
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
              child: Text(tr.common.cancel),
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
                    executable: executableController.text.trim(),
                    arguments: argumentsController.text.trim(),
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
