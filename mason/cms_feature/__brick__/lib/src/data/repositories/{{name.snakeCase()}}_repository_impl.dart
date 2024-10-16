// Dart imports:
import 'dart:io';

// Package imports:
import 'package:injectable/injectable.dart';
import 'package:retrofit/dio.dart';

// Project imports:
import 'package:dashboard/src/core/extensions/dio_http_response.dart';
import '../../core/error/api_error.dart';
import '../../core/error/error_codes.dart';
import '../../core/params/api_params/{{name.snakeCase()}}_params/{{name.snakeCase()}}_params.dart';
import '../../core/resources/data_state_v1.dart';
import '../../domain/repositories/{{name.snakeCase()}}_repository.dart';
import '../datasources/remote/{{name.snakeCase()}}_service.dart';
import '../models/{{name.snakeCase()}}_response/{{name.snakeCase()}}_response_model.dart';
import '../models/general_response.dart';

@LazySingleton(as: {{name.pascalCase()}}Repository)
class {{name.pascalCase()}}RepositoryImpl implements {{name.pascalCase()}}Repository {
  {{name.pascalCase()}}RepositoryImpl(this._service);

  final {{name.pascalCase()}}Service _service;

  @override
  Future<DataState<{{name.pascalCase()}}PaginationModel?>> get{{name.pascalCase()}}(
    {{name.pascalCase()}}GetParams params,
  ) async {
    try {
      final httpResponse = await _service.get{{name.pascalCase()}}(params);

      if (httpResponse.response.statusCode != HttpStatus.ok) {
        return DataFailed(httpResponse.apiError);
      }

      if (httpResponse.data.code == ErrorCodes.success) {
        return DataSuccess(httpResponse.data.data);
      }

      return DataFailed(
        ApiError(
          code: httpResponse.data.code,
          message: httpResponse.data.message,
        ),
      );
    } on DioException catch (e) {
      return DataFailed(ApiError(message: e.message));
    }
  }

  @override
  Future<DataState<GeneralResponse>> post{{name.pascalCase()}}(
    {{name.pascalCase()}}CreateParams params,
  ) async {
    try {
      final HttpResponse<GeneralResponse> httpResponse =
          await _service.post{{name.pascalCase()}}(params);

      if (httpResponse.response.statusCode != HttpStatus.ok) {
        return DataFailed(httpResponse.apiError);
      }

      if (httpResponse.data.code == ErrorCodes.success) {
        return DataSuccess(httpResponse.data);
      }

      return DataFailed(
        ApiError(
          code: httpResponse.data.code,
          message: httpResponse.data.message,
        ),
      );
    } on DioException catch (e) {
      return DataFailed(ApiError(message: e.message));
    }
  }

  @override
  Future<DataState<GeneralResponse>> delete{{name.pascalCase()}}(
    {{name.pascalCase()}}DeleteParams params,
  ) async {
    try {
      final HttpResponse<GeneralResponse> httpResponse =
          await _service.delete{{name.pascalCase()}}(id: params.id);

      if (httpResponse.response.statusCode != HttpStatus.ok) {
        return DataFailed(httpResponse.apiError);
      }

      if (httpResponse.data.code == ErrorCodes.success) {
        return DataSuccess(httpResponse.data);
      }

      return DataFailed(
        ApiError(
          code: httpResponse.data.code,
          message: httpResponse.data.message,
        ),
      );
    } on DioException catch (e) {
      return DataFailed(ApiError(message: e.message));
    }
  }

  @override
  Future<DataState<GeneralResponse>> put{{name.pascalCase()}}(
    {{name.pascalCase()}}UpdateParams params,
  ) async {
    try {
      final HttpResponse<GeneralResponse> httpResponse =
          await _service.put{{name.pascalCase()}}(params.id, params);

      if (httpResponse.response.statusCode != HttpStatus.ok) {
        return DataFailed(httpResponse.apiError);
      }

      if (httpResponse.data.code == ErrorCodes.success) {
        return DataSuccess(httpResponse.data);
      }

      return DataFailed(
        ApiError(
          code: httpResponse.data.code,
          message: httpResponse.data.message,
        ),
      );
    } on DioException catch (e) {
      return DataFailed(ApiError(message: e.message));
    }
  }
}
