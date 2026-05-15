import 'dart:async';
import 'dart:convert';
import 'dart:io';

class ProcessExecution {
  final Process _process;
  final _logController = StreamController<String>();
  final _exitResult = Completer<ProcessExitResult>();
  late final StreamSubscription<String> _stdoutSubscription;
  late final StreamSubscription<String> _stderrSubscription;
  late final StreamSubscription<int> _exitCodeSubscription;
  var _stopRequested = false;
  var _exitHandled = false;

  int get pid => _process.pid;
  Stream<String> get logs => _logController.stream;
  Future<ProcessExitResult> get done => _exitResult.future;

  ProcessExecution._({required Process process}) : _process = process {
    _stdoutSubscription = _process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (line) => _logController.add('OUT: $line'),
          onError: (Object error) => _logController.add('OUT stream error: $error'),
        );

    _stderrSubscription = _process.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (line) => _logController.add('ERR: $line'),
          onError: (Object error) => _logController.add('ERR stream error: $error'),
        );

    _exitCodeSubscription = _process.exitCode.asStream().listen(
      (exitCode) => unawaited(_handleExit(exitCode)),
    );
  }

  static Future<ProcessExecution> start({required LaunchCommand launchCommand}) async {
    final process = await Process.start(
      launchCommand.executable,
      launchCommand.arguments,
      runInShell: false,
    );

    return ProcessExecution._(process: process);
  }

  Future<void> stop({required Duration timeout}) async {
    _stopRequested = true;

    final terminated = await _terminateProcess();

    if (!terminated) {
      _stopRequested = false;
      throw StateError('Process could not be terminated.');
    }

    try {
      await done.timeout(timeout);
    } on TimeoutException {
      _stopRequested = false;
      rethrow;
    }
  }

  Future<void> dispose() async {
    await _cancelOutputSubscriptions();
    await _exitCodeSubscription.cancel();

    if (!_logController.isClosed) {
      await _logController.close();
    }
  }

  Future<void> _handleExit(int exitCode) async {
    if (_exitHandled) return;

    _exitHandled = true;
    await _cancelOutputSubscriptions();

    if (!_exitResult.isCompleted) {
      _exitResult.complete(ProcessExitResult(exitCode: exitCode, stopRequested: _stopRequested));
    }

    if (!_logController.isClosed) {
      await _logController.close();
    }
  }

  Future<void> _cancelOutputSubscriptions() async {
    await _stdoutSubscription.cancel();
    await _stderrSubscription.cancel();
  }

  Future<bool> _terminateProcess() async {
    if (Platform.isWindows) {
      final result = await Process.run('taskkill', ['/PID', '$pid', '/T', '/F']);

      return result.exitCode == 0;
    }

    return _process.kill();
  }
}

class ProcessExitResult {
  final int exitCode;
  final bool stopRequested;

  const ProcessExitResult({required this.exitCode, required this.stopRequested});
}

class LaunchCommand {
  final String executable;
  final List<String> arguments;

  const LaunchCommand({required this.executable, required this.arguments});
}

LaunchCommand buildLaunchCommand(String command) {
  if (command.trim().isEmpty) {
    throw StateError('Start command is empty.');
  }

  if (Platform.isWindows) {
    return LaunchCommand(executable: 'cmd.exe', arguments: ['/c', command]);
  }

  return LaunchCommand(executable: '/bin/sh', arguments: ['-lc', 'exec $command']);
}
