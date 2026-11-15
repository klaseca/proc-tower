import 'package:disco/disco.dart';

import '/infra/app_data_storage/app_data_storage.dart';
import 'app/state/settings_store.dart';
import 'infra/dao/settings_dao.dart';

SettingsStore createSettingsStore(AppDataStorage storage) {
  return SettingsStore(SettingsDao(storage), storage);
}

final settingsStoreProvider = Provider.withArgument(
  (_, SettingsStore settingsStore) => settingsStore,
);
