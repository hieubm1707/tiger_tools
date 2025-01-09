import 'dart:io';

import 'package:mason/mason.dart';

import 'content_extension.dart';
import 'generate_model.dart';
import 'generation_helper.dart';

class ModelGeneration {
  static void addModelProperties(GenerateModel generateModel) {
    handleWriteFile(() {
      final name = generateModel.name;
      final tableName = generateModel.tableName;
      final file =
          File('${name.defaultPath}/models/${name.paramCase}.model.ts');
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      const template = '''
  // ─── MODEL ATTRIBUTES ───────────────────────────────────────────────────────────
''';
      var content = """
  // ─── MODEL ATTRIBUTES ───────────────────────────────────────────────────────────

""";

      for (final property in generateModel.properties) {
        content = content.add(' @Column({\n');
        content = content.add('   field: \'${property.name}\',\n');
        content = content.add(
          '   primaryKey: ${property.isPrimaryKey},\n',
          isAdd: property.isPrimaryKey,
        );
        content = content.add(
          '   type: DataType.${property.dbTypeName},\n',
        );
        content = content.add(
          '   defaultValue: ${property.defaultValue != null ? property.defaultValue : 'DataType.UUIDV4'},\n',
          isAdd: property.defaultValue != null || property.dbTypeName == 'UUID',
        );
        content = content.add(
          '   allowNull: ${property.allowNullable},\n',
        );
        content = content.add(
          '   unique: ${property.isUnique},\n',
          isAdd: property.isUnique,
        );
        content = content.add(
          '   autoIncrement: ${property.isAutoIncrement},\n',
          isAdd: property.isAutoIncrement && property.typeName == 'number',
        );
        content = content.add(
          '''   defaultValue: Sequelize.literal("nextval('${tableName}_${property.name}_seq'::regclass)"),\n''',
          isAdd: property.isAutoIncrement && property.typeName == 'number',
        );
        content = content.add(' })\n');

        content = content.add(
          " @Index({ name: '${tableName}_${property.name.snakeCase}_idx', using: 'btree'${property.isUnique ? ', unique: true' : ''} })\n",
          isAdd: property.isCreateIndex || property.isPrimaryKey,
        );

        final allowNullable = property.allowNullable ? '?' : '!';
        content = content.add(
            ' ${property.name.camelCase}$allowNullable: ${property.typeName};\n\n');
      }
      if (generateModel.includeCreatedAt) {
        content = content.add('''
@CreatedAt
@Column({
  field: 'created_at',
  allowNull: false,
  type: DataType.DATE,
})
createdAt?: Date;

@UpdatedAt
@Column({
  field: 'updated_at',
  allowNull: true,
  type: DataType.DATE,
})
updatedAt?: Date;
''');
      }

      final fileContent = file.readAsStringSync();
      final modifiedContent = fileContent.replaceFirst(
        template,
        '$content\n// insert new model attributes here',
      );
      file.writeAsStringSync(modifiedContent);
    });
  }
}
