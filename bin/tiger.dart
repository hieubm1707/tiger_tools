import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:tiger_tools/core/command/mason/mason_command.dart';
import 'package:tiger_tools/core/command/service_config_command.dart';

void main(List<String> arguments) {
  final runner = CommandRunner('tiger', 'Hello I\'m Tiger Tools! \n')
    ..addCommand(ServiceConfigCommand())
    ..addCommand(MasonCommand());

  runner.run(arguments).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64); // Exit code 64 indicates a usage error.
  });
}
