// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/params/api_params/{{name.snakeCase()}}_params/{{name.snakeCase()}}_params.dart';
import '../../../core/resources/data_state_v1.dart';
import '../../../core/usecase/usecase.dart';
import '../../../data/models/general_response.dart';
import '../../repositories/{{name.snakeCase()}}_repository.dart';

@injectable
class Update{{name.pascalCase()}}UseCase
    implements
        UseCase<DataState<GeneralResponse>, {{name.pascalCase()}}UpdateParams> {
  Update{{name.pascalCase()}}UseCase(this._homeFloatButtonRepository);

  final {{name.pascalCase()}}Repository _homeFloatButtonRepository;

  @override
  Future<DataState<GeneralResponse>> call({
    required {{name.pascalCase()}}UpdateParams params,
  }) {
    return _homeFloatButtonRepository.put{{name.pascalCase()}}(params);
  }
}
