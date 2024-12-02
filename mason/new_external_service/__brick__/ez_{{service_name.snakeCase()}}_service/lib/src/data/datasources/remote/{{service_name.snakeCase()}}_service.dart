// Package imports:
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

// Project imports:
import '../../../core/params/params.dart';
import '../../models/api_models.dart';

part '{{service_name.snakeCase()}}_service.g.dart';

@RestApi()
abstract class {{service_name.pascalCase()}}Service {
  factory {{service_name.pascalCase()}}Service(Dio dio, {String baseUrl}) = _{{service_name.pascalCase()}}Service;

  @POST('')
  Future<HttpResponse<{{service_name.pascalCase()}}InfoResponse?>> getInfo(
    @Queries() {{service_name.pascalCase()}}InfoParams params,
  );
}
