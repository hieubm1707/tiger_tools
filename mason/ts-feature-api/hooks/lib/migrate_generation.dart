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
      final tableName = generateModel.tableName;
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

        content = content.add('primaryKey: ${property.isPrimaryKey},\n');
        content = content.add('allowNull: ${property.allowNullable},\n');
        content = content.add('unique: ${property.isUnique},\n');
        content = content.add('field: \'${property.name.snakeCase}\',\n');
        content = content.add('autoIncrement: ${property.isAutoIncrement},\n',
            isAdd: property.isAutoIncrement && property.typeName == 'number');
        content = content.add(
          'defaultValue: ${property.defaultValue != null ? property.defaultValue : 'Sequelize.UUIDV4'},\n',
          isAdd: property.defaultValue != null || property.dbTypeName == 'UUID',
        );
        content =
            content.add('comment: \'${property.name} of the ${name}\',\n');
        content = content.add('},\n');
      }
      if (generateModel.includeCreatedAt) {
        content = content.add('''createdAt: {
          type: Sequelize.DATE,
          allowNull: false,
          field: 'created_at',
          comment: "Date and time of the ${name}'s creation date",
        },''');

        content = content.add('''updatedAt: {
          type: Sequelize.DATE,
          allowNull: true,
          field: 'updated_at',
          comment: "Date and time of the ${name}'s last update",
        },
        // insert columns here''');
      }
      final fileContent = file.readAsStringSync();
      var modifiedContent = fileContent.replaceFirst(
        '// insert columns here',
        content,
      );

      var indexContent = '';
      final indexProperties = generateModel.properties
          .where((property) => property.isCreateIndex || property.isPrimaryKey)
          .toList();
      for (final property in indexProperties) {
        indexContent = indexContent.add(
            '''await queryInterface.addIndex('${tableName}', ['${property.name.snakeCase}'], {
              name: '${tableName}_${property.name.snakeCase}_idx',
              ${property.isUnique ? 'unique: true,' : ''}
              using: 'btree',
            });
            ''');
      }

      modifiedContent = modifiedContent.replaceFirst(
        '// insert indexes here',
        '$indexContent// insert indexes here',
      );

      file.writeAsStringSync(modifiedContent);
    });
  }
}
