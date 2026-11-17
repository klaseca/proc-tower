import 'package:jolt/jolt.dart';
import 'package:jolt_setup/jolt_setup.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mix/mix.dart';

import '/i18n/strings.g.dart';
import '/ui/theme/app_styles.dart';

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

      return ColumnBox(
        style: AppStyles.compactColumn,
        children: [
          ProcessFormSectionTitle(
            title: labels.environmentTitle,
            tooltip: labels.environmentDescription,
          ),
          for (final row in rows)
            RowBox(
              key: row.key,
              style: AppStyles.row,
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
                Box(
                  style: BoxStyler().padding(.only(top: AppTokens.largeSpace())),
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
          Box(
            style: AppStyles.alignStart,
            child: TextButton.icon(
              onPressed: () {
                rows.add((key: UniqueKey(), name: '', value: ''));
              },
              icon: const Icon(Icons.add),
              label: StyledText(labels.environmentAdd),
            ),
          ),
        ],
      );
    };
  }
}

typedef ProcessEnvironmentEntry = ({Key key, String name, String value});
