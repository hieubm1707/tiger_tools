// Package imports:
import 'package:json_annotation/json_annotation.dart';

part '{{name.snakeCase()}}_update_params.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class {{name.pascalCase()}}UpdateParams {
  {{name.pascalCase()}}UpdateParams({
    required this.id,
    this.title,
    this.icon,
    this.active,
    this.sort,
  });

  factory {{name.pascalCase()}}UpdateParams.fromJson(Map<String, dynamic> json) =>
      _${{name.pascalCase()}}UpdateParamsFromJson(json);

  Map<String, dynamic> toJson() => _${{name.pascalCase()}}UpdateParamsToJson(this);

  final String id;
  final String? title;
  final String? icon;
  final bool? active;
  final int? sort;
}
