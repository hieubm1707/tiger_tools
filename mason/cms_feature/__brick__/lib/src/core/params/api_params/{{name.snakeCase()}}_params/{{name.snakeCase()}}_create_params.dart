// Package imports:
import 'package:json_annotation/json_annotation.dart';

part '{{name.snakeCase()}}_create_params.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class {{name.pascalCase()}}CreateParams {
  {{name.pascalCase()}}CreateParams({
    required this.title,
    required this.icon,
    required this.active,
    required this.sort,
  });

  factory {{name.pascalCase()}}CreateParams.fromJson(Map<String, dynamic> json) =>
      _${{name.pascalCase()}}CreateParamsFromJson(json);

  Map<String, dynamic> toJson() => _${{name.pascalCase()}}CreateParamsToJson(this);

  final String title;
  final String icon;
  final bool active;
  final int sort;
}
