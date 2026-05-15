import '../domain/process.dart';

extension ProcessStatusLabel on ProcessStatus {
  String get label => switch (this) {
    ProcessStatus.running => 'Работает',
    ProcessStatus.starting => 'Запускается',
    ProcessStatus.stopped => 'Остановлен',
    ProcessStatus.failed => 'Ошибка',
  };
}

extension ProcessLaunchTypeLabel on ProcessLaunchType {
  String get label => switch (this) {
    ProcessLaunchType.auto => 'Авто',
    ProcessLaunchType.manual => 'Ручной',
  };
}
