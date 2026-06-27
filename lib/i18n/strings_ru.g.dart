///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsRu extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsRu _root = this; // ignore: unused_field

	@override 
	TranslationsRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRu(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$ru app = _Translations$app$ru._(_root);
	@override late final _Translations$common$ru common = _Translations$common$ru._(_root);
	@override late final _Translations$processes$ru processes = _Translations$processes$ru._(_root);
	@override late final _Translations$settings$ru settings = _Translations$settings$ru._(_root);
}

// Path: app
class _Translations$app$ru extends Translations$app$en {
	_Translations$app$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override late final _Translations$app$navigation$ru navigation = _Translations$app$navigation$ru._(_root);
}

// Path: common
class _Translations$common$ru extends Translations$common$en {
	_Translations$common$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get add => 'Добавить';
	@override String get save => 'Сохранить';
	@override String get cancel => 'Отмена';
	@override String get exit => 'Выход';
}

// Path: processes
class _Translations$processes$ru extends Translations$processes$en {
	_Translations$processes$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Процессы';
	@override late final _Translations$processes$dialog$ru dialog = _Translations$processes$dialog$ru._(_root);
	@override late final _Translations$processes$form$ru form = _Translations$processes$form$ru._(_root);
	@override late final _Translations$processes$table$ru table = _Translations$processes$table$ru._(_root);
	@override late final _Translations$processes$status$ru status = _Translations$processes$status$ru._(_root);
	@override late final _Translations$processes$launchType$ru launchType = _Translations$processes$launchType$ru._(_root);
	@override late final _Translations$processes$errors$ru errors = _Translations$processes$errors$ru._(_root);
}

// Path: settings
class _Translations$settings$ru extends Translations$settings$en {
	_Translations$settings$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Настройки';
	@override late final _Translations$settings$errors$ru errors = _Translations$settings$errors$ru._(_root);
	@override late final _Translations$settings$theme$ru theme = _Translations$settings$theme$ru._(_root);
	@override late final _Translations$settings$language$ru language = _Translations$settings$language$ru._(_root);
}

// Path: app.navigation
class _Translations$app$navigation$ru extends Translations$app$navigation$en {
	_Translations$app$navigation$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get processes => 'Процессы';
	@override String get settings => 'Настройки';
}

// Path: processes.dialog
class _Translations$processes$dialog$ru extends Translations$processes$dialog$en {
	_Translations$processes$dialog$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get addTitle => 'Добавить процесс';
	@override String get editTitle => 'Редактировать процесс';
}

// Path: processes.form
class _Translations$processes$form$ru extends Translations$processes$form$en {
	_Translations$processes$form$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get nameLabel => 'Название';
	@override String get nameRequired => 'Укажи название процесса';
	@override String get launchTypeLabel => 'Тип запуска';
	@override String get executableLabel => 'Исполняемый файл';
	@override String get executableRequired => 'Укажи исполняемый файл';
	@override String get argumentsLabel => 'Аргументы запуска';
}

// Path: processes.table
class _Translations$processes$table$ru extends Translations$processes$table$en {
	_Translations$processes$table$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get name => 'Название';
	@override String get status => 'Статус';
	@override String get launchType => 'Тип запуска';
	@override String get actions => 'Действия';
	@override String get logsEmpty => 'Логи пока пусты';
}

// Path: processes.status
class _Translations$processes$status$ru extends Translations$processes$status$en {
	_Translations$processes$status$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get running => 'Работает';
	@override String get starting => 'Запускается';
	@override String get stopped => 'Остановлен';
	@override String get failed => 'Ошибка';
}

// Path: processes.launchType
class _Translations$processes$launchType$ru extends Translations$processes$launchType$en {
	_Translations$processes$launchType$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get auto => 'Авто';
	@override String get manual => 'Ручной';
}

// Path: processes.errors
class _Translations$processes$errors$ru extends Translations$processes$errors$en {
	_Translations$processes$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get addFailed => 'Не удалось добавить процесс.';
	@override String get notFound => 'Не удалось найти процесс.';
	@override String get saveFailed => 'Не удалось сохранить процесс.';
	@override String get startFailed => 'Не удалось запустить процесс.';
	@override String get stopFailed => 'Не удалось остановить процесс.';
	@override String get deleteFailed => 'Не удалось удалить процесс.';
}

// Path: settings.errors
class _Translations$settings$errors$ru extends Translations$settings$errors$en {
	_Translations$settings$errors$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get saveFailed => 'Не удалось сохранить настройки.';
}

// Path: settings.theme
class _Translations$settings$theme$ru extends Translations$settings$theme$en {
	_Translations$settings$theme$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Тема приложения';
	@override String get description => 'Выбери режим отображения для всего приложения.';
	@override String get system => 'Система';
	@override String get light => 'Светлая';
	@override String get dark => 'Тёмная';
}

// Path: settings.language
class _Translations$settings$language$ru extends Translations$settings$language$en {
	_Translations$settings$language$ru._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Язык';
	@override String get description => 'Выбери язык интерфейса приложения.';
	@override String get system => 'Система';
}

/// The flat map containing all translations for locale <ru>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.navigation.processes' => 'Процессы',
			'app.navigation.settings' => 'Настройки',
			'common.add' => 'Добавить',
			'common.save' => 'Сохранить',
			'common.cancel' => 'Отмена',
			'common.exit' => 'Выход',
			'processes.title' => 'Процессы',
			'processes.dialog.addTitle' => 'Добавить процесс',
			'processes.dialog.editTitle' => 'Редактировать процесс',
			'processes.form.nameLabel' => 'Название',
			'processes.form.nameRequired' => 'Укажи название процесса',
			'processes.form.launchTypeLabel' => 'Тип запуска',
			'processes.form.executableLabel' => 'Исполняемый файл',
			'processes.form.executableRequired' => 'Укажи исполняемый файл',
			'processes.form.argumentsLabel' => 'Аргументы запуска',
			'processes.table.name' => 'Название',
			'processes.table.status' => 'Статус',
			'processes.table.launchType' => 'Тип запуска',
			'processes.table.actions' => 'Действия',
			'processes.table.logsEmpty' => 'Логи пока пусты',
			'processes.status.running' => 'Работает',
			'processes.status.starting' => 'Запускается',
			'processes.status.stopped' => 'Остановлен',
			'processes.status.failed' => 'Ошибка',
			'processes.launchType.auto' => 'Авто',
			'processes.launchType.manual' => 'Ручной',
			'processes.errors.addFailed' => 'Не удалось добавить процесс.',
			'processes.errors.notFound' => 'Не удалось найти процесс.',
			'processes.errors.saveFailed' => 'Не удалось сохранить процесс.',
			'processes.errors.startFailed' => 'Не удалось запустить процесс.',
			'processes.errors.stopFailed' => 'Не удалось остановить процесс.',
			'processes.errors.deleteFailed' => 'Не удалось удалить процесс.',
			'settings.title' => 'Настройки',
			'settings.errors.saveFailed' => 'Не удалось сохранить настройки.',
			'settings.theme.title' => 'Тема приложения',
			'settings.theme.description' => 'Выбери режим отображения для всего приложения.',
			'settings.theme.system' => 'Система',
			'settings.theme.light' => 'Светлая',
			'settings.theme.dark' => 'Тёмная',
			'settings.language.title' => 'Язык',
			'settings.language.description' => 'Выбери язык интерфейса приложения.',
			'settings.language.system' => 'Система',
			_ => null,
		};
	}
}
