import 'package:json_annotation/json_annotation.dart';

part '{{name.snakeCase()}}_get_params.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class {{name.pascalCase()}}GetParams {
  {{name.pascalCase()}}GetParams({
      this.page = 1,
      this.limit = 15,
      this.loadMore = false,
  });

  final int page;
  final int limit;
  final bool loadMore;

  Map<String, dynamic> toJson() => _${{name.pascalCase()}}GetParamsToJson(this);

  {{name.pascalCase()}}GetParams copyWith({
    int? page,
    int? limit,
    bool? loadMore,
  }) {
    return {{name.pascalCase()}}GetParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      loadMore: loadMore ?? this.loadMore,
    );
  }
}
