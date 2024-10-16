// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/params/api_params/{{name.snakeCase()}}_params/{{name.snakeCase()}}_params.dart';
import '../../../core/resources/data_state_v1.dart';
import '../../../core/usecase/usecase.dart';
import '../../../data/models/{{name.snakeCase()}}_response/{{name.snakeCase()}}_response_model.dart';
import '../../repositories/{{name.snakeCase()}}_repository.dart';

@injectable
class Get{{name.pascalCase()}}UseCase
    implements
        UseCase<DataState<{{name.pascalCase()}}PaginationModel?>,
            {{name.pascalCase()}}GetParams> {
  Get{{name.pascalCase()}}UseCase(this._{{name.camelCase()}}Repository);

  final {{name.pascalCase()}}Repository _{{name.camelCase()}}Repository;

  @override
  Future<DataState<{{name.pascalCase()}}PaginationModel?>> call({
    required {{name.pascalCase()}}GetParams params,
  }) {
    return _{{name.camelCase()}}Repository.get{{name.pascalCase()}}(params);
  }
}
