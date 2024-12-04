import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

import 'bundles/bundles.dart';

class MasonCommand extends Command {
  @override
  String get description => 'Use mason to generate feature.';

  @override
  String get name => 'mason';

  MasonCommand() {
    addSubcommand(CmsFeatureCommand());
    addSubcommand(TsFeatureApiCommand());
  }
}

Future<void> runMasonGenerate({
  required Map<String, dynamic> vars,
  Directory? outputDirectory,
  required MasonBundle bundle,
}) async {
  try {
    final generator = await MasonGenerator.fromBundle(bundle);
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
      bundle: cmsFeatureBundle,
    );
  }
}

class TsFeatureApiCommand extends Command {
  @override
  String get description => '''Generate a typescript api feature. 
Example:  ts-feature-api --config-path=./config.json --output=./''';

  @override
  String get name => 'ts-feature-api';

  TsFeatureApiCommand() {
    argParser
      ..addOption(
        'config-path',
        abbr: 'c',
        help: 'Path to config json file containing variables.',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'The directory path to generate the feature.',
        defaultsTo: './',
      )
      ..addFlag(
        'template',
        abbr: 't',
        help: 'Get the template to generate the feature.',
        // defaultsTo: './',
      );
  }

  @override
  void run() async {
    try {
      final results = argResults;
      if (results == null) {
        printUsage();
        return;
      }
      if (results.arguments.isEmpty) {
        printUsage();
        return;
      }

      if (results.wasParsed('template')) {
        final file = File('./ts-api-generated-template.json');
        file.writeAsStringSync(templateData);

        return;
      }

      String configPath = '';
      if (results.wasParsed('config-path')) {
        configPath = results['config-path'];
      }
      final configFile = File(configPath);
      if (!configFile.existsSync()) {
        throw UsageException('$configPath File does not exist', usage);
      }
      final configString = configFile.readAsStringSync();
      final configData = jsonDecode(configString) as Map<String, dynamic>;

      String outputPath = './';
      if (results.wasParsed('output')) {
        outputPath = results['output'];
      }
      final outputDirectory = Directory(outputPath);
      if (!outputDirectory.existsSync()) {
        throw UsageException('$outputPath Directory does not exist', usage);
      }

      print('Generating Typescript Api feature in $outputPath');

      final now = DateTime.now();
      final dateTimeNow =
          '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';
      await runMasonGenerate(
        vars: {
          ...configData,
          'template': false,
          'date_now': dateTimeNow,
        },
        outputDirectory: outputDirectory,
        bundle: tsFeatureApiBundle,
      );
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack: $stackTrace');
    }
  }
}

const templateData = '''{
  "name": "demo",
  "table_name": "demos",
  "sort_property": {
    "sort_by": "createdAt",
    "direction": "asc"
    },
  "property_document":  {
    "name": "               //  string type, it is the name of property",
    "type_name": "          //  string type, it is the ts type name of property, allow string | number | boolean | ...",
    "db_type_name": "       //  string type, it is the database type name, allow STRING | CHAR | TEXT | NUMBER | TINYINT | SMALLINT | MEDIUMINT | INTEGER | BIGINT | FLOAT | DOUBLE | BOOLEAN | TIME | DATE | JSON | JSONB | UUID | VIRTUAL | ENUM | ARRAY",
    "is_list_property": "   //  bool type, default is false, if true, it will be the list property", 
    "is_show_property": "   //  bool type, default is false, if true, it will be the show property",
    "is_filter_property": " //  bool type, default is false, if true, it will be the filter property",
    "is_primary_key": "     //  bool type, default is false, if true, it will be the primary key, primary key is unique",
    "is_unique": "          //  bool type, default is false, if true, it will be the unique property",
    "is_edit_property": "   //  bool type, default is false, if true, it will be the edit property",
    "allow_nullable": "     //  bool type, default is false, if true, it will be the nullable property"
  },  
  "properties": [
    {
      "name": "id",
      "type_name": "string",
      "db_type_name": "UUID",
      "is_list_property": true,
      "is_show_property": true,
      "is_filter_property": true,
      "is_primary_key": true,
      "is_unique": false,
      "is_edit_property": false,
      "allow_nullable": false
    },
    {
      "name": "name",
      "type_name": "string",
      "db_type_name": "STRING(64)",
      "is_list_property": true,
      "is_show_property": true,
      "is_edit_property": true,
      "is_filter_property": true,
      "is_unique": true
    }
  ]
}''';
