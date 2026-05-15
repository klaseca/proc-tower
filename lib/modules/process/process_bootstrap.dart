import 'package:disco/disco.dart';

import 'app/state/process_store.dart';
import 'infra/dao/process_dao.dart';
import 'infra/repo/process_repo.dart';

final _processRepo = ProcessRepo(ProcessDao());

final processStoreProvider = Provider(
  (_) => ProcessStore(_processRepo),
  dispose: (state) => state.dispose(),
);
