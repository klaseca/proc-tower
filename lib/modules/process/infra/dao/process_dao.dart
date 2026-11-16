import 'dart:convert';
import 'dart:io';

import '/infra/app_data_storage/app_data_storage.dart';

class ProcessDaoRecord {
  final String id;
  final String name;
  final String launchType;
  final String executable;
  final String arguments;
  final Map<String, String> environment;

  const ProcessDaoRecord({
    required this.id,
    required this.name,
    required this.launchType,
    required this.executable,
    required this.arguments,
    this.environment = const {},
  });

  factory ProcessDaoRecord.fromJson(Map<String, dynamic> json) {
    return ProcessDaoRecord(
      id: json['id'] as String,
      name: json['name'] as String,
      launchType: json['launchType'] as String,
      executable: json['executable'] as String,
      arguments: json['arguments'] as String? ?? '',
      environment: Map<String, String>.from(json['environment'] ?? const {}),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'launchType': launchType,
      'executable': executable,
      'arguments': arguments,
      'environment': environment,
    };
  }
}

class ProcessDao {
  final AppDataStorage _storage;

  ProcessDao(this._storage);

  Future<List<ProcessDaoRecord>> getProcesses() {
    return _storage.withFile(AppDataStorage.processesFileName, _readRecords);
  }

  Future<List<ProcessDaoRecord>> _readRecords(File file) async {
    if (!await file.exists()) {
      return [];
    }

    final contents = await file.readAsString();

    if (contents.trim().isEmpty) {
      return [];
    }

    final decoded = jsonDecode(contents) as Map<String, dynamic>;

    final rawProcesses = (decoded['processes'] as List).cast<Map<String, dynamic>>();

    return rawProcesses.map((rawProcess) => ProcessDaoRecord.fromJson(rawProcess)).toList();
  }

  Future<void> deleteProcess(String processId) {
    return _storage.withFile(AppDataStorage.processesFileName, (file) async {
      final records = await _readRecords(file);
      records.removeWhere((process) => process.id == processId);
      await _writeJson(file, records);
    });
  }

  Future<void> saveProcess(ProcessDaoRecord process) {
    return _storage.withFile(AppDataStorage.processesFileName, (file) async {
      final records = await _readRecords(file);

      final index = records.indexWhere((item) => item.id == process.id);

      if (index == -1) {
        records.add(process);
      } else {
        records[index] = process;
      }

      await _writeJson(file, records);
    });
  }

  Future<List<String>> moveProcesses(List<String> processIds, int index) {
    return _storage.withFile(AppDataStorage.processesFileName, (file) async {
      final records = await _readRecords(file);
      final recordsById = {for (final record in records) record.id: record};
      final moved = [for (final id in processIds) ?recordsById.remove(id)];
      final reordered = recordsById.values.toList();
      reordered.insertAll(index.clamp(0, reordered.length), moved);
      await _writeJson(file, reordered);
      return reordered.map((record) => record.id).toList(growable: false);
    });
  }

  Future<void> _writeJson(File file, List<ProcessDaoRecord> records) async {
    await file.parent.create(recursive: true);

    final contents = const JsonEncoder.withIndent('  ')
        .convert({'processes': records.map((record) => record.toJson()).toList(growable: false)});

    await file.writeAsString(contents);
  }
}
