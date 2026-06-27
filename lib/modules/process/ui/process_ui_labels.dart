import '/i18n/strings.g.dart';
import '../domain/process.dart';

extension ProcessStatusLabel on ProcessStatus {
  String get label => switch (this) {
    ProcessStatus.running => tr.processes.status.running,
    ProcessStatus.starting => tr.processes.status.starting,
    ProcessStatus.stopped => tr.processes.status.stopped,
    ProcessStatus.failed => tr.processes.status.failed,
  };
}

extension ProcessLaunchTypeLabel on ProcessLaunchType {
  String get label => switch (this) {
    ProcessLaunchType.auto => tr.processes.launchType.auto,
    ProcessLaunchType.manual => tr.processes.launchType.manual,
  };
}
