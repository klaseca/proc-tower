import '../../domain/process.dart';
import '../dao/process_dao.dart';

abstract final class ProcessMapper {
  static Process toDomain(ProcessDaoRecord record) {
    return Process(
      id: record.id,
      name: record.name,
      launchType: _parseLaunchType(record.launchType),
      startCommand: record.startCommand,
    );
  }

  static ProcessDaoRecord toDao(Process process) {
    return ProcessDaoRecord(
      id: process.id,
      name: process.name.peek,
      launchType: process.launchType.peek.name,
      startCommand: process.startCommand.peek,
    );
  }

  static ProcessLaunchType _parseLaunchType(String launchType) {
    return switch (launchType) {
      'auto' => ProcessLaunchType.auto,
      'manual' => ProcessLaunchType.manual,
      _ => ProcessLaunchType.manual,
    };
  }
}
