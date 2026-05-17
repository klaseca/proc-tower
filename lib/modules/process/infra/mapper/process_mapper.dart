import '../../domain/process.dart';
import '../dao/process_dao.dart';

abstract final class ProcessMapper {
  static Process toDomain(ProcessDaoRecord record) {
    return Process(
      id: record.id,
      name: record.name,
      launchType: _parseLaunchType(record.launchType),
      executable: record.executable,
      arguments: record.arguments,
    );
  }

  static ProcessDaoRecord toDao(Process process) {
    return ProcessDaoRecord(
      id: process.id,
      name: process.name.peek,
      launchType: process.launchType.peek.name,
      executable: process.executable.peek,
      arguments: process.arguments.peek,
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
