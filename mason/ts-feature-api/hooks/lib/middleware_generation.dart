import 'dart:io';

import 'package:mason/mason.dart';

import 'content_extension.dart';
import 'generate_model.dart';
import 'generation_helper.dart';

class MiddlewareGeneration {
  static void addMiddlewareProperties(GenerateModel generateModel) {
    handleWriteFile(() {
      final name = generateModel.name;
      final file =
          File('${name.defaultPath}/middlewares/validation.middleware.ts');

      var content = "";

      for (final property in generateModel.properties) {
        if (!property.isEditProperty) continue;
        final request = property.allowNullable ? '' : '.required()';
        var typeName = property.typeName.toLowerCase();
        var dbType = property.dbTypeName;
        if (typeName.contains('record')) {
          typeName = 'object';
        }
        if (typeName.contains('[]')) {
          typeName = 'array';
        }
        if (typeName == 'string' && dbType.contains('ENUM')) {
          final validEnum = dbType.replaceAll('ENUM', 'valid');
          typeName = '$typeName.$validEnum';
        }
        final field =
            '      ${property.name.snakeCase}: schemas.$typeName$request,\n';
        content = content.add(field);
      }
      content = content.add('// insert fields here');

      final fileContent = file.readAsStringSync();
      var modifiedContent = fileContent.replaceAll(
        '// insert fields here',
        content,
      );
      file.writeAsStringSync(modifiedContent);
    });
  }
}
