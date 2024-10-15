import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:interact/interact.dart';
// import 'package:tiger_tools/tiger_tools_lib.dart';

const String version = '0.0.1';
const lineNumber = 'line-number';

void main() {
  buildServiceConfig();
}

void buildServiceConfig() {
  try {
    final languages = ['Rust', 'Dart', 'TypeScript'];
    final selection = Select(
      prompt: 'Your favorite programming language',
      options: languages,
    ).interact();

    stdout.writeln('languages: ${languages[selection]}');

    final answers = MultiSelect(
      prompt: 'Let me know your answers',
      options: ['A', 'B', 'C'],
      defaults: [false, true, false], // optional, will be all false by default
    ).interact();

    stdout.writeln('answers: ${answers}');

    exitCode = 0;
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    stdout.writeln(e.message);
  }
}
