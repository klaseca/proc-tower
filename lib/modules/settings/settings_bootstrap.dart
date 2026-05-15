import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:jolt/jolt.dart';

final themeProvider = Provider(
  (_) => Signal(ThemeMode.system),
  dispose: (signal) => signal.dispose(),
);