import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jolt_setup/jolt_setup.dart';

import '/ui/hooks/use_notification.dart';
import '../../../process_bootstrap.dart';
import '../../widgets/process_modification_dialog.dart';
import '../../widgets/processes_data_grid/processes_data_grid.dart';

class ProcessesScreen extends SetupWidget<ProcessesScreen> {
  const ProcessesScreen({super.key});

  @override
  setup(context, props) {
    final showError = useNotification();

    final processStore = processStoreProvider.of(context);

    Future<void> addProcess() async {
      final process = await showDialog<ProcessForm>(
        context: context,
        builder: (_) =>
            ProcessModificationDialog(dialogTitle: 'Добавить процесс', submitLabel: 'Добавить'),
      );

      if (process == null) return;

      try {
        await processStore.add(
          name: process.name,
          launchType: process.launchType,
          startCommand: process.startCommand,
        );
      } catch (_) {
        showError('Не удалось добавить процесс.');
      }
    }

    return () => Scaffold(
      appBar: AppBar(
        title: const Text('Процессы'),
        actions: [
          FilledButton.icon(
            onPressed: processStore.isLoading ? null : addProcess,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Добавить'),
          ),
        ],
        actionsPadding: const .symmetric(horizontal: 16),
      ),
      body: const Padding(padding: .all(16), child: ProcessesDataGrid()),
    );
  }
}
