import 'package:args/args.dart';
import 'package:tiger_tools/tiger_tools_lib.dart';

import 'service_config.dart';

const String version = '0.0.1';

void printUsage(ArgParser argParser) {
  print('Usage: tiger <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.wasParsed(Flag.help.name)) {
      printUsage(argParser);
      return;
    }
    if (results.wasParsed(Flag.version.name)) {
      print('tiger tools version: $version');
      return;
    }
    if (results.wasParsed(Flag.config.name)) {
      print('Service Config');
      buildServiceConfig();
      return;
    }
    if (results.wasParsed(Flag.verbose.name)) {
      verbose = true;
    }

    // Act on the arguments provided.
    print('Positional arguments: ${results.rest}');
    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
