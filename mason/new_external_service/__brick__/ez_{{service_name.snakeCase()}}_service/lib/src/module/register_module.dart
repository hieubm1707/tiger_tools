// Package imports:
import 'package:dio/dio.dart';
import 'package:ez_core/ez_core.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import '../core/config/app_config.dart';
import '../core/constant/key.dart';
import '../data/datasources/remote/{{service_name.snakeCase()}}_service.dart';
import '../injector/injector.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  @Named(k{{service_name.pascalCase()}}Network)
  Network get network => Network(
        baseUrl: AppConfig.baseUrl,
        enableLogger: true,
        headers: {
          'Content-Type': 'application/json',
        },
      );
  @Named(k{{service_name.pascalCase()}}ApiDio)
  Dio get apiDio =>
      getItConfig<Network>(instanceName: k{{service_name.pascalCase()}}Network).apiProvider.apiDio;
  @Named(k{{service_name.pascalCase()}}ApiBaseUrl)
  String get apiBaseUrl => getItConfig<Network>(instanceName: k{{service_name.pascalCase()}}Network)
      .apiProvider
      .apiDio
      .options
      .baseUrl;

  @lazySingleton
  {{service_name.pascalCase()}}Service {{service_name.camelCase()}}Service(
    @Named(k{{service_name.pascalCase()}}ApiDio) Dio dio,
    @Named(k{{service_name.pascalCase()}}ApiBaseUrl) String url,
  ) =>
      {{service_name.pascalCase()}}Service(
        dio,
        baseUrl: url,
      );
}
