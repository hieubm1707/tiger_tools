import 'package:json_annotation/json_annotation.dart';

part 'generate_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GenerateModel {
  final String name;
  final String tableName;
  final SortPropertyModel? sortProperty;
  final List<PropertyModel> properties;

  GenerateModel({
    required this.name,
    required this.tableName,
    required this.properties,
    this.sortProperty,
  });

  factory GenerateModel.fromJson(Map<String, dynamic> json) =>
      _$GenerateModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PropertyModel {
  PropertyModel({
    required this.name,
    required this.typeName,
    required this.dbTypeName,
    this.isListProperty = false,
    this.isShowProperty = false,
    this.isEditProperty = false,
    this.isFilterProperty = false,
    this.isPrimaryKey = false,
    this.allowNullable = false,
    this.isUnique = false,
    this.isCreateIndex = false,
    this.isAutoIncrement = false,
  });

  final String name;
  final String typeName;
  final String dbTypeName;
  final bool isListProperty;
  final bool isShowProperty;
  final bool isEditProperty;
  final bool isFilterProperty;
  final bool isPrimaryKey;
  final bool allowNullable;
  final bool isUnique;
  final bool isCreateIndex;
  final bool isAutoIncrement;

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SortPropertyModel {
  final String direction;
  final String sortBy;

  SortPropertyModel({
    required this.direction,
    required this.sortBy,
  });

  factory SortPropertyModel.fromJson(Map<String, dynamic> json) =>
      _$SortPropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$SortPropertyModelToJson(this);
}
