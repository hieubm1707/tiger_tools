// Dart imports:
// ignore_for_file: one_member_abstracts

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:ez_core/ez_core.dart';

// Project imports:
import '../../core/params/params.dart';
import '../../data/models/api_models.dart';

abstract class {{service_name.pascalCase()}}Repository {
  Future<ServiceState<{{service_name.pascalCase()}}InfoResponse?>> getInfo(
    {{service_name.pascalCase()}}InfoParams body,
  );
}
