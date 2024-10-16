import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;

  addNewEndPoints(name);
  addNewLocale(name, 'packages/ez_intl/lib/l10n/arb/app_en.arb');
  addNewLocale(name, 'packages/ez_intl/lib/l10n/arb/app_vi.arb');
  addNewRouter(name);
  addNewRoutePath(name);
  addPathToEnv(name, 'env/env.development.json');
  addPathToEnv(name, 'env/env.staging.json');
  addPathToEnv(name, 'env/env.production.json');

  // Add dependencies
  final progress =
      context.logger.progress('Dart packages are being fetched...');
  await Process.run('bash', [
    '-c',
    'sh scripts/generate_intl.sh',
  ]);
  await Process.run('bash', [
    '-c',
    'fvm flutter pub run build_runner build --delete-conflicting-outputs',
  ]);
  await Process.run('bash', [
    '-c',
    'dart format .',
  ]);

  progress.complete('Dart packages are being fetched');
  context.logger.success('Finished fetching Dart packages.');
}

void addNewEndPoints(String name) {
  final file = File('lib/src/core/network/end_points.dart');
  try {
    const template = '///// Add new here';
    final newEndPoint = """
  // GET, POST ${name.pascalCase}
  static const String ${name.camelCase} = '/admin/${name.paramCase}';
  // PUT, DELETE ${name.pascalCase} by id
  static const String update${name.pascalCase} = '/admin/${name.paramCase}/{id}';
  ///// Add new here
""";

    final content = file.readAsStringSync();
    final modifiedContent = content.replaceFirst(template, newEndPoint);
    file.writeAsStringSync(modifiedContent);
  } catch (_) {}
}

void addNewLocale(String name, String path) {
  final file = File(path);
  try {
    const template = '''
  }
}''';

    final newLocale = '''
  },
  "${name.camelCase}Title": "${name.titleCase}",
  "@${name.camelCase}Title": {
    "type": "text",
    "placeholders": {}
  },
  "delete${name.pascalCase}": "Xoá menu ${name.titleCase}",
  "@delete${name.pascalCase}": {
    "type": "text",
    "placeholders": {}
  },
  "delete${name.pascalCase}Desc": "Bạn có chắc chắn muốn xoá ${name.titleCase} này không?",
  "@delete${name.pascalCase}Desc": {
    "type": "text",
    "placeholders": {}
  }
}''';

    final content = file.readAsStringSync();
    final modifiedContent = content.replaceFirst(template, newLocale);
    file.writeAsStringSync(modifiedContent);
  } catch (_) {}
}

void addNewRouter(String name) {
  final file = File('lib/src/core/routes/app_router.dart');
  try {
    const template = '''///// Add new here''';

    final newLocale = '''
AutoRoute(
          guards: [ActiveRouterGuard()],
          page: ${name.pascalCase}Route.page,
          path: Routes.${name.camelCase},
          maintainState: false,
        ),
///// Add new here''';

    final content = file.readAsStringSync();
    final modifiedContent = content.replaceFirst(template, newLocale);
    file.writeAsStringSync(modifiedContent);
  } catch (_) {}
}

void addNewRoutePath(String name) {
  final file = File('lib/src/core/routes/routes.dart');
  try {
    const template = '''///// Add new here''';

    final newLocale = '''
  static const String ${name.camelCase} = '${name.paramCase}';
///// Add new here''';

    final content = file.readAsStringSync();
    final modifiedContent = content.replaceFirst(template, newLocale);
    file.writeAsStringSync(modifiedContent);
  } catch (_) {}
}

void addPathToEnv(String name, String path) {
  final file = File(path);

  try {
    const template = '''"
    ],
    "DETAIL_SCREEN_TYPE":''';

    final newLocale = '''",
        "${name.paramCase}"
    ],
    "DETAIL_SCREEN_TYPE":''';

    final content = file.readAsStringSync();
    final modifiedContent = content.replaceFirst(template, newLocale);
    file.writeAsStringSync(modifiedContent);
  } catch (_) {}
}
