import 'dart:async';

import '../../domain/process.dart';
import '../../infra/runtime/process_execution.dart';

class ProcessRuntime {
  final Process _process;
  Future<void>? _closeFuture;
  ProcessExecution? _runningHandle;
  StreamSubscription<String>? _logsSubscription;

  ProcessRuntime(this._process);

  Future<void> start() async {
    if (_runningHandle != null || _process.status.peek == ProcessStatus.starting) {
      return;
    }

    _process.setStatus(ProcessStatus.starting);
    _process.appendLog('START ${_process.name.peek}');
    _process.appendLog('EXEC: ${_process.executable.peek}');
    if (_process.arguments.peek.isNotEmpty) {
      _process.appendLog('ARGS: ${_process.arguments.peek}');
    }

    try {
      final runningHandle = await ProcessExecution.start(
        launchCommand: buildLaunchCommand(
          executable: _process.executable.peek,
          arguments: _process.arguments.peek,
        ),
      );

      _runningHandle = runningHandle;
      _logsSubscription = runningHandle.logs.listen(_process.appendLog);
      unawaited(
        runningHandle.done.then(
          (exitResult) => _handleExit(
            handle: runningHandle,
            exitResult: exitResult,
          ),
        ),
      );

      _process.appendLog('PID: ${runningHandle.pid}');
      _process.appendLog('Process started successfully.');
      _process.setStatus(ProcessStatus.running);
    } catch (error) {
      await _disposeRunningHandle();
      _process.appendLog('START FAILED: $error');
      _process.setStatus(ProcessStatus.failed);
      rethrow;
    }
  }

  Future<void> stop({required Duration timeout}) async {
    final runningHandle = _runningHandle;

    if (runningHandle == null) {
      if (_process.status.peek == ProcessStatus.running ||
          _process.status.peek == ProcessStatus.starting) {
        _process.setStatus(ProcessStatus.stopped);
      }
      return;
    }

    _process.appendLog('STOP ${_process.name.peek}');

    try {
      await runningHandle.stop(timeout: timeout);
    } on TimeoutException {
      _process.appendLog('STOP FAILED: process did not exit in time.');
      throw StateError('Process "${_process.id}" did not stop in time.');
    } on StateError {
      _process.appendLog('STOP FAILED: unable to terminate process.');
      rethrow;
    }
  }

  Future<void> close({required Duration timeout}) {
    return _closeFuture ??= _closeInternal(timeout: timeout);
  }

  Future<void> _closeInternal({required Duration timeout}) async {
    final runningHandle = _runningHandle;

    if (runningHandle != null) {
      try {
        await stop(timeout: timeout);
      } on TimeoutException {
        // Best-effort cleanup on app shutdown or process removal.
      } on StateError {
        // Best-effort cleanup on app shutdown or process removal.
      }

      await _disposeRunningHandle();
    }
  }

  Future<void> _handleExit({
    required ProcessExecution handle,
    required ProcessExitResult exitResult,
  }) async {
    await _disposeRunningHandle(handle: handle);

    _process.appendLog('EXIT ${_process.name.peek} code=${exitResult.exitCode}');

    if (exitResult.stopRequested || exitResult.exitCode == 0) {
      _process.setStatus(ProcessStatus.stopped);
    } else {
      _process.setStatus(ProcessStatus.failed);
    }
  }

  Future<void> _disposeRunningHandle({ProcessExecution? handle}) async {
    final activeHandle = handle ?? _runningHandle;

    if (activeHandle == null) return;
    if (handle != null && !identical(_runningHandle, handle)) return;

    final logsSubscription = _logsSubscription;
    _logsSubscription = null;
    _runningHandle = null;

    await logsSubscription?.cancel();
    await activeHandle.dispose();
  }
}
