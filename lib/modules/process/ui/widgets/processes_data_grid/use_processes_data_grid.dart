import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jolt_setup/hooks.dart';
import 'package:jolt_setup/jolt_setup.dart';
import 'package:trina_grid/trina_grid.dart';

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
      showError('Не удалось найти процесс.');
      return;
    }

    final updatedProcess = await showDialog<ProcessForm>(
      context: context,
      builder: (dialogContext) => ProcessModificationDialog(
        dialogTitle: 'Редактировать процесс',
        submitLabel: 'Сохранить',
        initialInput: ProcessForm(
          name: existing.name.value,
          launchType: existing.launchType.value,
          startCommand: existing.startCommand.value,
        ),
      ),
    );

    if (updatedProcess == null) return;

    try {
      await processStore.edit(
        processId: processId,
        name: updatedProcess.name,
        launchType: updatedProcess.launchType,
        startCommand: updatedProcess.startCommand,
      );
    } catch (_) {
      showError('Не удалось сохранить процесс.');
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
      isProcessLogsExpanded: isProcessLogsExpanded,
      onToggleProcessLogs: toggleProcessLogs,
      onStartProcess: runProcessAction(
        processStore.start,
        errorMessage: 'Не удалось запустить процесс.',
      ),
      onStopProcess: runProcessAction(
        processStore.stop,
        errorMessage: 'Не удалось остановить процесс.',
      ),
      onEditProcess: editProcess,
      onDeleteProcess: runProcessAction(
        processStore.delete,
        errorMessage: 'Не удалось удалить процесс.',
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
