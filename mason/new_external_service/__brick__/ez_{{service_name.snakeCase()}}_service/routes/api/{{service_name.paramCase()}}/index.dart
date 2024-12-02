import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:ez_core/ez_core.dart';
import 'package:ez_{{service_name.snakeCase()}}_service/ez_{{service_name.snakeCase()}}_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    return _get(context);
  }

  return Response(
    statusCode: HttpStatus.methodNotAllowed,
  );
}

Future<Response> _get(RequestContext context) async {
  try {
    final getInfoUseCase = await getIt<Get{{service_name.pascalCase()}}InfoUseCase>();
    final params = context.request.uri.queryParameters;

    final response = await getInfoUseCase({{service_name.pascalCase()}}InfoGetParams.fromJson(params));
    return response.handleResponse(context);
  } catch (error) {
    return Response.json(
      body: ClientResponse.systemError(context, error: error),
    );
  }
}
