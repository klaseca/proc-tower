import '/i18n/strings.g.dart';
import '../infra/runtime/launch_command.dart';

String launchCommandErrorMessage(LaunchCommandException error, Translations translations) {
  final labels = translations.processes.form;
  return switch (error.error) {
    .emptyExecutable => labels.executableRequired,
    .unclosedQuote => labels.argumentsUnclosedQuote,
    .invalidEnvironmentName =>
      error.variableName.isEmpty
          ? labels.environmentNameRequired
          : labels.environmentInvalidName(name: error.variableName),
    .duplicateEnvironmentName => labels.environmentDuplicate(name: error.variableName),
    .invalidEnvironmentValue => labels.environmentInvalidValue(name: error.variableName),
    .unknownEnvironmentVariable => labels.argumentsUnknownVariable(name: error.variableName),
    .invalidArgument => labels.argumentsInvalid,
  };
}
