// Project imports:
import '../../core/params/api_params/{{name.snakeCase()}}_params/{{name.snakeCase()}}_params.dart';
import '../../core/resources/data_state_v1.dart';
import '../../data/models/{{name.snakeCase()}}_response/{{name.snakeCase()}}_response_model.dart';
import '../../data/models/general_response.dart';

abstract class {{name.pascalCase()}}Repository {
  Future<DataState<{{name.pascalCase()}}PaginationModel?>> get{{name.pascalCase()}}(
    {{name.pascalCase()}}GetParams params,
  );

  Future<DataState<GeneralResponse>> post{{name.pascalCase()}}(
    {{name.pascalCase()}}CreateParams params,
  );

  Future<DataState<GeneralResponse>> delete{{name.pascalCase()}}(
    {{name.pascalCase()}}DeleteParams params,
  );

  Future<DataState<GeneralResponse>> put{{name.pascalCase()}}(
    {{name.pascalCase()}}UpdateParams params,
  );
}
