import 'dart:io';

import 'package:mason/mason.dart';

import 'content_extension.dart';
import 'generate_model.dart';
import 'generation_helper.dart';

class ControllerGeneration {
  static void addControllerProperties(GenerateModel generateModel) {
    handleWriteFile(() {
      final name = generateModel.name;
      final file = File(
          '${name.defaultPath}/controllers/${name.paramCase}.controller.ts');

      var createProperties = "";
      var updateProperties = "";

      for (final property in generateModel.properties) {
        if (!property.isEditProperty) continue;
        //name: validation.schemas.title.required(),
        final isRequired = property.allowNullable ? '' : '.required()';
        final content =
            '      ${property.name.camelCase}: validation.schemas.${property.typeName}$isRequired,\n';
        createProperties = createProperties.add(content);
        updateProperties = updateProperties.add(content);
      }
      final todo = '  // TODO: recheck this validation';
      createProperties = createProperties.add(todo);
      updateProperties = updateProperties.add(todo);

      final fileContent = file.readAsStringSync();
      var modifiedContent = fileContent.replaceFirst(
        '    // insert create attributes here',
        createProperties,
      );
      modifiedContent = modifiedContent.replaceFirst(
        '    // insert update attributes here',
        updateProperties,
      );
      file.writeAsStringSync(modifiedContent);
    });
  }
}
