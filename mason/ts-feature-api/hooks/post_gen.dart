import 'dart:io';

import 'package:mason/mason.dart';
import 'package:ts_feature_api_hooks/content_extension.dart';
import 'package:ts_feature_api_hooks/generate_model.dart';

Future<void> run(HookContext context) async {
  final hasGetTemplate = context.vars['template'] as bool? ?? false;
  if (hasGetTemplate) {
    return;
  }
  final name = context.vars['name'] as String?;
  final tableName = context.vars['table_name'] as String?;
  final properties = context.vars['properties'] as List?;
  if (name == null || tableName == null || properties == null) {
    context.logger.err('Missing required template variables.');
    return;
  }

  // Add dependencies
  final progress = context.logger.progress('Feature are being fetched...');
  final generateModel = GenerateModel.fromJson(context.vars);
  addModelProperties(generateModel);
  addTypeProperties(generateModel);
  addDtoProperties(generateModel);
  addControllerProperties(generateModel);
  addAdminJsProperties(generateModel);
  addMigrateProperties(generateModel, context.vars);
  handleUniqueProperties(generateModel);

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

void addModelProperties(GenerateModel generateModel) {
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
      content = content.add(' })\n');
      content = content.add(
        " @Index({ name: '${name}_${property.name}_idx', using: 'btree', unique: true })\n",
        isAdd: property.isPrimaryKey || property.isUnique,
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

void addTypeProperties(GenerateModel generateModel) {
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

void addDtoProperties(GenerateModel generateModel) {
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

void addControllerProperties(GenerateModel generateModel) {
  handleWriteFile(() {
    final name = generateModel.name;
    final file =
        File('${name.defaultPath}/controllers/${name.paramCase}.controller.ts');

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

void addAdminJsProperties(GenerateModel generateModel) {
  handleWriteFile(() {
    final name = generateModel.name;
    final resourceFile = File(
        '${name.defaultPath}/admin/resources/${name.paramCase}.resource.ts');
    final properties = generateModel.properties;
    var listProperties = properties
        .where((element) => element.isListProperty)
        .map((e) => '\'${e.name.camelCase}\'')
        .toList();
    var showProperties = properties
        .where((element) => element.isShowProperty)
        .map((e) => '\'${e.name.camelCase}\'')
        .toList();
    var editProperties = properties
        .where((element) => element.isEditProperty)
        .map((e) => '\'${e.name.camelCase}\'')
        .toList();
    var filterProperties = properties
        .where((element) => element.isFilterProperty)
        .map((e) => '\'${e.name.camelCase}\'')
        .toList();
    final dateProperties = ['\'createdAt\'', '\'updatedAt\''];

    listProperties.addAll(dateProperties);
    showProperties.addAll(dateProperties);

    final resourceContent = resourceFile.readAsStringSync();
    var modifiedResourceContent = resourceContent.replaceFirst(
      '// insert list here',
      '${listProperties.toString()},',
    );
    modifiedResourceContent = modifiedResourceContent.replaceFirst(
      '// insert show here',
      '${showProperties.toString()},',
    );
    modifiedResourceContent = modifiedResourceContent.replaceFirst(
      '// insert edit here',
      '${editProperties.toString()},',
    );
    modifiedResourceContent = modifiedResourceContent.replaceFirst(
      '// insert filter here',
      '${filterProperties.toString()},',
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

void addMigrateProperties(
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

void handleUniqueProperties(GenerateModel generateModel) {
  final name = generateModel.name;
  final properties = generateModel.properties.where((e) => e.isUnique).toList();
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
