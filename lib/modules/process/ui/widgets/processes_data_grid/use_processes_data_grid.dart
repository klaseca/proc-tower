import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jolt_setup/hooks.dart';
import 'package:jolt_setup/jolt_setup.dart';
import 'package:trina_grid/trina_grid.dart';

import '/i18n/strings.g.dart';
import '/ui/hooks/use_notification.dart';
import '../../../process_bootstrap.dart';
import '../../widgets/process_modification_dialog.dart';
import 'processes_data_grid_helpers.dart';

@defineHook
UseProcessesDataGrid useProcessesDataGrid() {
  final showError = useNotification();
  final context = useContext();
  final processStore = processStoreProvider.of(context);
  final gridStateManager = useSignal<TrinaGridStateManager?>(null);
  final expandedProcessIds = useSignal.set<String>({});

  Future<void> Function(ProcessColumnRendererContext) runProcessAction(
    Future<void> Function(String) action, {
    required String errorMessage,
  }) {
    return (rendererContext) async {
      try {
        await action(rendererContext.data.id);
      } catch (_) {
        showError(errorMessage);
      }
    };
  }

  Future<void> editProcess(ProcessColumnRendererContext rendererContext) async {
    final processId = rendererContext.data.id;
    final existing = processStore.get(processId);

    if (existing == null) {
      showError(context.tr.processes.errors.notFound);
      return;
    }

    final saveFailedMessage = context.tr.processes.errors.saveFailed;

    final updatedProcess = await showDialog<ProcessForm>(
      context: context,
      builder: (_) => ProcessModificationDialog(
        dialogTitle: context.tr.processes.dialog.editTitle,
        submitLabel: context.tr.common.save,
        initialInput: ProcessForm(
          name: existing.name.value,
          launchType: existing.launchType.value,
          executable: existing.executable.value,
          arguments: existing.arguments.value,
        ),
      ),
    );

    if (updatedProcess == null) return;

    try {
      await processStore.edit(
        processId: processId,
        name: updatedProcess.name,
        launchType: updatedProcess.launchType,
        executable: updatedProcess.executable,
        arguments: updatedProcess.arguments,
      );
    } catch (_) {
      showError(saveFailedMessage);
    }
  }

  useEffect(() {
    gridStateManager.value?.setShowLoading(processStore.isLoading);
  });

  useEffect(() {
    final stateManager = gridStateManager.value;

    if (stateManager == null) return;

    final availableProcessIds = processStore.processes.map((process) => process.id).toSet();
    expandedProcessIds.retainAll(availableProcessIds);

    final rows = createProcessesDataGridRows(processStore.processes, stateManager.columns);

    if (rows.isEmpty) {
      return stateManager.removeAllRows();
    }

    stateManager
      ..removeAllRows(notify: false)
      ..appendRows(rows);
  });

  useWatcher(
    () => [
      for (final process in processStore.processes)
        if (expandedProcessIds.contains(process.id)) process.logs.entries.length,
    ],
    (_, _) {
      gridStateManager.value?.notifyListeners();
    },
  );

  bool isProcessLogsExpanded(String processId) => expandedProcessIds.contains(processId);

  void toggleProcessLogs(String processId) {
    if (!expandedProcessIds.remove(processId)) {
      expandedProcessIds.add(processId);
    }
  }

  return (
    onLoaded: (event) {
      gridStateManager.value = event.stateManager;
      event.stateManager
        ..setConfiguration(createProcessesDataGridConfiguration(context, true))
        ..notifyListeners();
    },
    columns: createProcessesDataGridColumns(
      tr: context.tr,
      isProcessLogsExpanded: isProcessLogsExpanded,
      onToggleProcessLogs: toggleProcessLogs,
      onStartProcess: runProcessAction(
        processStore.start,
        errorMessage: context.tr.processes.errors.startFailed,
      ),
      onStopProcess: runProcessAction(
        processStore.stop,
        errorMessage: context.tr.processes.errors.stopFailed,
      ),
      onClearProcessLogs: (rendererContext) {
        rendererContext.data.logs.clear();
      },
      onEditProcess: editProcess,
      onDeleteProcess: runProcessAction(
        processStore.delete,
        errorMessage: context.tr.processes.errors.deleteFailed,
      ),
    ),
    rowWrapper: createProcessesDataGridRowWrapper(isProcessLogsExpanded),
    configuration: (context) =>
        createProcessesDataGridConfiguration(context, gridStateManager.value != null),
  );
}

typedef UseProcessesDataGrid = ({
  TrinaOnLoadedEventCallback onLoaded,
  List<TrinaColumn> columns,
  RowWrapper rowWrapper,
  TrinaGridConfiguration Function(BuildContext) configuration,
});
