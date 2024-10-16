// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

// Project imports:
import '../../../core/constants/keys.dart';
import '../../../core/network/end_points.dart';
import '../../../core/params/api_params/{{name.snakeCase()}}_params/{{name.snakeCase()}}_params.dart';
import '../../models/{{name.snakeCase()}}_response/{{name.snakeCase()}}_response_model.dart';
import '../../models/general_response.dart';

part '{{name.snakeCase()}}_service.g.dart';

@lazySingleton
@RestApi()
abstract class {{name.pascalCase()}}Service {
  @factoryMethod
  factory {{name.pascalCase()}}Service(
    @Named(kApiDio) Dio dio, {
    @Named(kApiBaseUrl) required String baseUrl,
  }) = _{{name.pascalCase()}}Service;

  @GET(EndPoints.{{name.camelCase()}})
  Future<HttpResponse<{{name.pascalCase()}}ResponseModel>> get{{name.pascalCase()}}(
     @Queries() {{name.pascalCase()}}GetParams params,
  );

  @POST(EndPoints.{{name.camelCase()}})
  Future<HttpResponse<GeneralResponse>> post{{name.pascalCase()}}(
    @Body() {{name.pascalCase()}}CreateParams params,
  );

  @DELETE(EndPoints.update{{name.pascalCase()}})
  Future<HttpResponse<GeneralResponse>> delete{{name.pascalCase()}}({
    @Path('id') required String id,
  });

  @PUT(EndPoints.update{{name.pascalCase()}})
  Future<HttpResponse<GeneralResponse>> put{{name.pascalCase()}}(
    @Path('id') String id,
    @Body() {{name.pascalCase()}}UpdateParams params,
  );
}
