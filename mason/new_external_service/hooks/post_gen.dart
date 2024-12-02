import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  // Add dependencies
  final progress =
      context.logger.progress('Dart packages are being fetched...');

  final serviceName = context.vars['service_name'];
  final ezServiceName = 'ez_${serviceName}_service';

  await Process.run('bash', [
    '-c',
    '(cd $ezServiceName && dart pub get && dart run build_runner clean && dart run build_runner build --delete-conflicting-outputs)',
  ]);

  progress.complete('Dart packages are being fetched');
  context.logger.success('Finished fetching Dart packages.');
}
