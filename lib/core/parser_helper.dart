import 'package:args/args.dart';

import 'core.dart';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      Flag.help.name,
      abbr: Flag.help.abbr,
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      Flag.verbose.name,
      abbr: Flag.verbose.abbr,
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      Flag.version.name,
      negatable: false,
      help: 'Print the tool version.',
    )
    ..addFlag(
      Flag.config.name,
      negatable: false,
      help: 'Generate a service configuration.',
    );
}
