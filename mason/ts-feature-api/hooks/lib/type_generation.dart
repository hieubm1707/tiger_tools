import 'dart:io';

import 'package:mason/mason.dart';

import 'content_extension.dart';
import 'generate_model.dart';
import 'generation_helper.dart';

class TypeGeneration {
  static void addTypeProperties(GenerateModel generateModel) {
    handleWriteFile(() {
      final name = generateModel.name;
      final indexFile = File('${name.defaultPath}/types/index.ts');
      if (!indexFile.existsSync()) {
        indexFile.createSync(recursive: true);
        indexFile.writeAsStringSync('''// Export types from here

export * from './${name.paramCase}.type';
// add new type here

export { default } from './index.d';''');
      } else {
        final indexContent = indexFile.readAsStringSync();
        final modifiedIndexContent = indexContent.replaceFirst(
          '// add new type here',
          '''export * from './${name.paramCase}.type';
// add new type here''',
        );
        indexFile.writeAsStringSync(modifiedIndexContent);
      }

      final file = File('${name.defaultPath}/types/${name.paramCase}.type.ts');

      var formattedProperties = "";
      var createProperties = "";
      var updateProperties = "";
      var filterProperties = "";

      for (final property in generateModel.properties) {
        final nullable = property.allowNullable ? '?' : '';
        final content =
            '  ${property.name.camelCase}$nullable: ${property.typeName};\n';
        formattedProperties = formattedProperties.add(content);
        createProperties = createProperties.add(
          content,
          isAdd: property.isEditProperty,
        );
        updateProperties = updateProperties.add(
          content,
          isAdd: property.isEditProperty,
        );
        filterProperties = filterProperties.add(
          content,
          isAdd: property.isFilterProperty,
        );
      }
      formattedProperties =
          formattedProperties.add('  createdAt?: Date;\n  updatedAt?: Date;\n');
      filterProperties =
          filterProperties.add('  createdAt?: Date;\n  updatedAt?: Date;\n');

      final fileContent = file.readAsStringSync();
      var modifiedContent = fileContent.replaceFirst(
        '    // insert formatted attributes here',
        formattedProperties,
      );
      modifiedContent = modifiedContent.replaceFirst(
        '    // insert create attributes here',
        createProperties,
      );
      modifiedContent = modifiedContent.replaceFirst(
        '    // insert update attributes here',
        updateProperties,
      );
      modifiedContent = modifiedContent.replaceFirst(
        '    // insert filter attributes here',
        filterProperties,
      );
      file.writeAsStringSync(modifiedContent);
    });
  }

  static void addDtoProperties(GenerateModel generateModel) {
    handleWriteFile(() {
      final name = generateModel.name;
      final file = File('${name.defaultPath}/dto/${name.paramCase}.dto.ts');

      var formattedProperties = "";

      for (final property in generateModel.properties) {
        final content =
            '  ${property.name.camelCase}: ${name.camelCase}.${property.name.camelCase},\n';
        formattedProperties = formattedProperties.add(content);
      }
      formattedProperties =
          formattedProperties.add(' createdAt: ${name.camelCase}.createdAt,\n');
      formattedProperties =
          formattedProperties.add(' updatedAt: ${name.camelCase}.updatedAt,\n');

      final fileContent = file.readAsStringSync();
      var modifiedContent = fileContent.replaceFirst(
        '    // insert formatted attributes here',
        formattedProperties,
      );
      file.writeAsStringSync(modifiedContent);
    });
  }
}
