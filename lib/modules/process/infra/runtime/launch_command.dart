import 'dart:io';

enum LaunchCommandError {
  emptyExecutable,
  unclosedQuote,
  invalidEnvironmentName,
  duplicateEnvironmentName,
  invalidEnvironmentValue,
  unknownEnvironmentVariable,
  invalidArgument,
}

class LaunchCommandException implements Exception {
  final LaunchCommandError error;
  final String variableName;

  const LaunchCommandException(this.error, {this.variableName = ''});

  @override
  String toString() =>
      'LaunchCommandException(${error.name}${variableName.isEmpty ? '' : ': $variableName'})';
}

class LaunchCommand {
  final String executable;
  final List<String> arguments;
  final Map<String, String> environment;

  const LaunchCommand({
    required this.executable,
    required this.arguments,
    this.environment = const {},
  });
}

final _environmentNamePattern = RegExp(r'^[A-Za-z_][A-Za-z0-9_().-]*$');

final _environmentReferencePattern = RegExp(
  r'\{\{([A-Za-z_][A-Za-z0-9_().-]*)\}\}|\{([A-Za-z_][A-Za-z0-9_().-]*)\}',
);

Map<String, String> _normalizeEnvironmentEntries(
  Iterable<MapEntry<String, String>> entries, {
  bool? caseInsensitive,
}) {
  final ignoreCase = caseInsensitive ?? Platform.isWindows;
  final result = <String, String>{};

  for (final entry in entries) {
    final name = entry.key.trim();
    if (name.isEmpty && entry.value.isEmpty) continue;
    if (!_environmentNamePattern.hasMatch(name)) {
      throw LaunchCommandException(.invalidEnvironmentName, variableName: name);
    }
    final key = ignoreCase ? name.toUpperCase() : name;
    if (result.containsKey(key)) {
      throw LaunchCommandException(.duplicateEnvironmentName, variableName: name);
    }
    if (entry.value.contains('\u0000')) {
      throw LaunchCommandException(.invalidEnvironmentValue, variableName: name);
    }
    result[key] = entry.value;
  }

  return Map.unmodifiable(result);
}

LaunchCommand buildLaunchCommand({
  required String executable,
  required String arguments,
  Map<String, String> environment = const {},
  bool? caseInsensitiveEnvironment,
}) {
  final normalizedExecutable = executable.trim();

  if (normalizedExecutable.isEmpty) {
    throw const LaunchCommandException(.emptyExecutable);
  }

  final launchArguments = parseLaunchArguments(
    arguments,
    environment: environment.entries,
    caseInsensitiveEnvironment: caseInsensitiveEnvironment,
  );

  return LaunchCommand(
    executable: normalizedExecutable,
    arguments: launchArguments.arguments,
    environment: launchArguments.environment,
  );
}

({List<String> arguments, Map<String, String> environment}) parseLaunchArguments(
  String input, {
  Iterable<MapEntry<String, String>> environment = const [],
  bool? caseInsensitiveEnvironment,
}) {
  final ignoreCase = caseInsensitiveEnvironment ?? Platform.isWindows;
  final values = _normalizeEnvironmentEntries(environment, caseInsensitive: ignoreCase);

  if (input.contains('\u0000')) {
    throw const LaunchCommandException(.invalidArgument);
  }

  final arguments = _parseArguments(input);

  final expandedArguments = arguments
      .map((argument) {
        final expanded = argument.replaceAllMapped(_environmentReferencePattern, (match) {
          final literalName = match.group(1);
          if (literalName != null) return '{$literalName}';

          final name = match.group(2)!;
          final key = ignoreCase ? name.toUpperCase() : name;
          final value = values[key];
          if (value == null) {
            throw LaunchCommandException(.unknownEnvironmentVariable, variableName: name);
          }
          return value;
        });
        if (expanded.contains('\u0000')) {
          throw const LaunchCommandException(.invalidArgument);
        }
        return expanded;
      })
      .toList(growable: false);

  return (arguments: expandedArguments, environment: values);
}

List<String> _parseArguments(String input) {
  final result = <String>[];
  final buffer = StringBuffer();
  String? quote;
  var tokenStarted = false;

  for (var i = 0; i < input.length; i += 1) {
    final char = input[i];

    if (quote != null) {
      if (char == quote) {
        quote = null;
      } else {
        buffer.write(char);
      }

      tokenStarted = true;
      continue;
    }

    if (char == '"' || char == "'") {
      quote = char;
      tokenStarted = true;
      continue;
    }

    if (char.trim().isEmpty) {
      if (tokenStarted) {
        result.add(buffer.toString());
        buffer.clear();
        tokenStarted = false;
      }

      continue;
    }

    buffer.write(char);
    tokenStarted = true;
  }

  if (quote != null) {
    throw const LaunchCommandException(.unclosedQuote);
  }

  if (tokenStarted) result.add(buffer.toString());

  return result;
}
