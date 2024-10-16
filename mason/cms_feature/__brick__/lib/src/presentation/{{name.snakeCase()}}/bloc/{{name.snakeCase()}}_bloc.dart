// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/error/api_error.dart';
import '../../../core/params/api_params/{{name.snakeCase()}}_params/{{name.snakeCase()}}_params.dart';
import '../../../core/resources/data_state_v1.dart';
import '../../../core/utils/constants/constants.dart';
import '../../../data/models/{{name.snakeCase()}}_response/{{name.snakeCase()}}_model.dart';
import '../../../domain/use_cases/{{name.snakeCase()}}_use_cases/create_{{name.snakeCase()}}_use_case.dart';
import '../../../domain/use_cases/{{name.snakeCase()}}_use_cases/delete_{{name.snakeCase()}}_use_case.dart';
import '../../../domain/use_cases/{{name.snakeCase()}}_use_cases/get_{{name.snakeCase()}}_use_case.dart';
import '../../../domain/use_cases/{{name.snakeCase()}}_use_cases/update_{{name.snakeCase()}}_use_case.dart';

part '{{name.snakeCase()}}_event.dart';
part '{{name.snakeCase()}}_state.dart';

@injectable
class {{name.pascalCase()}}Bloc
    extends Bloc<{{name.pascalCase()}}Event, {{name.pascalCase()}}State> {
  {{name.pascalCase()}}Bloc(
    this._get{{name.pascalCase()}}UseCase,
    this._post{{name.pascalCase()}}UseCase,
    this._delete{{name.pascalCase()}}UseCase,
    this._put{{name.pascalCase()}}UseCase,
  ) : super({{name.pascalCase()}}Initial()) {
    on<{{name.pascalCase()}}Loaded>(loaded);
    on<{{name.pascalCase()}}Created>(created);
    on<{{name.pascalCase()}}Deleted>(deleted);
    on<{{name.pascalCase()}}Updated>(uploaded);
  }

  final Get{{name.pascalCase()}}UseCase _get{{name.pascalCase()}}UseCase;
  final Create{{name.pascalCase()}}UseCase _post{{name.pascalCase()}}UseCase;
  final Delete{{name.pascalCase()}}UseCase _delete{{name.pascalCase()}}UseCase;
  final Update{{name.pascalCase()}}UseCase _put{{name.pascalCase()}}UseCase;
  {{name.pascalCase()}}GetParams {{name.camelCase()}}GetParams = {{name.pascalCase()}}GetParams();

  Future<void> loaded(
    {{name.pascalCase()}}Loaded event,
    Emitter<{{name.pascalCase()}}State> emit,
  ) async {
    emit({{name.pascalCase()}}LoadInProgress());
     if (event.params.loadMore) {
      {{name.camelCase()}}GetParams = {{name.camelCase()}}GetParams.copyWith(page: event.params.page);
    } else {
      {{name.camelCase()}}GetParams = event.params;
    }
    final dataState = await _get{{name.pascalCase()}}UseCase.call(
      params: {{name.camelCase()}}GetParams
    );

    if (dataState is DataSuccess && dataState.data != null) {
     final data = dataState.data;
      emit(
        {{name.pascalCase()}}LoadSuccess(
          data: data?.items ?? [],
          total: data?.total ?? 0,
          page: {{name.camelCase()}}GetParams.page,
          totalPage: data?.totalPage ?? 1,
        ),
      );
    }

    if (dataState is DataFailed) {
      emit({{name.pascalCase()}}LoadFailure(dataState.error));
    }
  }

  Future<void> created(
    {{name.pascalCase()}}Created event,
    Emitter<{{name.pascalCase()}}State> emit,
  ) async {
    emit({{name.pascalCase()}}LoadInProgress());
    final dataState =
        await _post{{name.pascalCase()}}UseCase.call(params: event.params);

    if (dataState is DataSuccess) {
      if (dataState.data?.status == HttpStatus.ok) {
        emit(
          {{name.pascalCase()}}UpdateSuccess(AppStrings.commonCreateSuccess),
        );
        await loaded(
          {{name.pascalCase()}}Loaded(params: {{name.camelCase()}}GetParams),
          emit,
        );
      } else {
        emit({{name.pascalCase()}}UpdateFailure(dataState.error));
      }
    } else {
      emit({{name.pascalCase()}}UpdateFailure(dataState.error));
    }
  }

  Future<void> deleted(
    {{name.pascalCase()}}Deleted event,
    Emitter<{{name.pascalCase()}}State> emit,
  ) async {
    emit({{name.pascalCase()}}LoadInProgress());
    final dataState = await _delete{{name.pascalCase()}}UseCase.call(
      params: {{name.pascalCase()}}DeleteParams(event.id),
    );

    if (dataState is DataSuccess) {
      if (dataState.data?.status == HttpStatus.ok) {
        emit(
          {{name.pascalCase()}}UpdateSuccess(AppStrings.commonDeleteSuccess),
        );
        await loaded(
          {{name.pascalCase()}}Loaded(params: {{name.camelCase()}}GetParams),
          emit,
        );
      } else {
        emit({{name.pascalCase()}}UpdateFailure(dataState.error));
      }
    } else {
      emit({{name.pascalCase()}}UpdateFailure(dataState.error));
    }
  }

  Future<void> uploaded(
    {{name.pascalCase()}}Updated event,
    Emitter<{{name.pascalCase()}}State> emit,
  ) async {
    emit({{name.pascalCase()}}LoadInProgress());
    final dataState =
        await _put{{name.pascalCase()}}UseCase.call(params: event.params);

    if (dataState is DataSuccess) {
      if (dataState.data?.status == HttpStatus.ok) {
        emit(
          {{name.pascalCase()}}UpdateSuccess(AppStrings.commonUpdateSuccess),
        );
        await loaded(
          {{name.pascalCase()}}Loaded(params: {{name.camelCase()}}GetParams),
          emit,
        );
      } else {
        emit({{name.pascalCase()}}UpdateFailure(dataState.error));
      }
    } else {
      emit({{name.pascalCase()}}UpdateFailure(dataState.error));
    }
  }
}
