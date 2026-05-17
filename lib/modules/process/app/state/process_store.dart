import 'dart:async';

import 'package:jolt/jolt.dart';

import '../../domain/process.dart';
import '../../infra/repo/process_repo.dart';
import 'process_runtime.dart';

class ProcessStore {
  final ProcessRepo _repo;
  final _executions = <String, ProcessRuntime>{};
  final _processes = ListSignal<Process>([]);
  late final _storedData = AsyncSignal.fromFuture(_restore());

  List<Process> get processes => _processes.value;

  bool get isLoading => _storedData.value.isLoading;

  ProcessStore(this._repo);

  Process? get(String processId) {
    final index = _processes.indexWhere((process) => process.id == processId);

    if (index == -1) return null;

    return _processes[index];
  }

  ProcessStatus getStatus(String processId) {
    return get(processId)?.status.peek ?? ProcessStatus.stopped;
  }

  Future<void> add({
    required String name,
    required ProcessLaunchType launchType,
    required String executable,
    required String arguments,
  }) async {
    final process = Process(
      name: name.trim(),
      launchType: launchType,
      executable: executable.trim(),
      arguments: arguments.trim(),
    );

    await _repo.saveProcess(process);
    _processes.add(process);
  }

  Future<void> edit({
    required String processId,
    required String name,
    required ProcessLaunchType launchType,
    required String executable,
    required String arguments,
  }) async {
    final currentProcess = _getOrThrow(processId);

    final nextProcess = Process(
      id: currentProcess.id,
      name: name.trim(),
      launchType: launchType,
      executable: executable.trim(),
      arguments: arguments.trim(),
    );

    await _repo.saveProcess(nextProcess);
    currentProcess.update((process) {
      process.name.value = nextProcess.name.peek;
      process.launchType.value = nextProcess.launchType.peek;
      process.executable.value = nextProcess.executable.peek;
      process.arguments.value = nextProcess.arguments.peek;
    });
  }

  Future<void> delete(String processId) async {
    await _closeAndRemoveExecutionIfPresent(processId);
    await _repo.deleteProcess(processId);
    _processes.removeWhere((process) => process.id == processId);
  }

  Future<void> start(String processId) async {
    final process = _getOrThrow(processId);
    await _executions.putIfAbsent(process.id, () => ProcessRuntime(process)).start();
  }

  Future<void> stop(String processId) async {
    final process = _getOrThrow(processId);
    final execution = _executions[processId];

    if (execution == null) {
      if (process.status.peek == ProcessStatus.running ||
          process.status.peek == ProcessStatus.starting) {
        process.setStatus(ProcessStatus.stopped);
      }
      return;
    }

    await execution.stop(timeout: _stopTimeout);
  }

  Future<void> dispose() async {
    final processIds = _executions.keys.toList(growable: false);

    for (final processId in processIds) {
      await _closeAndRemoveExecutionIfPresent(processId);
    }

    _storedData.dispose();
  }

  Future<void> _restore() async {
    final storedProcesses = await _repo.getProcesses();
    final currentProcessesById = {for (final process in _processes.peek) process.id: process};
    final nextProcesses = <Process>[];
    final nextProcessIds = <String>{};

    for (final storedProcess in storedProcesses) {
      nextProcessIds.add(storedProcess.id);

      final currentProcess = currentProcessesById[storedProcess.id];

      if (currentProcess == null) {
        nextProcesses.add(storedProcess);
        continue;
      }

      currentProcess.update((process) {
        process.name.value = storedProcess.name.peek;
        process.launchType.value = storedProcess.launchType.peek;
        process.executable.value = storedProcess.executable.peek;
        process.arguments.value = storedProcess.arguments.peek;
      });
      nextProcesses.add(currentProcess);
    }

    for (final process in _processes.peek) {
      if (!nextProcessIds.contains(process.id)) {
        await _closeAndRemoveExecutionIfPresent(process.id);
      }
    }

    _processes.value = nextProcesses;
    await _startAutoProcesses(nextProcesses);
  }

  Process _getOrThrow(String processId) {
    final process = get(processId);

    if (process == null) {
      throw StateError('Process "$processId" not found.');
    }

    return process;
  }

  Future<void> _closeAndRemoveExecutionIfPresent(String processId) async {
    final execution = _executions.remove(processId);

    if (execution == null) return;

    await execution.close(timeout: _stopTimeout);
  }

  Future<void> _startAutoProcesses(Iterable<Process> processes) async {
    for (final process in processes) {
      if (process.launchType.peek != ProcessLaunchType.auto) {
        continue;
      }

      try {
        await start(process.id);
      } catch (_) {
        // Best-effort auto-start. ProcessExecution already updates status and logs.
      }
    }
  }
}

const Duration _stopTimeout = Duration(seconds: 5);
