import 'package:jolt/jolt.dart';
import 'package:nanoid2/nanoid2.dart';

import 'process_logs.dart';

class Process {
  final String id;
  final Signal<String> name;
  final Signal<ProcessLaunchType> launchType;
  final Signal<String> startCommand;
  final Signal<ProcessStatus> status;
  final ProcessLogs logs;

  Process({
    String? id,
    required String name,
    ProcessLaunchType launchType = ProcessLaunchType.manual,
    required String startCommand,
    ProcessStatus status = ProcessStatus.stopped,
  }) : id = id ?? nanoid(),
       name = Signal(name),
       launchType = Signal(launchType),
       startCommand = Signal(startCommand),
       status = Signal(status),
       logs = ProcessLogs();

  void update(void Function(Process) apply) {
    batch(() => apply(this));
  }

  void setStatus(ProcessStatus nextStatus) {
    status.value = nextStatus;
  }

  void appendLog(String message, {DateTime? timestamp}) {
    logs.append(message, timestamp: timestamp);
  }
}

enum ProcessStatus { running, starting, stopped, failed }

enum ProcessLaunchType { auto, manual }
