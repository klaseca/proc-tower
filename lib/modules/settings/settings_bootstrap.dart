import 'package:disco/disco.dart';

import 'app/state/settings_store.dart';
import 'infra/dao/settings_dao.dart';

final settingsStore = SettingsStore(SettingsDao());

final settingsStoreProvider = Provider((_) => settingsStore);
