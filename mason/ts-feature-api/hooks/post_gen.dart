import 'dart:io';

import 'package:mason/mason.dart';
import 'package:ts_feature_api_hooks/generation.dart';

Future<void> run(HookContext context) async {
  final hasGetTemplate = context.vars['template'] as bool? ?? false;
  if (hasGetTemplate) {
    return;
  }
  final name = context.vars['name'] as String?;
  final tableName = context.vars['table_name'] as String?;
  final properties = context.vars['properties'] as List?;
  if (name == null || tableName == null || properties == null) {
    context.logger.err('Missing required template variables.');
    return;
  }

  // Add dependencies
  final progress = context.logger.progress('Feature are being fetched...');
  final generateModel = GenerateModel.fromJson(context.vars);
  ModelGeneration.addModelProperties(generateModel);
  TypeGeneration.addTypeProperties(generateModel);
  TypeGeneration.addDtoProperties(generateModel);
  MiddlewareGeneration.addMiddlewareProperties(generateModel);
  AdminResourceGeneration.addAdminJsProperties(generateModel);
  MigrateGeneration.addMigrateProperties(generateModel, context.vars);
  ServiceGeneration.handleUniqueProperties(generateModel);

  await Process.run('bash', ['-c', 'npm run lint:fix']);

  progress.complete('Feature are being fetched');
  context.logger.success('Finished fetching Feature.');
}
