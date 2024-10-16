// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/params/api_params/{{name.snakeCase()}}_params/{{name.snakeCase()}}_params.dart';
import '../../../core/resources/data_state_v1.dart';
import '../../../core/usecase/usecase.dart';
import '../../../data/models/general_response.dart';
import '../../repositories/{{name.snakeCase()}}_repository.dart';

@injectable
class Delete{{name.pascalCase()}}UseCase
    implements
        UseCase<DataState<GeneralResponse>, {{name.pascalCase()}}DeleteParams> {
  Delete{{name.pascalCase()}}UseCase(this._{{name.camelCase()}}Repository);

  final {{name.pascalCase()}}Repository _{{name.camelCase()}}Repository;

  @override
  Future<DataState<GeneralResponse>> call({
    required {{name.pascalCase()}}DeleteParams params,
  }) {
    return _{{name.camelCase()}}Repository.delete{{name.pascalCase()}}(params);
  }
}
