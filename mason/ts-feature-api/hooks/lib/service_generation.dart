import 'dart:io';

import 'package:mason/mason.dart';

import 'content_extension.dart';
import 'generate_model.dart';

class ServiceGeneration {
  static void handleUniqueProperties(GenerateModel generateModel) {
    final name = generateModel.name;
    final properties = generateModel.properties
        .where((e) => e.isUnique && !e.isPrimaryKey)
        .toList();
    if (properties.isEmpty) return;

    final file =
        File('${name.defaultPath}/services/${name.paramCase}.service.ts');
    var content =
        '''const existing${name.pascalCase} = await ${name.pascalCase}Model.findOne({
       where: { [Op.or]: [''';
    for (final property in properties) {
      content = content.add(
        '{ ${property.name.camelCase}: ${name.camelCase}Details.${property.name.camelCase} },',
      );
    }
    content = content.add('] }, \n});\n');
    content = content.add(
      'if (existing${name.pascalCase}) {\n',
    );
    content = content.add(
      'throw new BadRequest(this.i18n.t(\'errors:dataAlreadyExist\'));\n',
    );
    content = content.add(
      '}\n',
    );

    final fileContent = file.readAsStringSync();
    var modifiedContent = fileContent.replaceAll(
      '// check exist model',
      content,
    );

    file.writeAsStringSync(modifiedContent);
  }
}
