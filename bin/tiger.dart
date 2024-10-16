import 'dart:io';

import 'package:args/args.dart';
import 'package:tiger_tools/tiger_tools_lib.dart';

import 'service_config.dart';

const String version = '0.0.1';

void printUsage(ArgParser argParser) {
  stdout.writeln('Hello I\'m Tiger Tools! \n');
  stdout.writeln('Usage: tiger <command> [arguments]\n');
  stdout.writeln('Global options:');
  stdout.writeln('${argParser.usage}\n');
  stdout.writeln('Available commands:');
  for (final object in argParser.commands.entries) {
    stdout.writeln('  ${object.key}         ${object.value.usage}');
  }
  // stdout.writeln(argParser.commands.keys);
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);

    // Process the parsed arguments.
    if (results.wasParsed(Flag.help.name)) {
      printUsage(argParser);
      return;
    }
    if (results.wasParsed(Flag.version.name)) {
      stdout.writeln('tiger tools version: $version');
      return;
    }
    if (results.wasParsed(Flag.verbose.name)) {
      stdout.writeln('[VERBOSE] All arguments: ${results.arguments}');
      printUsage(argParser);
      return;
    }
    final command = results.command;
    if (command?.name == Command.serviceConfig.value) {
      stdout.writeln('Service Config');
      buildServiceConfig();
      return;
    }
    printUsage(argParser);
    return;
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    stdout.writeln(e.message);
    stdout.writeln('');
    printUsage(argParser);
  }
}
