import 'package:dart_frog/dart_frog.dart';
import 'package:ez_{{service_name.snakeCase()}}_service/ez_{{service_name.snakeCase()}}_service.dart';

final ez{{service_name.pascalCase()}}Service = Ez{{service_name.pascalCase()}}Service();

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(
    provider<Ez{{service_name.pascalCase()}}Service>(
      (RequestContext context) {
        return ez{{service_name.pascalCase()}}Service;
      },
    ),
  );
}
