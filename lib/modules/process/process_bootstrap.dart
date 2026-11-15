import 'dart:async';

import 'package:disco/disco.dart';

import '/infra/app_data_storage/app_data_storage.dart';
import 'app/state/process_store.dart';
import 'infra/dao/process_dao.dart';
import 'infra/repo/process_repo.dart';

ProcessStore createProcessStore(AppDataStorage storage) {
  return ProcessStore(ProcessRepo(ProcessDao(storage)));
}

final processStoreProvider = Provider.withArgument(
  (_, ProcessStore processStore) => processStore,
  dispose: (processStore) => unawaited(processStore.dispose()),
);
