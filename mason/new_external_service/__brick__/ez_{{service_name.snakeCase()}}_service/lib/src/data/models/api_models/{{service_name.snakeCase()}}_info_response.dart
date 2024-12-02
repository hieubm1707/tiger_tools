// Package imports:
import 'package:json_annotation/json_annotation.dart';

part '{{service_name.snakeCase()}}_info_response.g.dart';

@JsonSerializable()
class {{service_name.pascalCase()}}InfoResponse {
  final int? status;
  final String? message;
  final int? code;
  final {{service_name.pascalCase()}}InfoResponseData? data;

  {{service_name.pascalCase()}}InfoResponse({
    this.status,
    this.message,
    this.data,
    this.code,
  });

  factory {{service_name.pascalCase()}}InfoResponse.fromJson(Map<String, dynamic> json) =>
      _${{service_name.pascalCase()}}InfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _${{service_name.pascalCase()}}InfoResponseToJson(this);
}

@JsonSerializable()
class {{service_name.pascalCase()}}InfoResponseData {
  final String? id;
  final String? name;

  {{service_name.pascalCase()}}InfoResponseData({
    this.id,
    this.name,
  });

  factory {{service_name.pascalCase()}}InfoResponseData.fromJson(Map<String, dynamic> json) =>
      _${{service_name.pascalCase()}}InfoResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _${{service_name.pascalCase()}}InfoResponseDataToJson(this);
}
