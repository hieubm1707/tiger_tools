import 'dart:io';

import 'package:mason/mason.dart';

import 'content_extension.dart';
import 'generate_model.dart';
import 'generation_helper.dart';

class MigrateGeneration {
  static void addMigrateProperties(
    GenerateModel generateModel,
    Map<String, dynamic> vars,
  ) {
    handleWriteFile(() {
      final name = generateModel.name;
      final dateNow = vars['date_now'];
      final file =
          File('db/migrations/${dateNow}-${name.paramCase}-migration.js');
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      var content = '';
      for (final property in generateModel.properties) {
        content = content.add('${property.name.camelCase}: {\n');
        content = content.add('type: Sequelize.${property.dbTypeName},\n');
        if (property.dbTypeName == 'UUID') {
          content = content.add('defaultValue: Sequelize.UUIDV4,\n');
        }
        content = content.add('primaryKey: ${property.isPrimaryKey},\n');
        content = content.add('allowNull: ${property.allowNullable},\n');
        content = content.add('unique: ${property.isUnique},\n');
        content = content.add('field: \'${property.name.camelCase}\',\n');
        content =
            content.add('comment: \'${property.name} of the ${name}\',\n');
        content = content.add('},\n');
      }
      content = content.add('''createdAt: {
          type: Sequelize.DATE,
          allowNull: false,
          field: 'createdAt',
          comment: "Date and time of the news's creation date",
        },''');

      content = content.add('''updatedAt: {
          type: Sequelize.DATE,
          allowNull: false,
          field: 'updatedAt',
          comment: "Date and time of the news's last update",
        },''');

      final fileContent = file.readAsStringSync();
      final modifiedContent = fileContent.replaceFirst(
        '// insert columns here',
        content,
      );
      file.writeAsStringSync(modifiedContent);
    });
  }
}
