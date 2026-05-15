import 'dart:convert';
import 'dart:io';

class ProcessDaoRecord {
  final String id;
  final String name;
  final String launchType;
  final String startCommand;

  const ProcessDaoRecord({
    required this.id,
    required this.name,
    required this.launchType,
    required this.startCommand,
  });

  factory ProcessDaoRecord.fromJson(Map<String, dynamic> json) {
    return ProcessDaoRecord(
      id: json['id'] as String,
      name: json['name'] as String,
      launchType: json['launchType'] as String,
      startCommand: json['startCommand'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'name': name, 'launchType': launchType, 'startCommand': startCommand};
  }
}

class ProcessDao {
  final _file = _initFile();

  Future<List<ProcessDaoRecord>> getProcesses() async {
    if (!await _file.exists()) {
      return [];
    }

    final contents = await _file.readAsString();

    if (contents.trim().isEmpty) {
      return [];
    }

    final decoded = jsonDecode(contents) as Map<String, dynamic>;

    final rawProcesses = (decoded['processes'] as List).cast<Map<String, dynamic>>();

    return rawProcesses.map((rawProcess) => ProcessDaoRecord.fromJson(rawProcess)).toList();
  }

  Future<void> deleteProcess(String processId) async {
    final records = await getProcesses();

    records.removeWhere((process) => process.id == processId);

    await _writeJson(records);
  }

  Future<void> saveProcess(ProcessDaoRecord process) async {
    final records = await getProcesses();

    final index = records.indexWhere((item) => item.id == process.id);

    if (index == -1) {
      records.add(process);
    } else {
      records[index] = process;
    }

    await _writeJson(records);
  }

  Future<void> _writeJson(List<ProcessDaoRecord> records) async {
    await _file.parent.create(recursive: true);

    final contents = const JsonEncoder.withIndent(
      '  ',
    ).convert({'processes': records.map((record) => record.toJson()).toList(growable: false)});

    await _file.writeAsString(contents);
  }

  static File _initFile() {
    final directory = File(Platform.resolvedExecutable).parent;
    final filePath = '${directory.path}${Platform.pathSeparator}processes.json';
    return File(filePath);
  }
}
