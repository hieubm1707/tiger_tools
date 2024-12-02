// ignore_for_file: inference_failure_on_function_return_type

// Package imports:
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'injector.config.dart';

GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: true)
GetIt configInjector({
  String? env,
  EnvironmentFilter? environmentFilter,
}) {
  return getIt.init(
    environmentFilter: environmentFilter,
    environment: env,
  );
}
