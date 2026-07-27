///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final tr = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$app$en app = Translations$app$en.internal(_root);
	late final Translations$common$en common = Translations$common$en.internal(_root);
	late final Translations$processes$en processes = Translations$processes$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
}

// Path: app
class Translations$app$en {
	Translations$app$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$app$navigation$en navigation = Translations$app$navigation$en.internal(_root);
}

// Path: common
class Translations$common$en {
	Translations$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Exit'
	String get exit => 'Exit';
}

// Path: processes
class Translations$processes$en {
	Translations$processes$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Processes'
	String get title => 'Processes';

	late final Translations$processes$dialog$en dialog = Translations$processes$dialog$en.internal(_root);
	late final Translations$processes$form$en form = Translations$processes$form$en.internal(_root);
	late final Translations$processes$table$en table = Translations$processes$table$en.internal(_root);
	late final Translations$processes$status$en status = Translations$processes$status$en.internal(_root);
	late final Translations$processes$launchType$en launchType = Translations$processes$launchType$en.internal(_root);
	late final Translations$processes$errors$en errors = Translations$processes$errors$en.internal(_root);
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	late final Translations$settings$errors$en errors = Translations$settings$errors$en.internal(_root);
	late final Translations$settings$theme$en theme = Translations$settings$theme$en.internal(_root);
	late final Translations$settings$language$en language = Translations$settings$language$en.internal(_root);
}

// Path: app.navigation
class Translations$app$navigation$en {
	Translations$app$navigation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Processes'
	String get processes => 'Processes';

	/// en: 'Settings'
	String get settings => 'Settings';
}

// Path: processes.dialog
class Translations$processes$dialog$en {
	Translations$processes$dialog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add Process'
	String get addTitle => 'Add Process';

	/// en: 'Edit Process'
	String get editTitle => 'Edit Process';

	/// en: 'Delete process?'
	String get deleteTitle => 'Delete process?';

	/// en: 'The process "$processName" will be deleted. This action cannot be undone.'
	String deleteConfirmation({required Object processName}) => 'The process "${processName}" will be deleted. This action cannot be undone.';
}

// Path: processes.form
class Translations$processes$form$en {
	Translations$processes$form$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Name'
	String get nameLabel => 'Name';

	/// en: 'Enter the process name'
	String get nameRequired => 'Enter the process name';

	/// en: 'Launch Type'
	String get launchTypeLabel => 'Launch Type';

	/// en: 'Executable'
	String get executableLabel => 'Executable';

	/// en: 'Enter the executable'
	String get executableRequired => 'Enter the executable';

	/// en: 'Launch Arguments'
	String get argumentsLabel => 'Launch Arguments';
}

// Path: processes.table
class Translations$processes$table$en {
	Translations$processes$table$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Status'
	String get status => 'Status';

	/// en: 'Launch Type'
	String get launchType => 'Launch Type';

	/// en: 'Actions'
	String get actions => 'Actions';

	/// en: 'No logs yet'
	String get logsEmpty => 'No logs yet';
}

// Path: processes.status
class Translations$processes$status$en {
	Translations$processes$status$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Running'
	String get running => 'Running';

	/// en: 'Starting'
	String get starting => 'Starting';

	/// en: 'Stopped'
	String get stopped => 'Stopped';

	/// en: 'Failed'
	String get failed => 'Failed';
}

// Path: processes.launchType
class Translations$processes$launchType$en {
	Translations$processes$launchType$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Auto'
	String get auto => 'Auto';

	/// en: 'Manual'
	String get manual => 'Manual';
}

// Path: processes.errors
class Translations$processes$errors$en {
	Translations$processes$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Could not add the process.'
	String get addFailed => 'Could not add the process.';

	/// en: 'Could not find the process.'
	String get notFound => 'Could not find the process.';

	/// en: 'Could not save the process.'
	String get saveFailed => 'Could not save the process.';

	/// en: 'Could not start the process.'
	String get startFailed => 'Could not start the process.';

	/// en: 'Could not stop the process.'
	String get stopFailed => 'Could not stop the process.';

	/// en: 'Could not delete the process.'
	String get deleteFailed => 'Could not delete the process.';
}

// Path: settings.errors
class Translations$settings$errors$en {
	Translations$settings$errors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Could not save settings.'
	String get saveFailed => 'Could not save settings.';
}

// Path: settings.theme
class Translations$settings$theme$en {
	Translations$settings$theme$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'App Theme'
	String get title => 'App Theme';

	/// en: 'Choose the appearance mode for the whole app.'
	String get description => 'Choose the appearance mode for the whole app.';

	/// en: 'System'
	String get system => 'System';

	/// en: 'Light'
	String get light => 'Light';

	/// en: 'Dark'
	String get dark => 'Dark';
}

// Path: settings.language
class Translations$settings$language$en {
	Translations$settings$language$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get title => 'Language';

	/// en: 'Choose the app interface language.'
	String get description => 'Choose the app interface language.';

	/// en: 'System'
	String get system => 'System';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.navigation.processes' => 'Processes',
			'app.navigation.settings' => 'Settings',
			'common.add' => 'Add',
			'common.save' => 'Save',
			'common.cancel' => 'Cancel',
			'common.delete' => 'Delete',
			'common.exit' => 'Exit',
			'processes.title' => 'Processes',
			'processes.dialog.addTitle' => 'Add Process',
			'processes.dialog.editTitle' => 'Edit Process',
			'processes.dialog.deleteTitle' => 'Delete process?',
			'processes.dialog.deleteConfirmation' => ({required Object processName}) => 'The process "${processName}" will be deleted. This action cannot be undone.',
			'processes.form.nameLabel' => 'Name',
			'processes.form.nameRequired' => 'Enter the process name',
			'processes.form.launchTypeLabel' => 'Launch Type',
			'processes.form.executableLabel' => 'Executable',
			'processes.form.executableRequired' => 'Enter the executable',
			'processes.form.argumentsLabel' => 'Launch Arguments',
			'processes.table.name' => 'Name',
			'processes.table.status' => 'Status',
			'processes.table.launchType' => 'Launch Type',
			'processes.table.actions' => 'Actions',
			'processes.table.logsEmpty' => 'No logs yet',
			'processes.status.running' => 'Running',
			'processes.status.starting' => 'Starting',
			'processes.status.stopped' => 'Stopped',
			'processes.status.failed' => 'Failed',
			'processes.launchType.auto' => 'Auto',
			'processes.launchType.manual' => 'Manual',
			'processes.errors.addFailed' => 'Could not add the process.',
			'processes.errors.notFound' => 'Could not find the process.',
			'processes.errors.saveFailed' => 'Could not save the process.',
			'processes.errors.startFailed' => 'Could not start the process.',
			'processes.errors.stopFailed' => 'Could not stop the process.',
			'processes.errors.deleteFailed' => 'Could not delete the process.',
			'settings.title' => 'Settings',
			'settings.errors.saveFailed' => 'Could not save settings.',
			'settings.theme.title' => 'App Theme',
			'settings.theme.description' => 'Choose the appearance mode for the whole app.',
			'settings.theme.system' => 'System',
			'settings.theme.light' => 'Light',
			'settings.theme.dark' => 'Dark',
			'settings.language.title' => 'Language',
			'settings.language.description' => 'Choose the app interface language.',
			'settings.language.system' => 'System',
			_ => null,
		};
	}
}
