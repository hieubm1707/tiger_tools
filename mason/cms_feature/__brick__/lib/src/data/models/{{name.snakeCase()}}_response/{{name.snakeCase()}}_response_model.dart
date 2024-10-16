// Package imports:
import 'package:json_annotation/json_annotation.dart';

import '../general_response.dart';
import '../pagination_model.dart';
import '{{name.snakeCase()}}_model.dart';

part '{{name.snakeCase()}}_response_model.g.dart';

@JsonSerializable(createToJson: false)
class {{name.pascalCase()}}ResponseModel extends GeneralResponse {
  {{name.pascalCase()}}ResponseModel({
    required super.status,
    required super.code,
    required super.message,
    required this.data,
  });

  factory {{name.pascalCase()}}ResponseModel.fromJson(Map<String, dynamic> json) =>
      _${{name.pascalCase()}}ResponseModelFromJson(json);

  final {{name.pascalCase()}}PaginationModel? data;
}

@JsonSerializable(createToJson: false)
class {{name.pascalCase()}}PaginationModel extends PaginationModel {
  {{name.pascalCase()}}PaginationModel({
    super.page,
    super.total,
    super.totalPage,
    super.loadMore,
    this.items,
  });

  final List<{{name.pascalCase()}}Model>? items;

  factory {{name.pascalCase()}}PaginationModel.fromJson(Map<String, dynamic> json) =>
      _${{name.pascalCase()}}PaginationModelFromJson(json);
}
