import 'dart:io';

import 'package:mason/mason.dart';

import 'content_extension.dart';
import 'generate_model.dart';
import 'generation_helper.dart';

class AdminResourceGeneration {
  static void addAdminJsProperties(GenerateModel generateModel) {
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
}
