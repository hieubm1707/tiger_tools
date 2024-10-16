import 'dart:io';

import 'package:interact/interact.dart';
import 'package:mason/mason.dart';
import 'package:tiger_tools/tiger_tools_lib.dart';

final products = ['ngocdung', 'zema'];
final environments = ['development', 'staging', 'production', 'local'];

final services = <Service>[
  Service(name: 'chat', path: 'ez_chat_service', value: false),
  Service(name: 'collaborator', path: 'ez_collaborator_service', value: false),
  Service(name: 'crm', path: 'ez_crm_service', value: false),
  Service(name: 'firebase', path: 'ez_firebase_service', value: false),
  Service(name: 'loyalty', path: 'ez_loyalty_service', value: false),
  Service(name: 'public', path: 'ez_public_service', value: false),
  Service(name: 'shortlink', path: 'ez_shortlink_service', value: false),
  Service(name: 'sms', path: 'ez_sms_service', value: false),
  Service(name: 'social', path: 'ez_social_service', value: false),
  Service(name: 'upload', path: 'ez_upload_service', value: false),
  Service(name: 'voucher', path: 'ez_voucher_service', value: false),
  Service(name: 'zalo', path: 'ez_zalo_service', value: false),
];

void buildServiceConfig() {
  final selectedProductIndex = Select(
    prompt: 'Select a product to generate config',
    options: products,
  ).interact();
  final selectedProduct = products[selectedProductIndex];

  final selectedEnvIndex = Select(
    prompt: 'Select an environment to generate config',
    options: environments,
  ).interact();
  final envSelected = environments[selectedEnvIndex];

  final selectedServicesIndexes = MultiSelect(
    prompt: 'Select services to generate config',
    options: services.map((e) => e.name).toList(),
    defaults: services.map((e) => e.value).toList(),
  ).interact();
  if (selectedServicesIndexes.isEmpty) {
    stdout.writeln('No service selected, use \'space\' to select a service');
    return;
  }

  if (selectedServicesIndexes.length == 1) {
    final service = services[selectedServicesIndexes.first];
    final servicePath =
        '../env/${service.path}/env/$selectedProduct/.env.$envSelected';
    final inputPath = Input(
      prompt: 'Enter a path to get the config data',
      defaultValue: servicePath,
    ).interact();

    final outputPath = Input(
      prompt: 'Enter output path',
      defaultValue: './packages/${service.path}/lib/src/core/config',
    ).interact();
    writeToConfigFile(inputPath, outputPath);
  } else {
    for (final serviceIndex in selectedServicesIndexes) {
      final service = services[serviceIndex];
      final inputPath =
          '../env/${service.path}/env/$selectedProduct/.env.$envSelected';
      final outputDirectoryPath = './packages/${service.path}';
      final inputFile = File(inputPath);
      final outFile = Directory(outputDirectoryPath);
      if (!inputFile.existsSync() || !outFile.existsSync()) {
        print('$inputPath or $outputDirectoryPath was not found');
        return;
      }
      final outputPath = '$outputDirectoryPath/lib/src/core/config';
      writeToConfigFile(inputPath, outputPath);
    }
  }
}

void writeToConfigFile(String input, String output) {
  final outputFile = File('$output/app_config.dart');
  final outputValueFile = File('$output/app_config.ez.dart');
  if (!outputFile.existsSync()) {
    outputFile.createSync(recursive: true);
  }
  if (!outputValueFile.existsSync()) {
    outputValueFile.createSync(recursive: true);
  }

  outputFile.writeAsStringSync('''
// GENERATED CODE - DO NOT MODIFY BY HAND

part 'app_config.ez.dart';

  class AppConfig {

''', mode: FileMode.writeOnly);
  outputValueFile.writeAsStringSync('''
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

class _AppConfig {

''', mode: FileMode.writeOnly);
  final lines = readLines(input);
  for (final line in lines) {
    if (line.isEmpty) continue;

    final mapData = getKeyValue(line);
    final key = mapData.keys.first;
    final value = mapData.values.first;
    outputFile.writeAsStringSync(
      '  static const $key = _AppConfig.$key;\n',
      mode: FileMode.append,
    );
    outputValueFile.writeAsStringSync(
      '  static const $key = $value;\n',
      mode: FileMode.append,
    );
  }

  outputValueFile.writeAsStringSync('''
}
''', mode: FileMode.append);
  outputFile.writeAsStringSync('''
}
''', mode: FileMode.append);
  stdout.writeln('$outputFile generated successfully');
  stdout.writeln('$outputValueFile generated successfully');
}

Map<String, dynamic> getKeyValue(String text) {
  final index = text.indexOf('=');
  final key = text.substring(0, index);
  final value = text.substring(index + 1);
  final camelKey = key.camelCase;
  return {camelKey: value};
}

List<String> readLines(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw Exception('File not found');
  }
  return file.readAsLinesSync();
}
