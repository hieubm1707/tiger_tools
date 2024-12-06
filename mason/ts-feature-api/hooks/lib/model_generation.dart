import 'dart:io';

import 'package:mason/mason.dart';

import 'content_extension.dart';
import 'generate_model.dart';
import 'generation_helper.dart';

class ModelGeneration {
  static void addModelProperties(GenerateModel generateModel) {
    handleWriteFile(() {
      final name = generateModel.name;
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
        content = content.add(
          '   primaryKey: ${property.isPrimaryKey},\n',
          isAdd: property.isPrimaryKey,
        );
        content = content.add(
          '   type: DataType.${property.dbTypeName},\n',
        );
        content = content.add(
          '   defaultValue: DataType.UUIDV4,\n',
          isAdd: property.dbTypeName == 'UUID',
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
          isAdd: property.isAutoIncrement || property.typeName == 'number',
        );
        content = content.add(' })\n');

        content = content.add(
          " @Index({ name: '${name}_${property.name}_idx', using: 'btree', unique: true })\n",
          isAdd: property.isCreateIndex ||
              property.isUnique ||
              property.isPrimaryKey,
        );

        final allowNullable = property.allowNullable ? '?' : '!';
        content = content.add(
            ' ${property.name.camelCase}$allowNullable: ${property.typeName};\n\n');
      }
      content = content.add('''
@CreatedAt
@Column({
  allowNull: true,
  type: DataType.DATE,
})
createdAt?: Date;

@UpdatedAt
@Column({
  allowNull: true,
  type: DataType.DATE,
})
updatedAt?: Date;
''');

      final fileContent = file.readAsStringSync();
      final modifiedContent = fileContent.replaceFirst(template, content);
      file.writeAsStringSync(modifiedContent);
    });
  }
}
