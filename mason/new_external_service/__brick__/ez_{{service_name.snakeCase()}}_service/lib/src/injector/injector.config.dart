// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:ez_core/ez_core.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/datasources/remote/sms.dart' as _i5;
import '../data/repositories/sms_repository_impl.dart' as _i7;
import '../domain/repositories/sms_repository.dart' as _i6;
import '../domain/usecases/sms/send_otp_usecase.dart' as _i8;
import '../module/register_module.dart' as _i9;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i3.Dio>(
      () => registerModule.apiDio,
      instanceName: 'sms_api_dio',
    );
    gh.lazySingleton<_i4.Network>(
      () => registerModule.network,
      instanceName: 'sms_network',
    );
    gh.factory<String>(
      () => registerModule.apiBaseUrl,
      instanceName: 'sms_api_base_url',
    );
    gh.lazySingleton<_i5.SmsService>(() => registerModule.smsService(
          gh<_i3.Dio>(instanceName: 'sms_api_dio'),
          gh<String>(instanceName: 'sms_api_base_url'),
        ));
    gh.lazySingleton<_i6.SmsRepository>(
        () => _i7.SmsRepositoryImple(gh<_i5.SmsService>()));
    gh.factory<_i8.SendOTPUseCase>(
        () => _i8.SendOTPUseCase(gh<_i6.SmsRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i9.RegisterModule {}
