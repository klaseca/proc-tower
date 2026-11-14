import 'package:jolt/jolt.dart';
import 'package:jolt_setup/jolt_setup.dart';
import 'package:material_ui/material_ui.dart';

import '/i18n/strings.g.dart';

import 'process_form_section_title.dart';

class ProcessEnvironmentEditor extends SetupWidget<ProcessEnvironmentEditor> {
  final ListSignal<ProcessEnvironmentEntry> entries;

  const ProcessEnvironmentEditor({super.key, required this.entries});

  @override
  setup(context, props) {
    void updateRow(Key key, {String? name, String? value}) {
      final rows = props().entries;
      final index = rows.peek.indexWhere((row) => row.key == key);
      final row = rows.peek[index];
      rows[index] = (key: key, name: name ?? row.name, value: value ?? row.value);
    }

    return () {
      final labels = context.tr.processes.form;
      final rows = props().entries;

      return Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        spacing: 8,
        children: [
          ProcessFormSectionTitle(
            title: labels.environmentTitle,
            tooltip: labels.environmentDescription,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          for (final row in rows)
            Row(
              key: row.key,
              crossAxisAlignment: .center,
              spacing: 8,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: row.name,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(labelText: labels.environmentNameLabel),
                    onChanged: (value) => updateRow(row.key, name: value),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: row.value,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(labelText: labels.environmentValueLabel),
                    onChanged: (value) => updateRow(row.key, value: value),
                  ),
                ),
                Padding(
                  padding: const .only(top: 16),
                  child: IconButton(
                    tooltip: labels.environmentRemove,
                    onPressed: () {
                      rows.removeWhere((current) => current.key == row.key);
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                ),
              ],
            ),
          Align(
            alignment: .centerLeft,
            child: TextButton.icon(
              onPressed: () {
                rows.add((key: UniqueKey(), name: '', value: ''));
              },
              icon: const Icon(Icons.add),
              label: Text(labels.environmentAdd),
            ),
          ),
        ],
      );
    };
  }
}

typedef ProcessEnvironmentEntry = ({Key key, String name, String value});
