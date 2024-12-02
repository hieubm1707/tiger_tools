// Dart imports:
// ignore_for_file: cascade_invocations

import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:ez_core/ez_core.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../core/constant/constant.dart';
import '../../core/params/params.dart';
import '../../domain/repositories/{{service_name.snakeCase()}}_repository.dart';
import '../datasources/remote/{{service_name.snakeCase()}}_service.dart';
import '../models/api_models.dart';

// Project imports:

@LazySingleton(as: {{service_name.pascalCase()}}Repository)
class {{service_name.pascalCase()}}RepositoryImpl implements {{service_name.pascalCase()}}Repository {
  {{service_name.pascalCase()}}RepositoryImpl(this._{{service_name.camelCase()}}Service);
  final {{service_name.pascalCase()}}Service _{{service_name.camelCase()}}Service;

  @override
  Future<ServiceState<{{service_name.pascalCase()}}InfoResponse?>> getInfo(
    {{service_name.pascalCase()}}InfoParams params,
  ) async {
    try {

      final httpResponse = await _{{service_name.camelCase()}}Service.getInfo(params);
      final response = httpResponse.data;
      if (httpResponse.response.statusCode == HttpStatus.ok &&
          response?.status == ServiceConstant.successStatus &&
          response?.code == ServiceConstant.successCode) {
        return ServiceSuccess(response);
      }
      return ServiceFailed(
        ApiError(
          status: response?.status ?? httpResponse.response.statusCode,
          message: response?.message ?? httpResponse.response.statusMessage,
          code: response?.code,
          data: response?.data,
        ),
      );
    } catch (error, stacktrace) {
      return handleException(
        error,
        stacktrace,
        serviceName: ServiceConstant.appName,
      );
    }
  }
}
