// Package imports:
import 'package:json_annotation/json_annotation.dart';

part '{{service_name.snakeCase()}}_info_params.g.dart';

@JsonSerializable()
class {{service_name.pascalCase()}}InfoParams {
  {{service_name.pascalCase()}}InfoParams({
    this.page,
    this.limit,
  });

  final int? page;
  int? limit;
  factory {{service_name.pascalCase()}}InfoParams.fromJson(Map<String, dynamic> json) =>
      _${{service_name.pascalCase()}}InfoParamsFromJson(json);

  Map<String, dynamic> toJson() => _${{service_name.pascalCase()}}InfoParamsToJson(this);
}
