import 'dart:io';

import 'package:mason/mason.dart';
import 'package:ts_feature_api_hooks/content_extension.dart';
import 'package:ts_feature_api_hooks/generate_model.dart';

Future<void> run(HookContext context) async {
  final hasGetTemplate = context.vars['template'] as bool? ?? false;
  if (hasGetTemplate) {
    return;
  }

  // Add dependencies
  final progress = context.logger.progress('Feature are being fetched...');
  final generateModel = GenerateModel.fromJson(context.vars);
  addModelAttributes(generateModel);
  addTypeAttributes(generateModel);
  addDtoAttributes(generateModel);
  addControllerAttributes(generateModel);
  addAdminJsAttributes(generateModel);
  addMigrateAttributes(generateModel, context.vars);

  await Process.run('bash', ['-c', 'npm run lint:fix']);

  progress.complete('Feature are being fetched');
  context.logger.success('Finished fetching Feature.');
}

void handleWriteFile(
  void Function() run,
) async {
  try {
    run();
  } catch (error, stackTrace) {
    print('Error: $error');
    print('Stack: $stackTrace');
  }
}

void addModelAttributes(GenerateModel generateModel) {
  handleWriteFile(() {
    final name = generateModel.name;
    final file = File('${name.defaultPath}/models/${name.paramCase}.model.ts');
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
      ///  @Column({
      //   primaryKey: true,
      //   type: DataType.UUID,
      //   defaultValue: DataType.UUIDV4,
      // })
      content = content.add(' @@Column({\n');
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
      content = content.add(' })\n');
      content = content.add(
        " @Index({ name: '${name}_${property.name}_idx', using: 'btree', unique: true })\n",
        isAdd: property.isPrimaryKey || property.isUnique,
      );
      final allowNullable = property.allowNullable ? '?' : '!';
      content = content.add(
          ' ${property.name.camelCase}$allowNullable: ${property.typeName};\n');
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

void addTypeAttributes(GenerateModel generateModel) {
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

    var formattedAttributes = "";
    var createAttributes = "";
    var updateAttributes = "";
    var filterAttributes = "";

    for (final property in generateModel.properties) {
      final nullable = property.allowNullable ? '?' : '';
      final content =
          '  ${property.name.camelCase}$nullable: ${property.typeName};\n';
      formattedAttributes = formattedAttributes.add(content);
      createAttributes = createAttributes.add(
        content,
        isAdd: property.isEditProperty,
      );
      updateAttributes = updateAttributes.add(
        content,
        isAdd: property.isEditProperty,
      );
      filterAttributes = filterAttributes.add(
        content,
        isAdd: property.isFilterProperty,
      );
    }
    formattedAttributes = formattedAttributes
        .add('  createdAt?: string;\n  updatedAt?: string;\n');
    filterAttributes =
        filterAttributes.add('  createdAt?: string;\n  updatedAt?: string;\n');

    final fileContent = file.readAsStringSync();
    var modifiedContent = fileContent.replaceFirst(
      '    // insert formatted attributes here',
      formattedAttributes,
    );
    modifiedContent = modifiedContent.replaceFirst(
      '    // insert create attributes here',
      createAttributes,
    );
    modifiedContent = modifiedContent.replaceFirst(
      '    // insert update attributes here',
      updateAttributes,
    );
    modifiedContent = modifiedContent.replaceFirst(
      '    // insert filter attributes here',
      filterAttributes,
    );
    file.writeAsStringSync(modifiedContent);
  });
}

void addDtoAttributes(GenerateModel generateModel) {
  handleWriteFile(() {
    final name = generateModel.name;
    final file = File('${name.defaultPath}/dto/${name.paramCase}.dto.ts');

    var formattedAttributes = "";

    for (final property in generateModel.properties) {
      final content =
          '  ${property.name.camelCase}: ${name.camelCase}.${property.name.camelCase},\n';
      formattedAttributes = formattedAttributes.add(content);
    }
    formattedAttributes =
        formattedAttributes.add(' createdAt: ${name.camelCase}.createdAt,\n');
    formattedAttributes =
        formattedAttributes.add(' updatedAt: ${name.camelCase}.updatedAt,\n');

    final fileContent = file.readAsStringSync();
    var modifiedContent = fileContent.replaceFirst(
      '    // insert formatted attributes here',
      formattedAttributes,
    );
    file.writeAsStringSync(modifiedContent);
  });
}

void addControllerAttributes(GenerateModel generateModel) {
  handleWriteFile(() {
    final name = generateModel.name;
    final file =
        File('${name.defaultPath}/controllers/${name.paramCase}.controller.ts');

    var createAttributes = "";
    var updateAttributes = "";

    for (final property in generateModel.properties) {
      if (!property.isEditProperty) continue;
      //name: validation.schemas.title.required(),
      final isRequired = property.allowNullable ? '.required()' : '';
      final content =
          '      ${property.name.camelCase}: validation.schemas.title$isRequired,\n';
      createAttributes = createAttributes.add(content);
      updateAttributes = updateAttributes.add(content);
    }
    final todo = '  // TODO: recheck this validation';
    createAttributes = createAttributes.add(todo);
    updateAttributes = updateAttributes.add(todo);

    final fileContent = file.readAsStringSync();
    var modifiedContent = fileContent.replaceFirst(
      '    // insert create attributes here',
      createAttributes,
    );
    modifiedContent = modifiedContent.replaceFirst(
      '    // insert update attributes here',
      updateAttributes,
    );
    file.writeAsStringSync(modifiedContent);
  });
}

void addAdminJsAttributes(GenerateModel generateModel) {
  handleWriteFile(() {
    final name = generateModel.name;
    final resourceFile = File(
        '${name.defaultPath}/admin/resources/${name.paramCase}.resource.ts');
    final properties = generateModel.properties;
    var listAttributes = properties
        .where((element) => element.isListProperty)
        .map((e) => '\'${e.name.camelCase}\'')
        .toList();
    var showAttributes = properties
        .where((element) => element.isShowProperty)
        .map((e) => '\'${e.name.camelCase}\'')
        .toList();
    var editAttributes = properties
        .where((element) => element.isEditProperty)
        .map((e) => '\'${e.name.camelCase}\'')
        .toList();
    var filterAttributes = properties
        .where((element) => element.isFilterProperty)
        .map((e) => '\'${e.name.camelCase}\'')
        .toList();

    final resourceContent = resourceFile.readAsStringSync();
    var modifiedResourceContent = resourceContent.replaceFirst(
      '// insert list here',
      '${listAttributes.toString()},',
    );
    modifiedResourceContent = modifiedResourceContent.replaceFirst(
      '// insert show here',
      '${showAttributes.toString()},',
    );
    modifiedResourceContent = modifiedResourceContent.replaceFirst(
      '// insert edit here',
      '${editAttributes.toString()},',
    );
    modifiedResourceContent = modifiedResourceContent.replaceFirst(
      '// insert filter here',
      '${filterAttributes.toString()},',
    );
    modifiedResourceContent = modifiedResourceContent.replaceFirst(
      '// insert sort here',
      '''{
        direction: '${generateModel.sortProperty?.direction}',
        sortBy: '${generateModel.sortProperty?.sortBy}',
      },''',
    );
    resourceFile.writeAsStringSync(modifiedResourceContent);
  });
}

void addMigrateAttributes(
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
      content = content.add('comment: \'${property.name} of the ${name}\',\n');
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
