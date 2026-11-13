import 'package:jolt_setup/jolt_setup.dart';
import 'package:material_ui/material_ui.dart';
import 'package:trina_grid/trina_grid.dart';

import 'use_processes_data_grid.dart';

class ProcessesDataGrid extends SetupWidget<ProcessesDataGrid> {
  const ProcessesDataGrid({super.key});

  @override
  setup(context, props) {
    final processesDataGrid = useProcessesDataGrid();

    // TrinaGrid still reads the SDK's Material theme and localizations.
    // ignore: deprecated_member_use
    return () => MaterialUiCompatibilityBridge(
      child: TrinaGrid(
        mode: .readOnly,
        onLoaded: processesDataGrid.onLoaded,
        columns: processesDataGrid.columns,
        rowWrapper: processesDataGrid.rowWrapper,
        rows: [],
        configuration: processesDataGrid.configuration(context),
      ),
    );
  }
}
