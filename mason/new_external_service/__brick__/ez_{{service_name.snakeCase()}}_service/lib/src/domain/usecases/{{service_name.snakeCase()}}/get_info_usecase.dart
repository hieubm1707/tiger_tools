// Package imports:

// Package imports:
import 'package:ez_core/ez_core.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../../../core/params/params.dart';
import '../../../data/models/api_models.dart';
import '../../repositories/{{service_name.snakeCase()}}_repository.dart';

@injectable
class GetInfoUseCase
    implements UseCase<ServiceState<{{service_name.pascalCase()}}InfoResponse?>, {{service_name.pascalCase()}}InfoParams> {
  GetInfoUseCase(this._{{service_name.camelCase()}}Repository);

  final {{service_name.pascalCase()}}Repository _{{service_name.camelCase()}}Repository;

  @override
  Future<ServiceState<{{service_name.pascalCase()}}InfoResponse?>> call(
    {{service_name.pascalCase()}}InfoParams params,
  ) {
    return _{{service_name.camelCase()}}Repository.getInfo(params);
  }
}
