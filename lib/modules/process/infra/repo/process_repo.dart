import '../../domain/process.dart';
import '../dao/process_dao.dart';
import '../mapper/process_mapper.dart';

class ProcessRepo {
  final ProcessDao _dao;

  const ProcessRepo(this._dao);

  Future<List<Process>> getProcesses() async {
    final records = await _dao.getProcesses();

    return records.map(ProcessMapper.toDomain).toList();
  }

  Future<void> deleteProcess(String processId) {
    return _dao.deleteProcess(processId);
  }

  Future<void> saveProcess(Process process) {
    return _dao.saveProcess(ProcessMapper.toDao(process));
  }
}
