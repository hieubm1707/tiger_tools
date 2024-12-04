// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateModel _$GenerateModelFromJson(Map<String, dynamic> json) =>
    GenerateModel(
      name: json['name'] as String,
      tableName: json['table_name'] as String,
      properties: (json['properties'] as List<dynamic>)
          .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sortProperty: json['sort_property'] == null
          ? null
          : SortPropertyModel.fromJson(
              json['sort_property'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GenerateModelToJson(GenerateModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'table_name': instance.tableName,
      'sort_property': instance.sortProperty,
      'properties': instance.properties,
    };

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      name: json['name'] as String,
      typeName: json['type_name'] as String,
      dbTypeName: json['db_type_name'] as String,
      isListProperty: json['is_list_property'] as bool? ?? false,
      isShowProperty: json['is_show_property'] as bool? ?? false,
      isEditProperty: json['is_edit_property'] as bool? ?? false,
      isFilterProperty: json['is_filter_property'] as bool? ?? false,
      isPrimaryKey: json['is_primary_key'] as bool? ?? false,
      allowNullable: json['allow_nullable'] as bool? ?? false,
      isUnique: json['is_unique'] as bool? ?? false,
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type_name': instance.typeName,
      'db_type_name': instance.dbTypeName,
      'is_list_property': instance.isListProperty,
      'is_show_property': instance.isShowProperty,
      'is_edit_property': instance.isEditProperty,
      'is_filter_property': instance.isFilterProperty,
      'is_primary_key': instance.isPrimaryKey,
      'allow_nullable': instance.allowNullable,
      'is_unique': instance.isUnique,
    };

SortPropertyModel _$SortPropertyModelFromJson(Map<String, dynamic> json) =>
    SortPropertyModel(
      direction: json['direction'] as String,
      sortBy: json['sort_by'] as String,
    );

Map<String, dynamic> _$SortPropertyModelToJson(SortPropertyModel instance) =>
    <String, dynamic>{
      'direction': instance.direction,
      'sort_by': instance.sortBy,
    };
