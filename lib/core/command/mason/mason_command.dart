import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import 'cms_feature_bundle.dart';

class MasonCommand extends Command {
  @override
  String get description => 'Use mason to generate feature.';

  @override
  String get name => 'mason';

  MasonCommand() {
    addSubcommand(CmsFeatureCommand());
  }
}

class CmsFeatureCommand extends Command {
  @override
  String get description => 'Generate a CMS feature.';

  @override
  String get name => 'cms-feature';

  CmsFeatureCommand() {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'The name of the feature to generate.',
      )
      // ..addOption(
      //   'config',
      //   abbr: 'c',
      //   help: 'The path to the JSON configuration file.',

      // )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'The directory path to generate the feature.',
        defaultsTo: './',
      );
  }

  @override
  void run() async {
    final results = argResults;
    if (results == null) {
      printUsage();
      return;
    }
    if (results.arguments.isEmpty) {
      printUsage();
      return;
    }

    String featureName = '';
    if (results.wasParsed('name')) {
      featureName = results['name'];
    }
    String outputPath = './';
    if (results.wasParsed('output')) {
      outputPath = results['output'];
    }
    final outputDirectory = Directory(outputPath);
    if (!outputDirectory.existsSync()) {
      throw UsageException('$outputPath Directory does not exist', usage);
    }

    print('Generating CMS feature $featureName in $outputPath');
    await runMasonGenerate(
      vars: {'name': featureName},
      outputDirectory: outputDirectory,
    );
  }
}

Future<void> runMasonGenerate({
  required Map<String, dynamic> vars,
  Directory? outputDirectory,
}) async {
  try {
    final generator = await MasonGenerator.fromBundle(cmsFeatureBundle);
    final target =
        DirectoryGeneratorTarget(outputDirectory ?? Directory.current);
    await generator.hooks.preGen(vars: vars, workingDirectory: target.dir.path);
    await generator.generate(target, vars: vars);
    await generator.hooks
        .postGen(vars: vars, workingDirectory: target.dir.path);
  } catch (error, stackTrace) {
    print(error);
    print(stackTrace);
  }
}
