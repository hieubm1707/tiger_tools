// Package imports:
import 'package:json_annotation/json_annotation.dart';

part '{{name.snakeCase()}}_model.g.dart';

@JsonSerializable(explicitToJson: true)
class {{name.pascalCase()}}Model {
  {{name.pascalCase()}}Model({
    required this.id,
    required this.title,
    required this.icon,
    required this.active,
    required this.sort,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
    this.updatedBy,
  });

  factory {{name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) =>
      _${{name.pascalCase()}}ModelFromJson(json);

  Map<String, dynamic> toJson() => _${{name.pascalCase()}}ModelToJson(this);
  

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'icon')
  final String icon;

  @JsonKey(name: 'active')
  final bool active;

  @JsonKey(name: 'sort')
  final int sort;

  @JsonKey(name: 'created_by')
  final String createdBy;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @JsonKey(name: 'updated_by')
  final String? updatedBy;
}
